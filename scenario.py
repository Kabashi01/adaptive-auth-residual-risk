#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import sys
import os
import re
import time
import resource
from datetime import datetime
from typing import Dict, Any, List, Optional, Tuple
import re
from typing import Dict
from typing import Optional, Dict, Any
import argparse
import math
try:
    import psutil
except ImportError:
    psutil = None

# ----------------------------
# Z3 command (stdin SMT-LIB)
# ----------------------------
Z3_COMMAND = ["z3", "-smt2", "-in"]

BASE_DIR = "."  # Scenario folders live here: ./Scenario2/...

ADAPT_FILENAME_TEMPLATE = "adapt_model_S{sid}.smt2"
RESIDUAL_FILENAME = "residual_model_S{sid}.smt2"




def _mean_std(xs: List[float]) -> Tuple[float, float]:
    if not xs:
        return (float("nan"), float("nan"))
    m = sum(xs) / len(xs)
    if len(xs) == 1:
        return (m, 0.0)
    var = sum((x - m) ** 2 for x in xs) / (len(xs) - 1)
    return (m, math.sqrt(var))




def _print_overhead_mean_std(phase_summaries: List[Dict[str, Any]], label: str) -> None:
    """phase_summaries: list of ms-summaries for a given phase, one per run."""
    def collect(key: str) -> List[float]:
        xs = []
        for s in phase_summaries:
            v = s.get(key, float("nan"))
            if isinstance(v, (int, float)) and not math.isnan(v):
                xs.append(float(v))
        return xs

    metrics = [
        ("calls", "calls"),
        ("wall_sum_ms", "wall_sum_ms"),
        ("wall_avg_ms", "wall_avg_ms"),
        ("z3_sum_ms", "z3_sum_ms"),
        ("z3_avg_ms", "z3_avg_ms"),
        ("z3_time_coverage_ratio", "z3_time_coverage_ratio"),
        ("peak_rss_mb", "peak_rss_mb"),
        ("z3_mem_avg_mb", "z3_mem_avg_mb"),
    ]

    print(f"\n================ {label} OVERHEAD (mean ± std) ================")
    for k, name in metrics:
        xs = collect(k)
        mu, sd = _mean_std(xs)
        if not xs:
            print(f"{name:22s}: NA")
            continue
        if k == "calls":
            print(f"{name:22s}: {mu:.2f} ± {sd:.2f}")
        elif k == "z3_time_coverage_ratio":
            print(f"{name:22s}: {mu:.3f} ± {sd:.3f}")
        else:
            print(f"{name:22s}: {mu:.2f} ± {sd:.2f}")


def parse_z3_stats(text: str) -> Dict[str, Any]:
    """
    Parse Z3 statistics from text that may contain either:
      1) parenthesized pairs:   (:time 0.01) (:decisions 123)
      2) flat key-value pairs:  :time 0.01 :memory 12.3 :total-time 0.01
    We only parse keys that start with ':' to avoid mixing with get-value output.
    """
    if not text:
        return {
            "decisions": None, "propagations": None, "restarts": None,
            "arith_terms": None, "ite_terms": None, "time": None, "memory": None
        }

    # 1) Parenthesized: (:key value)
    pair_pat = re.compile(
        r"\(\s*:\s*([A-Za-z0-9_\-]+)\s+([-+]?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?)\s*\)"
    )

    # 2) Flat: :key value   (no surrounding parentheses)
    flat_pat = re.compile(
        r":\s*([A-Za-z0-9_\-]+)\s+([-+]?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?)"
    )

    raw = {}

    def _store(k: str, v: str):
        k = k.lower()
        try:
            val = float(v)
            if abs(val - round(val)) < 1e-12:
                val = int(round(val))
        except Exception:
            return
        raw[k] = val

    for k, v in pair_pat.findall(text):
        _store(k, v)
    for k, v in flat_pat.findall(text):
        _store(k, v)

    key_aliases = {
        "decisions":      ["decisions", "num-decisions"],
        "propagations":   ["propagations", "num-propagations"],
        "restarts":       ["restarts", "num-restarts"],
        "arith_terms":    ["arith-terms"],
        "ite_terms":      ["ite-terms"],
        # Z3 varies here depending on build/command
        "time":           ["time", "total-time", "solve-time"],
        "memory":         ["memory", "max-memory", "max-memory-mb"],
    }

    out = {k: None for k in ["decisions","propagations","restarts","arith_terms","ite_terms","time","memory"]}
    for canon, aliases in key_aliases.items():
        for a in aliases:
            if a in raw:
                out[canon] = raw[a]
                break
    return out

def strip_smt_comments(s: str) -> str:
    # Remove ";" line comments
    return re.sub(r";[^\n]*", "", s)

def smt_static_metrics(smt_text: str) -> Dict[str, int]:
    t = strip_smt_comments(smt_text)

    # #variables = declare-fun + declare-const
    n_vars = len(re.findall(r"\(\s*declare-(?:fun|const)\b", t))

    # #asserts = assert
    n_asserts = len(re.findall(r"\(\s*assert\b", t))

    # #ite-terms = occurrences of (ite ...)
    n_ite = len(re.findall(r"\(\s*ite\b", t))

    ops = ["+", "-", "*", "/", "<=", ">=", "<", ">", "="]
    counts = {op: len(re.findall(r"\(\s*" + re.escape(op) + r"\s", t)) for op in ops}
    n_arith = sum(counts.values())

    return {
        "variables": n_vars,
        "asserts": n_asserts,
        "ite_terms": n_ite,
        "arith_terms": n_arith,
    }

# =========================================================
# Overhead / profiling (Z3-only overhead per call)
# =========================================================
def _parse_z3_stderr_time_and_mem(stderr: str) -> Tuple[Optional[float], Optional[float]]:
    if not stderr:
        return None, None

    def find_val(key: str):
        m = re.search(
            rf"(?:\(|\b)\s*:?\s*{re.escape(key)}\s+([-+]?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?)\s*\)?",
            stderr,
            flags=re.IGNORECASE,
        )
        return float(m.group(1)) if m else None

    return find_val("time"), find_val("memory")


def _children_ru_maxrss_mb() -> float:
    """
    Peak RSS of child processes (Z3) accumulated so far.
    Linux: ru_maxrss in KB. macOS: ru_maxrss in bytes.
    """
    r = resource.getrusage(resource.RUSAGE_CHILDREN)
    v = float(r.ru_maxrss)
    if v > 10**7:  # likely bytes (macOS)
        return v / (1024.0 * 1024.0)
    return v / 1024.0  # KB -> MB (Linux)


class OverheadTracker:
    def __init__(self):
        # tag -> list of dicts per Z3 call
        self.calls: Dict[str, List[Dict[str, Any]]] = {}

    def reset(self):
        self.calls.clear()

    def record(self, tag: str, wall_s: float, z3_s: Optional[float], child_peak_mb: float, z3_mem_mb: Optional[float],
           decisions: Optional[float] = None, propagations: Optional[float] = None, restarts: Optional[float] = None):
        self.calls.setdefault(tag, []).append({
            "wall_s": wall_s,
            "z3_s": z3_s,
            "child_peak_mb": child_peak_mb,
            "z3_mem_mb": z3_mem_mb,
            "decisions": decisions,
            "propagations": propagations,
            "restarts": restarts,
        })

    def summary(self, tag: str) -> Dict[str, Any]:
        lst = self.calls.get(tag, [])
        if not lst:
            return {"tag": tag, "calls": 0}

        walls = [x["wall_s"] for x in lst]
        z3s = [x["z3_s"] for x in lst if isinstance(x["z3_s"], (int, float))]
        peaks = [x["child_peak_mb"] for x in lst if isinstance(x.get("child_peak_mb"), (int, float))]

        # NEW: Z3-reported memory per call (if available)
        z3mem = [x["z3_mem_mb"] for x in lst if isinstance(x.get("z3_mem_mb"), (int, float))]

        return {
            "tag": tag,
            "calls": len(lst),
            "wall_sum_s": sum(walls),
            "wall_avg_ms": (sum(walls) / len(walls)) * 1000.0,
            "z3_sum_s": sum(z3s) if z3s else None,
            "z3_avg_ms": (sum(z3s) / len(z3s)) * 1000.0 if z3s else None,
            "z3_time_coverage": f"{len(z3s)}/{len(lst)}",
            "child_peak_mb": (max(peaks) if peaks else None),

            # NEW:
            "z3_mem_avg_mb": (sum(z3mem) / len(z3mem)) if z3mem else None,
            "z3_mem_coverage": f"{len(z3mem)}/{len(lst)}",
        }

    def print_summary(self, tag: str):
        s = self.summary(tag)
        if s.get("calls", 0) == 0:
            print(f"[Overhead] {tag}: no Z3 calls recorded.")
            return

        z3_sum_ms = (s["z3_sum_s"] * 1000.0) if isinstance(s["z3_sum_s"], (int, float)) else None
        z3_avg_ms = s["z3_avg_ms"] if isinstance(s["z3_avg_ms"], (int, float)) else None
        peak_mb = s["child_peak_mb"] if isinstance(s["child_peak_mb"], (int, float)) else None

        z3_sum_str = f"{z3_sum_ms:.2f} ms" if z3_sum_ms is not None else "NA"
        z3_avg_str = f"{z3_avg_ms:.2f} ms" if z3_avg_ms is not None else "NA"
        peak_str = f"{peak_mb:.2f} MB" if peak_mb is not None else "NA"

        z3_mem_avg = s.get("z3_mem_avg_mb")
        z3_mem_cov = s.get("z3_mem_coverage", "0/0")
        z3_mem_str = f"{z3_mem_avg:.2f} MB (cov {z3_mem_cov})" if isinstance(z3_mem_avg, (int, float)) else "NA"

        print(
            f"[Overhead] {tag}: calls={s['calls']}, "
            f"wall_sum={s['wall_sum_s']*1000:.2f} ms, wall_avg={s['wall_avg_ms']:.2f} ms, "
            f"z3_sum={z3_sum_str}, z3_avg={z3_avg_str}, "
            f"z3_time_coverage={s['z3_time_coverage']}, "
            f"Z3_child_peak_rss≈{peak_str}, "
            f"Z3_mem_avg≈{z3_mem_str}"
        )

    def print_effort(self, tag: str):
        lst = self.calls.get(tag, [])
        if not lst:
            print(f"[Effort] {tag}: no calls.")
            return

        def avg(key):
            xs = [x.get(key) for x in lst if isinstance(x.get(key), (int, float))]
            return (sum(xs) / len(xs)) if xs else None, f"{len(xs)}/{len(lst)}"

        d, dcov = avg("decisions")
        p, pcov = avg("propagations")
        r, rcov = avg("restarts")

        def fmt(x): return "NA" if x is None else f"{x:.2f}" if isinstance(x, float) else str(x)

        print(f"[Effort] {tag}: decisions_avg={fmt(d)} (cov {dcov}), "
          f"propagations_avg={fmt(p)} (cov {pcov}), restarts_avg={fmt(r)} (cov {rcov})")


OVERHEAD = OverheadTracker()

SCENARIO_CONFIG = {
    # -------- Healthcare --------
    1: {
        "assets": [
            "Diagnosis", "TreatmentPlan", "LabResults", "TestReports",
            "NonControlledPrescriptions", "PatientHistory",
            "ControlledPrescriptions", "PatientInteractions",
            "VisitSummaries", "ReferralNotes", "EncounterNotes",
            "PatientRecords"
        ],
        "must_ops": ["DiagnoseMedicalConditions", "ViewLabResults"],
        "nice_ops": ["Controlled", "NonControlled"],
        "optional_ops": ["AddEncounterNote", "AddReferralNote", "GenerateReports"],
        "context_vars": ["Location", "UnusualTime", "InsecNetwork", "PoorLighting"],
    },

    2: {  # -------- Healthcare (Scenario 2) --------
        "assets": [
            "Diagnosis", "TreatmentPlan", "LabResults", "TestReports",
            "PatientHistory", "PatientInteractions", "VisitSummaries",
            "ReferralNotes", "EncounterNotes", "PatientRecords",
            "PatientDemographics", "RadiologyImages",
            "DischargeSummaries", "PatientCommunications"
        ],


        "must_ops": ["AccessPatientProfile", "OrderLabTest","AdjustCarePlan"],
        "nice_ops": ["ApproveDischargeSummary", "RequestConsultation", "CommunicateWithPatient"],
        "optional_ops": [
            "ViewRadiologyImages",
            "ManageAppointment",
            "PrintMedicalReport"
        ],

        "context_vars": [
            "Location", "Emergency", "UnsecuredWiFi", "PoorLighting"
        ],
    },

    3: {
        "assets": [
            "Diagnosis", "TreatmentPlan", "LabResults", "TestReports",
            "NonControlledPrescriptions", "PatientHistory",
            "ControlledPrescriptions", "PatientInteractions",
            "VisitSummaries", "ReferralNotes", "EncounterNotes",
            "PatientRecords"
        ],
        "must_ops": ["DiagnoseMedicalConditions", "ViewLabResults"],
        "nice_ops": ["Controlled", "NonControlled"],
        "optional_ops": ["AddEncounterNote", "AddReferralNote", "GenerateReports"],
        "context_vars": ["Location", "UnsecuredWiFi", "UnusualTime", "UnknownDevice","PoorLighting"],
    },

    # -------- ICS --------
    4: {
        "assets": [
            "SafetyLimits", "AlarmRules", "DiagnosticData", "SystemLogs",
            "ControllerConfiguration", "ControlParameters",
            "ActuatorCommands", "CalibrationProfiles",
            "MaintenanceRecords", "FirmwareImages"
        ],
        "must_ops": [
            "ViewSafetyStatusAndAlarms",
            "ViewDiagnostics",
            "AcknowledgeAlarms"
        ],
        "nice_ops": [
            "SwitchControlMode",
            "AdjustControlSetpoints",
            "RestartSubsystemController",
            "CalibrateSensorsRebaseline"
        ],
        "optional_ops": [
            "RunSystemSelfTests",
            "ExportDownloadLogs",
            "UploadFirmware"
        ],
        "context_vars": [
            "Location", "UnfamiliarDevice", "VpnAccess",
            "OffMainWindow", "PoorLighting"
        ],
    },

    5: {
        "assets": [
            "SafetyLimits", "AlarmRules", "DiagnosticData", "SystemLogs",
            "ControllerConfiguration", "ControlParameters",
            "ActuatorCommands",
            "MaintenanceRecords", "FirmwareImages"
        ],
        "must_ops": [
            "ViewSafetyStatusAndAlarms",
            "ViewDiagnostics",
            "AcknowledgeAlarms",
            "EmergencyShutdown"
        ],
        "nice_ops": [
            "SwitchControlMode",
            "AdjustControlSetpoints",
            "RestartSubsystemController"
        ],
        "optional_ops": [
            "ExportDownloadLogs",
            "UploadFirmware"
        ],
        "context_vars": [
            "Emergency", "OffSite",
            "SharedDevice", "PoorLighting"
        ],
    },

    6: {
        "assets": [
            "SafetyLimits", "AlarmRules", "DiagnosticData", "SystemLogs",
            "ControllerConfiguration", "ControlParameters",
            "ActuatorCommands", "CalibrationProfiles",
            "MaintenanceRecords", "FirmwareImages"
        ],
        "must_ops": [
            "ViewSafetyStatusAndAlarms",
            "ViewDiagnostics",
            "AcknowledgeAlarms",
            "EmergencyShutdown"
        ],
        "nice_ops": [
            "SwitchControlMode",
            "AdjustControlSetpoints",
            "RestartSubsystemController",
            "CalibrateSensorsRebaseline"
        ],
        "optional_ops": [
            "RunSystemSelfTests",
            "ExportDownloadLogs",
            "UploadFirmware",
            "OverrideSafetyLimits"
        ],
        "context_vars": [
            "Location", "InsecNetwork", "PoorLighting"
        ],
    },
}

# ---- Auth method vars in your model ----
# Fuzzy: keep exact numeric value from Phase-1 (0/0.5/0.7/1.0)
FUZZY_AUTH_VARS = ["PinLeng", "PassStr", "OtpLeng"]

# Crisp: 0/1
CRISP_AUTH_VARS = [
    "Certificate", "SmartCard", "Token",
    "SignCryp", "GroupSign", "RingSign",
    "Iris", "Face", "Fingerprint"
]

AUTH_METHODS = FUZZY_AUTH_VARS + CRISP_AUTH_VARS


AUTH_EXTRA = ["TwoFactor"]


CONTEXT_VARS = ["Location", "UnusualTime", "InsecNetwork", "PoorLighting"]


CRUD = ["Read", "Write", "Update", "Delete"]


# Phase-1: variables you want printed/inspected
PHASE1_EXTRA_VARS = [
    "AssetValue",
    "PImpersAttack", "PReplayAttack", "PSessionAttack",
    "FPImpersAttack", "FPReplayAttack", "FPSessionAttack",
    "PRiskPImpersAttack", "PRiskReplayAttack", "PRiskSessionAttack",
    "TotalRisk",
]

# Phase-2: (partial) attack residual risks you want in the table (if present in SMT)
ATTACK_KEYS = [
    "PRiskPImpersAttack", "PRiskReplayAttack", "PRiskSessionAttack",
    "TotalRisk",
    "PImpersAttack", "PReplayAttack", "PSessionAttack",
    "FPImpersAttack", "FPReplayAttack", "FPSessionAttack",
]



# ----------------------------
# Phase-2 progressive search parameters
# ----------------------------
RR_STEP = 0.012          # reduce by 0.01 each round
MAX_CONFIGS = 15        # how many configs you want to suggest in total
DUMP_UNSAT_SMT = True   # writes a debug .smt2 when the final query becomes UNSAT


# =========================================================
# Z3 runner
# =========================================================
def run_z3(smt_input: str, tag: str = "Z3") -> subprocess.CompletedProcess:
    t0 = time.perf_counter()

    proc = subprocess.Popen(
        Z3_COMMAND,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )

    # Send input safely and read outputs ONCE
    stdout, stderr = proc.communicate(input=smt_input)

    t1 = time.perf_counter()

    # Parse Z3 stats (time/memory/decisions/propagations/restarts if present)
    stats_text = (stderr or "") + "\n" + (stdout or "")
    stats = parse_z3_stats(stats_text)

    z3_time_s = stats.get("time")
    if not isinstance(z3_time_s, (int, float)):
        z3_time_s = (t1 - t0)

    # This is Z3-reported memory (usually MB in Z3 stats)
    z3_mem_mb = stats.get("memory")

    # Keep your old “peak” fallback (note: it's not per-call peak, it's cumulative)
    peak_rss_mb = _children_ru_maxrss_mb()

    OVERHEAD.record(
        tag=tag,
        wall_s=(t1 - t0),
        z3_s=z3_time_s,
        child_peak_mb=peak_rss_mb,
        z3_mem_mb=z3_mem_mb,
        decisions=stats.get("decisions"),
        propagations=stats.get("propagations"),
        restarts=stats.get("restarts"),
    )

    return subprocess.CompletedProcess(
        args=Z3_COMMAND,
        returncode=proc.returncode,
        stdout=stdout,
        stderr=stderr
    )


def strip_trailing_solver_cmds(smt_text: str) -> str:
    """
    Remove trailing solver commands so we can append our own (check-sat/get-value).
    Important: handles (get-value (...)) with arguments, not just (get-value).
    Only strips from the END of the file (safer).
    """
    lines = smt_text.splitlines()

    # Commands to strip if they appear at the end (ignoring whitespace/comments)
    strip_prefixes = (
        "(check-sat",
        "(get-model",
        "(get-value",
        "(get-objectives",
        "(get-assertions",
        "(get-info",
        "(get-option",
        "(exit",
    )

    # Work from the end, remove blank lines/comments, then solver cmds
    out = list(lines)
    while out:
        last = out[-1].strip()
        if last == "" or last.startswith(";"):
            out.pop()
            continue
        low = last.lower()
        if any(low.startswith(p) for p in strip_prefixes):
            out.pop()
            continue
        break

    return "\n".join(out).strip() + "\n"


# =========================================================
# Robust S-expression parser for (get-value ...)
# =========================================================
def _sexpr_tokenize(s: str) -> List[str]:
    tokens = []
    i, n = 0, len(s)
    while i < n:
        c = s[i]
        if c.isspace():
            i += 1
            continue
        if c in ("(", ")"):
            tokens.append(c)
            i += 1
            continue
        if c == '"':  # quoted string
            j = i + 1
            while j < n and s[j] != '"':
                if s[j] == "\\" and j + 1 < n:
                    j += 2
                else:
                    j += 1
            tokens.append(s[i:j+1])
            i = j + 1
            continue
        j = i
        while j < n and (not s[j].isspace()) and s[j] not in ("(", ")"):
            j += 1
        tokens.append(s[i:j])
        i = j
    return tokens


def _sexpr_parse(tokens: List[str]):
    def parse_one(idx: int):
        if tokens[idx] != "(":
            return tokens[idx], idx + 1
        idx += 1
        lst = []
        while idx < len(tokens) and tokens[idx] != ")":
            node, idx = parse_one(idx)
            lst.append(node)
        if idx >= len(tokens):
            raise ValueError("Unbalanced parentheses in S-expression")
        return lst, idx + 1
    node, _ = parse_one(0)
    return node


def _atom_to_value(atom: str) -> Any:
    a = atom.strip()
    if a == "true":
        return True
    if a == "false":
        return False
    if a.startswith('"') and a.endswith('"'):
        return a[1:-1]
    try:
        return float(a)
    except Exception:
        return a


def _sexpr_eval(expr) -> Any:
    if isinstance(expr, str):
        return _atom_to_value(expr)

    if not isinstance(expr, list) or len(expr) == 0:
        return None

    op = expr[0]
    if op == "/":
        if len(expr) != 3:
            return None
        a = _sexpr_eval(expr[1])
        b = _sexpr_eval(expr[2])
        if isinstance(a, (int, float)) and isinstance(b, (int, float)) and abs(b) > 1e-18:
            return float(a) / float(b)
        return None

    if op == "-" and len(expr) == 2:
        x = _sexpr_eval(expr[1])
        if isinstance(x, (int, float)):
            return -float(x)
        return None

    # fallback raw
    return expr


def extract_get_value_block(output: str) -> Dict[str, Any]:
    """
    Parse Z3 get-value output like:
      sat
      ((Utility (/ 647 1000)) (ResRisk 0.024) ...)
    """
    if "(error" in output:
        lines = [ln for ln in output.splitlines() if "(error" in ln]
        raise RuntimeError("Z3 returned error during get-value:\n" + "\n".join(lines[:10]))

    start = output.find("((")
    if start == -1:
        return {}
    chunk = output[start:].strip()
    tokens = _sexpr_tokenize(chunk)
    tree = _sexpr_parse(tokens)

    vals: Dict[str, Any] = {}
    if not isinstance(tree, list):
        return vals

    for pair in tree:
        if not (isinstance(pair, list) and len(pair) == 2):
            continue
        name = pair[0]
        expr = pair[1]
        if isinstance(name, str):
            vals[name] = _sexpr_eval(expr)

    return vals


# =========================================================
# Misc helpers
# =========================================================
def is_enabled(val: Any) -> bool:
    if val is True:
        return True
    if val is False or val is None:
        return False
    if isinstance(val, (int, float)):
        return val > 0
    return False


def smt_eq_real01(name: str, enabled: bool) -> str:
    return f"(assert (= {name} {'1' if enabled else '0'}))"


def smt_num(x: float) -> str:
    if x is None:
        return "0"

    x = float(x)

    # exact 0
    if abs(x) < 1e-18:
        return "0.0"

    # For tiny numbers, emit rational to be 100% safe.
    # Example: 1e-13 -> (/ 1 10000000000000)
    if 0 < abs(x) < 1e-9:
        # scale to integer rational with 12 decimal digits
        # (choose enough digits so your eps constraints remain meaningful)
        denom = 10**12
        num = int(round(x * denom))
        if num == 0:
            return "0.0"
        sign = "-" if num < 0 else ""
        num = abs(num)
        return f"{sign}(/ {num} {denom})"

    # Otherwise print as fixed decimal (no exponent)
    s = f"{x:.12f}".rstrip("0").rstrip(".")
    if "." not in s:
        s += ".0"
    return s


def smt_real(x: float, nd: int = 12) -> str:
    s = f"{float(x):.{nd}f}"
    s = s.rstrip("0").rstrip(".")
    if s == "-0":
        s = "0"
    return s if s else "0"


def smt_eq(name: str, val: Any) -> str:
    if val is None:
        return ""
    if isinstance(val, bool):
        return f"(assert (= {name} {'true' if val else 'false'}))"
    if isinstance(val, (int, float)):
        if abs(val - round(val)) < 1e-12:
            return f"(assert (= {name} {int(round(val))}))"
        return f"(assert (= {name} {smt_real(val)}))"
    return f"(assert (= {name} {val}))"


def build_block_assert_from_getvalue(getvals: Dict[str, Any], decision_vars: List[str]) -> str:
    
    diffs = []
    for v in decision_vars:
        if v not in getvals:
            continue
        val = getvals[v]
        if isinstance(val, bool):
            diffs.append(f"(not {v})" if val else f"{v}")
        elif isinstance(val, (int, float)):
            diffs.append(f"(not (= {v} {smt_num(val)}))")
        else:
            diffs.append(f"(not (= {v} {val}))")
    if not diffs:
        return ""
    return "(assert (or " + " ".join(diffs) + "))\n"


def _extract_unknown_constant(err_text: str) -> Optional[str]:
    m = re.search(r"unknown constant\s+([A-Za-z0-9_\-]+)", err_text)
    if m:
        return m.group(1)
    m2 = re.search(r'unknown constant\s+([A-Za-z0-9_\-]+)"', err_text)
    if m2:
        return m2.group(1)
    return None


def get_values_safe(base_smt: str, extra_asserts: str, want_vars: List[str], tag: str = "Z3") -> Tuple[str, Dict[str, Any], List[str]]:
    removed: List[str] = []
    want = list(dict.fromkeys(want_vars))  # unique, preserve order

    # --- helper: detect sat/unsat/unknown robustly ---
    def _detect_status(stdout: str) -> Optional[str]:
        lines = [ln.strip() for ln in (stdout or "").splitlines() if ln.strip()]
        for ln in lines:
            if ln in ("sat", "unsat", "unknown"):
                return ln
        return None

    # 1) First call: ONLY check-sat + stats (NO get-value => no "model not available" on UNSAT)
    smt_status = (
        base_smt
        + "\n" + extra_asserts + "\n"
        + "(check-sat)\n"
        + "(get-info :all-statistics)\n"
    )
    res1 = run_z3(smt_status, tag=tag)
    status_line = _detect_status(res1.stdout)

    if status_line == "unsat":
        return "UNSAT", {}, removed

    if status_line == "unknown":
        err = (res1.stderr or "").strip()
        raise RuntimeError(f"Z3 returned unknown.\nSTDERR:\n{err}\nSTDOUT:\n{res1.stdout}")

    if status_line != "sat":
        err = (res1.stderr or "").strip()
        raise RuntimeError(f"Unexpected Z3 output (no sat/unsat/unknown found).\nSTDERR:\n{err}\nSTDOUT:\n{res1.stdout}")

    # 2) Second call (SAT only): now request get-value, with auto-removal of unknown constants
    for _ in range(40):  # retry cap for unknown constants in want
        want_str = " ".join(want)
        smt_vals = (
            base_smt
            + "\n" + extra_asserts + "\n"
            + "(check-sat)\n"
            + (f"(get-value ({want_str}))\n" if want else "")
            + "(get-info :all-statistics)\n"
        )
        res2 = run_z3(smt_vals, tag=tag)

        out2 = (res2.stdout or "")
        err2 = (res2.stderr or "").strip()

        # If Z3 reports unknown constant, remove it from want and retry
        lines2 = [ln.strip() for ln in out2.splitlines() if ln.strip()]
        if any("(error" in ln for ln in lines2):
            combined = "\n".join(lines2) + "\n" + err2
            unk = _extract_unknown_constant(combined)
            if unk and unk in want:
                want.remove(unk)
                removed.append(unk)
                continue
            # error not fixable by removing wanted vars
            raise RuntimeError(f"Z3 error during get-value.\nSTDOUT:\n{out2}\n\nSTDERR:\n{err2}")

        # Still must be sat here; but be defensive
        st2 = _detect_status(out2)
        if st2 == "unsat":
            return "UNSAT", {}, removed
        if st2 == "unknown":
            raise RuntimeError(f"Z3 returned unknown in get-value call.\nSTDERR:\n{err2}\nSTDOUT:\n{out2}")

        # Parse values
        gv = extract_get_value_block(out2)
        return "SAT", gv, removed

    raise RuntimeError("Exceeded retries while removing unknown constants from get-value.")

# =========================================================
# Phase 2 table helpers
# =========================================================
def _as_num(x):
    return float(x) if isinstance(x, (int, float)) else None


def _fmt_num(x, nd=4):
    v = _as_num(x)
    if v is None:
        return ""
    return f"{v:.{nd}f}"


def perm_level(asset: str, gv: Dict[str, Any]) -> str:
    r = bool(gv.get(f"{asset}_Read", False))
    w = bool(gv.get(f"{asset}_Write", False))
    u = bool(gv.get(f"{asset}_Update", False))
    d = bool(gv.get(f"{asset}_Delete", False))

    if not (r or w or u or d):
        return "NONE"
    if r and not (w or u or d):
        return "R"
    if r and w and not (u or d):
        return "RW"
    if r and w and u and not d:
        return "RWU"
    if r and w and u and d:
        return "RWUD"
    return "MIXED"


def enabled_ops(gv: Dict[str, Any], ops: List[str]) -> List[str]:
    out = []
    for op in ops:
        v = gv.get(op)
        if isinstance(v, (int, float)) and v > 0:
            out.append(op)
    return out


def enabled_assets(gv: Dict[str, Any], assets: List[str]) -> List[str]:
    out = []
    for a in assets:
        v = gv.get(a)
        if isinstance(v, (int, float)) and v > 0:
            out.append(a)
    return out


def reduced_assets_with_perms(gv: Dict[str, Any], assets: List[str]) -> List[str]:
    out = []
    for a in enabled_assets(gv, assets):
        lvl = perm_level(a, gv)
        if lvl != "RWUD":
            out.append(f"{a}:{lvl}")
    return out


def config_signature(gv: Dict[str, Any], decision_vars: List[str]) -> str:
    parts = []
    for v in decision_vars:
        if v in gv:
            parts.append(f"{v}={gv[v]}")
    parts.sort()
    return "|".join(parts)


# =========================================================
# Phase 1: adaptive binary search
# =========================================================
class AdaptivePhase:
    def __init__(self, adapt_path: str):
        self.adapt_path = adapt_path
        self.base_smt = ""
        self.best_threshold: Optional[float] = None
        self.log: List[Tuple[int, float, Optional[float], str]] = []
        self.round_counter = 0
        self.best_values: Dict[str, Any] = {}

    def load(self):
        with open(self.adapt_path, "r") as f:
            self.base_smt = strip_trailing_solver_cmds(f.read())


    def _is_sat(self, threshold: float) -> bool:
        self.round_counter += 1

        want = ["Utility", "ResRisk"] + PHASE1_EXTRA_VARS + AUTH_METHODS + AUTH_EXTRA + CONTEXT_VARS
        asserts = f"(assert (> Utility {smt_num(threshold)}))"

        status, gv, removed = get_values_safe(self.base_smt, asserts, want, tag="Phase1")

        if status == "UNSAT":
            self.log.append((self.round_counter, threshold, None, "UNSAT"))
            print(f"[Phase1] round {self.round_counter:02d}: Utility > {threshold:.6f} -> UNSAT")
            return False

        u = gv.get("Utility", None)
        rr = gv.get("ResRisk", None)
        av = gv.get("AssetValue", None)
        tt = gv.get("TotalRisk", None)

        self.best_threshold = threshold
        self.best_values = gv

        model_u = float(u) if isinstance(u, (int, float)) else None
        self.log.append((self.round_counter, threshold, model_u, "SAT"))

        rm = f", removed(get-value)={removed}" if removed else ""
        print(f"[Phase1] round {self.round_counter:02d}: Utility > {threshold:.6f} -> SAT (Utility={u}, ResRisk={rr}, AssetValue={av}){rm}")
        return True

    def binary_search(self, min_u=0.0, max_u=1.0, eps=0.001) -> float:
        self.best_threshold = None
        self.best_values = {}
        self.log.clear()
        self.round_counter = 0

        if not self._is_sat(min_u):
            raise RuntimeError(f"Adaptive UNSAT even at Utility>{min_u}. Check constraints.")

        if self._is_sat(max_u):
            return round(max_u, 3)

        low, high = min_u, max_u
        while high - low > eps:
            mid = (low + high) / 2.0
            if self._is_sat(mid):
                low = mid
            else:
                high = mid

        if self.best_threshold is None:
            raise RuntimeError("Binary search ended without SAT threshold (unexpected).")
        return round(self.best_threshold, 3)

    def chosen_auth(self) -> Dict[str, Any]:
    
        chosen: Dict[str, Any] = {}

        for a in FUZZY_AUTH_VARS:
            v = self.best_values.get(a, 0.0)
            chosen[a] = float(v) if isinstance(v, (int, float)) else 0.0

        for a in CRISP_AUTH_VARS:
            chosen[a] = 1 if is_enabled(self.best_values.get(a)) else 0

        if "TwoFactor" in self.best_values:
            v2 = self.best_values.get("TwoFactor", 0.0)
            chosen["TwoFactor"] = float(v2) if isinstance(v2, (int, float)) else 0.0

        return chosen


# =========================================================
# Phase 2: progressive lowering
# =========================================================
def run_phase2_progressive(
    residual_path: str,
    freeze_auth: Dict[str, Any],
    freeze_context: Optional[Dict[str, Any]],
    rr_start: float,
    decision_vars: List[str],
    assets: List[str],         
    step: float = 0.01,
    max_configs: int = 5,
    dump_unsat_smt: bool = True
) -> List[Dict[str, Any]]:

    with open(residual_path, "r") as f:
        base2 = strip_trailing_solver_cmds(f.read())

    phase2_metrics = smt_static_metrics(base2)
    print("[Static] Phase2:", phase2_metrics)

    # Freeze auth (exact values for fuzzy + TwoFactor; 0/1 for crisp)
    freeze_lines: List[str] = []

    # Fuzzy vars: exact numeric value
    for a in FUZZY_AUTH_VARS:
        freeze_lines.append(smt_eq(a, freeze_auth.get(a, 0.0)))

    # Crisp vars: 0/1
    for a in CRISP_AUTH_VARS:
        freeze_lines.append(smt_eq_real01(a, freeze_auth.get(a, 0) == 1))

    # TwoFactor: preserve numeric value if present
    if "TwoFactor" in freeze_auth:
        freeze_lines.append(smt_eq("TwoFactor", freeze_auth.get("TwoFactor", 0.0)))

    # Freeze context (optional)
    if freeze_context:
        for kctx, vctx in freeze_context.items():
            freeze_lines.append(smt_eq(kctx, vctx))

    freeze_block = "\n".join([x for x in freeze_lines if x.strip()]) + "\n"

    blocks = ""
    results: List[Dict[str, Any]] = []
    seen = set()

    rr_target = rr_start
    round_idx = 0

    while rr_target > 1e-12 and len(results) < max_configs:
        round_idx += 1
        rr_before = rr_target
        rr_target = max(0.0, rr_target - step)

        want = (
            [ "ResRisk", "AssetValue", "AuthorizationPenalty", "PermPenalty"]
            + decision_vars
            + assets
            + ATTACK_KEYS
        )

        rr_constraint = (
            f"(assert (< ResRisk {smt_num(rr_before)}))\n"
            f"(assert (> ResRisk {smt_num(rr_target)}))"
        )

        asserts = (
            "\n; --- FREEZE (from Phase 1) ---\n"
            + freeze_block
            + "\n; --- Progressive RR upper bound  ---\n"
            + rr_constraint
            + "\n; --- BLOCKING CLAUSES (global enumeration) ---\n"
            + blocks
        )

        status, gv, removed = get_values_safe(base2, asserts, want, tag="Phase2")

        if status == "UNSAT":
            print(f"[Phase2] round {round_idx:02d}: target {rr_before:.4f} <= ResRisk <= {rr_target:.4f} -> UNSAT")
            if dump_unsat_smt and rr_target <= step + 1e-12:
                dbg = os.path.join(os.path.dirname(residual_path), "DEBUG_phase2_last_unsat.smt2")
                want_str = " ".join([v for v in want if v not in removed])
                smt_dbg = base2 + "\n" + asserts + "\n(check-sat)\n(get-value (" + want_str + "))\n"
                with open(dbg, "w") as fdbg:
                    fdbg.write(smt_dbg)
                print(f"[Phase2] Wrote failing SMT to: {dbg}")
            continue

        sig = config_signature(gv, decision_vars)
        if sig in seen:
            # Should be rare because blocks should prevent it, but keep safe.
            print(f"[Phase2][WARN] Duplicate configuration returned at rr_target={rr_target:.4f}. Blocking anyway.")
        seen.add(sig)

        util = gv.get("Utility")
        rr = gv.get("ResRisk")
        assetv = gv.get("AssetValue")
        pen = gv.get("AuthorizationPenalty")
        rm = f" removed(get-value)={removed}" if removed else ""
        print(f"[Phase2] round {round_idx:02d}: target<= {rr_target:.4f} -> SAT (ResRisk={rr}, Utility={util}, AssetValue={assetv}, Penalty={pen}){rm}")

        results.append(gv)

        new_block = build_block_assert_from_getvalue(gv, decision_vars)
        if not new_block.strip():
            print("[Phase2][WARN] Blocking clause empty (no decision vars in get-value). Stopping to avoid repeats.")
            break
        blocks += new_block

    return results


# =========================================================
# Pretty printing + file outputs
# =========================================================

def _bool01(x: Any) -> str:
    return "1" if x is True else "0" if x is False else ""


def _real01_on(x: Any) -> str:
    return "1" if isinstance(x, (int, float)) and x > 0 else "0"


def _perm_str(asset: str, gv: Dict[str, Any]) -> str:
    """Return CRUD string like R---, RW--, RWU-, RWUD (or ----)."""
    r = gv.get(f"{asset}_Read", False)
    w = gv.get(f"{asset}_Write", False)
    u = gv.get(f"{asset}_Update", False)
    d = gv.get(f"{asset}_Delete", False)
    return (
        ("R" if r else "-")
        + ("W" if w else "-")
        + ("U" if u else "-")
        + ("D" if d else "-")
    )


def print_phase2_summary_table(
    configs: List[Dict[str, Any]],
    must_ops: List[str],
    nice_ops: List[str],
    optional_ops: List[str]
):
    
    print("\n[PHASE 2 RECOMMENDATIONS - SUMMARY]")
    cols = [
        "Config",
        "ResRisk", "AssetValue", "PermPenalty",
        "PRiskPImpersAttack", "PRiskReplayAttack", "PRiskSessionAttack",
        "MustOps_ON", "NiceOps_ON", "OptionalOps_ON",
    ]
    print("\t".join(cols))

    for i, gv in enumerate(configs, 1):
        must_on = enabled_ops(gv, must_ops)
        nice_on = enabled_ops(gv, nice_ops)
        opt_on  = enabled_ops(gv, optional_ops)
        pen = gv.get("AuthorizationPenalty")

        row = [
            str(i),
            _fmt_num(gv.get("ResRisk")),
            _fmt_num(gv.get("AssetValue")),
            _fmt_num(pen),
            _fmt_num(gv.get("PRiskPImpersAttack")),
            _fmt_num(gv.get("PRiskReplayAttack")),
            _fmt_num(gv.get("PRiskSessionAttack")),
            ",".join(must_on),
            ",".join(nice_on),
            ",".join(opt_on),
        ]
        print("\t".join(row))


def print_phase2_detailed(
    configs: List[Dict[str, Any]],
    must_ops: List[str],
    nice_ops: List[str],
    optional_ops: List[str],
    assets: List[str]
):

    print("\n[PHASE 2 RECOMMENDENDATIONS - DETAILS]")

    ops_all = must_ops + nice_ops + optional_ops

    for i, gv in enumerate(configs, 1):
        pen = gv.get("AuthorizationPenalty", gv.get("PermPenalty"))
        print("\n" + "=" * 70)
        print(f"Config #{i}")
        print(f"  ResRisk      : {_fmt_num(gv.get('ResRisk'))}")
        print(f"  AssetValue   : {_fmt_num(gv.get('AssetValue'))}")
        print(f"  AuthPenalty  : {_fmt_num(pen)}")
        print(f"  FPImpersAttack    : {_fmt_num(gv.get('FPImpersAttack'))}")
        print(f"  FPReplayAttack    : {_fmt_num(gv.get('FPReplayAttack'))}")
        print(f"  FPSessionAttack    : {_fmt_num(gv.get('FPSessionAttack'))}")

        # Operations ON/OFF
        print("\n  Operations:")
        for op in ops_all:
            v = gv.get(op)
            state = "ON" if isinstance(v, (int, float)) and v > 0 else "OFF"
            print(f"    - {op}: {state}")

        # Assets + CRUD
        print("\n  Assets and CRUD permissions:")
        for a in assets:
            a_on = gv.get(a)
            a_state = "ON" if isinstance(a_on, (int, float)) and a_on > 0 else "OFF"
            perms = _perm_str(a, gv)
            print(f"    - {a}: {a_state}  perms={perms}")


def write_phase2_outputs(
    configs: List[Dict[str, Any]],
    residual_path: str,
    must_ops: List[str],
    nice_ops: List[str],
    optional_ops: List[str],
    assets: List[str]
):
    """Write outputs to files (TSV wide + Markdown report + JSONL)."""
    out_dir = os.path.dirname(residual_path)
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")

    tsv_path = os.path.join(out_dir, f"phase2_results_{ts}.tsv")
    md_path = os.path.join(out_dir, f"phase2_report_{ts}.md")
    jsonl_path = os.path.join(out_dir, f"phase2_results_{ts}.jsonl")

    # -------- Wide TSV (explicit ON/OFF + CRUD per asset) --------
    ops_all = must_ops + nice_ops + optional_ops

    header = [
        "Config",
        "ResRisk", "AssetValue", "AuthPenalty",
        "PRiskPImpersAttack", "PRiskReplayAttack", "PRiskSessionAttack", "TotalRisk",
    ]

    # Operations columns
    header += [f"op_{op}" for op in ops_all]

    # Asset ON/OFF + CRUD columns
    header += [f"asset_{a}" for a in assets]
    for a in assets:
        header += [f"{a}_Read", f"{a}_Write", f"{a}_Update", f"{a}_Delete", f"{a}_CRUD"]

    with open(tsv_path, "w", encoding="utf-8") as f:
        f.write("\t".join(header) + "\n")
        for i, gv in enumerate(configs, 1):
            pen = gv.get("AuthorizationPenalty", gv.get("PermPenalty"))

            row = [
                str(i),
                _fmt_num(gv.get("ResRisk")),
                _fmt_num(gv.get("AssetValue")),
                _fmt_num(pen),
                _fmt_num(gv.get("PRiskPImpersAttack")),
                _fmt_num(gv.get("PRiskReplayAttack")),
                _fmt_num(gv.get("PRiskSessionAttack")),
                _fmt_num(gv.get("TotalRisk")),
            ]

            # Operations
            for op in ops_all:
                row.append(_real01_on(gv.get(op)))

            # Assets + permissions
            for a in assets:
                row.append(_real01_on(gv.get(a)))

            for a in assets:
                row.append(_bool01(gv.get(f"{a}_Read")))
                row.append(_bool01(gv.get(f"{a}_Write")))
                row.append(_bool01(gv.get(f"{a}_Update")))
                row.append(_bool01(gv.get(f"{a}_Delete")))
                row.append(_perm_str(a, gv))

            f.write("\t".join(row) + "\n")

    # -------- Markdown report (readable) --------
    with open(md_path, "w", encoding="utf-8") as f:
        f.write(f"# Phase-2 Recommendations Report\n\n")
        f.write(f"Generated: {datetime.now().isoformat(timespec='seconds')}\n\n")

        for i, gv in enumerate(configs, 1):
            pen = gv.get("AuthorizationPenalty")
            f.write(f"## Config {i}\n\n")
            f.write(f"- ResRisk: `{_fmt_num(gv.get('ResRisk'))}`\n")
            f.write(f"- PImpersAttack: `{_fmt_num(gv.get('PImpersAttack'))}`\n")
            f.write(f"- PSessionAttack: `{_fmt_num(gv.get('PSessionAttack'))}`\n")
            f.write(f"- PReplayAttack: `{_fmt_num(gv.get('PReplayAttack'))}`\n")
            f.write(f"- TotalRisk: `{_fmt_num(gv.get('TotalRisk'))}`\n")
            f.write(f"- AssetValue: `{_fmt_num(gv.get('AssetValue'))}`\n")
            f.write(f"- AuthPenalty: `{_fmt_num(pen)}`\n\n")

            # Operations
            f.write("### Operations\n\n")
            f.write("| Operation | State |\n|---|---|\n")
            for op in ops_all:
                state = "ON" if isinstance(gv.get(op), (int, float)) and gv.get(op) > 0 else "OFF"
                f.write(f"| {op} | {state} |\n")
            f.write("\n")

            # Assets
            f.write("### Assets and CRUD permissions\n\n")
            f.write("| Asset | AssetState | CRUD | Read | Write | Update | Delete |\n|---|---|---|---|---|---|---|\n")
            for a in assets:
                a_state = "ON" if isinstance(gv.get(a), (int, float)) and gv.get(a) > 0 else "OFF"
                crud = _perm_str(a, gv)
                f.write(
                    f"| {a} | {a_state} | {crud} | {_bool01(gv.get(a+'_Read'))} | {_bool01(gv.get(a+'_Write'))} | {_bool01(gv.get(a+'_Update'))} | {_bool01(gv.get(a+'_Delete'))} |\n"
                )
            f.write("\n")

    # -------- JSONL (one config per line) --------
    import json
    with open(jsonl_path, "w", encoding="utf-8") as f:
        for i, gv in enumerate(configs, 1):
            obj = {"config": i, **gv}
            # make non-JSON types safe
            for k, v in list(obj.items()):
                if isinstance(v, float) and (v != v):  # NaN
                    obj[k] = None
            f.write(json.dumps(obj, ensure_ascii=False) + "\n")

    return tsv_path, md_path, jsonl_path


# =========================================================
# BaseLine B ( ABAC)
# =========================================================

def abac_tier_decision(ctx: Dict[str, Any],
                       must_ops: List[str],
                       nice_ops: List[str],
                       optional_ops: List[str],
                       sid: int):
    """Return (tier, score, ops_onoff_dict)."""

    def b01(x):
        if isinstance(x, bool): return 1 if x else 0
        if isinstance(x, (int, float)): return 1 if x > 0 else 0
        return 0

    if sid == 4:  # ICS
        unknown_loc = b01(ctx.get("Location"))
        unfamiliar = b01(ctx.get("UnfamiliarDevice"))
        vpn_off    = 1 - b01(ctx.get("VpnAccess"))       # risk if VPN not used
        offwin     = b01(ctx.get("OffMainWindow"))
        PoorLighting      = b01(ctx.get("PoorLighting"))

        # If Location is 0/1 where 1=unknown 0=known        

        score = unknown_loc + unfamiliar + vpn_off + offwin + PoorLighting
    elif sid == 1:  # Healthcare
    # Assuming Location=1 means unknown, Location=0 means known/trusted
        unknown_loc = b01(ctx.get("Location"))
        insec   = b01(ctx.get("UnsecuredWiFi"))
        PoorLighting   = b01(ctx.get("PoorLighting"))

        score = unknown_loc + insec + PoorLighting
    elif sid == 2:  # Healthcare
    # Assuming Location=1 means unknown, Location=0 means known/trusted
        unknown_loc = b01(ctx.get("Location"))
        unusual = b01(ctx.get("UnusualTime"))
        insec   = b01(ctx.get("InsecNetwork"))
        PoorLighting   = b01(ctx.get("PoorLighting"))

        score = unknown_loc + unusual + insec + PoorLighting
    elif sid == 3:  # Healthcare
    # Assuming Location=1 means unknown, Location=0 means known/trusted
        unknown_loc = b01(ctx.get("Location"))
        unusual = b01(ctx.get("UnusualTime"))
        insec   = b01(ctx.get("UnsecuredWiFi"))
        UnknownDevice   = b01(ctx.get("UnknownDevice"))
        PoorLighting   = b01(ctx.get("PoorLighting"))

        score = unknown_loc + unusual + insec + PoorLighting + UnknownDevice
    elif sid == 5:  # ICS
    # Assuming Location=1 means unknown, Location=0 means known/trusted
        Emergency = b01(ctx.get("Emergency"))
        SharedDevice = b01(ctx.get("SharedDevice"))
        OffSite   = b01(ctx.get("OffSite"))
        PoorLighting   = b01(ctx.get("PoorLighting"))

        score = Emergency + SharedDevice + OffSite + PoorLighting
    elif sid == 6:  # ICS
    # Assuming Location=1 means unknown, Location=0 means known/trusted
        unknown_loc = b01(ctx.get("Location"))
        InsecNetwork   = b01(ctx.get("InsecNetwork"))
        PoorLighting   = b01(ctx.get("PoorLighting"))

        score = unknown_loc + InsecNetwork + PoorLighting
    else:
        score = 0

    if score <= 0:
        tier = "LOW"
    elif score <= 0:
        tier = "MEDIUM"
    else:
        tier = "HIGH"

    ops = {op: 0 for op in (must_ops + nice_ops + optional_ops)}
    for op in must_ops:
        ops[op] = 1

    if tier == "LOW":
        for op in nice_ops: ops[op] = 1
        for op in optional_ops: ops[op] = 1
    elif tier == "MEDIUM":
        for op in nice_ops: ops[op] = 1
        for op in optional_ops: ops[op] = 0
    else:  # HIGH
        for op in nice_ops: ops[op] = 0
        for op in optional_ops: ops[op] = 0

    return tier, score, ops



def run_baseline_abac_once(
    residual_path: str,
    freeze_auth: Dict[str, Any],
    freeze_context: Dict[str, Any],
    assets: List[str],
    must_ops: List[str],
    nice_ops: List[str],
    optional_ops: List[str],
    sid: int
) -> Dict[str, Any]:

    with open(residual_path, "r") as f:
        base2 = strip_trailing_solver_cmds(f.read())

    # 1) Freeze auth + context (same as Phase2)
    freeze_lines = []
    for a in FUZZY_AUTH_VARS:
        freeze_lines.append(smt_eq(a, freeze_auth.get(a, 0.0)))
    for a in CRISP_AUTH_VARS:
        freeze_lines.append(smt_eq_real01(a, freeze_auth.get(a, 0) == 1))
    if "TwoFactor" in freeze_auth:
        freeze_lines.append(smt_eq("TwoFactor", freeze_auth.get("TwoFactor", 0.0)))

    for kctx, vctx in freeze_context.items():
        freeze_lines.append(smt_eq(kctx, vctx))

    # 2) Tier decision (fixed thresholds)
    tier, score, ops = abac_tier_decision(freeze_context, must_ops, nice_ops, optional_ops, sid)

    # 3) Assert ops and perms (policy is fixed)
    policy_lines = []
    for op, v in ops.items():
        policy_lines.append(smt_eq(op, float(v)))


    asserts = "\n".join([x for x in (freeze_lines + policy_lines) if x.strip()]) + "\n"

    ops_all = must_ops + nice_ops + optional_ops
    crud_vars = [f"{a}_{c}" for a in assets for c in ["Read", "Write", "Update", "Delete"]]

    want = (
        ["ResRisk", "TotalRisk", "AssetValue", "AuthorizationPenalty", "PermPenalty"]
        + ATTACK_KEYS
        + ops_all
        + assets
        + crud_vars
    )
    status, gv, removed = get_values_safe(base2, asserts, want, tag="BaselineABAC")

    if status != "SAT":
        raise RuntimeError(f"Baseline B (ABAC) returned {status}. tier={tier} score={score} removed={removed}")

    gv["_ABAC_Tier"] = tier
    gv["_ABAC_Score"] = score
    return gv

    


def print_ops_states(gv: Dict[str, Any], must_ops: List[str], nice_ops: List[str], optional_ops: List[str]) -> None:
    ops_all = must_ops + nice_ops + optional_ops
    print("\n[Operations]")
    for op in ops_all:
        v = gv.get(op, 0)
        state = "ON" if isinstance(v, (int, float)) and v > 0 else "OFF"
        print(f"  - {op}: {state}")


def print_assets_states_and_crud(gv: Dict[str, Any], assets: List[str]) -> None:
    print("\n[Assets + CRUD]")
    for a in assets:
        a_on = gv.get(a, 0)
        a_state = "ON" if isinstance(a_on, (int, float)) and a_on > 0 else "OFF"
        r = gv.get(f"{a}_Read", False)
        w = gv.get(f"{a}_Write", False)
        u = gv.get(f"{a}_Update", False)
        d = gv.get(f"{a}_Delete", False)
        crud = ("R" if r else "-") + ("W" if w else "-") + ("U" if u else "-") + ("D" if d else "-")
        print(f"  - {a}: {a_state}  CRUD={crud}  (R={int(bool(r))}, W={int(bool(w))}, U={int(bool(u))}, D={int(bool(d))})")

def run_abac_baseline_once(residual_path, chosen_auth, freeze_context,
                           ASSETS, MUST_OPS, NICE_OPS, OPTIONAL_OPS, sid):
    abac_gv = run_baseline_abac_once(
        residual_path=residual_path,
        freeze_auth=chosen_auth,
        freeze_context=freeze_context,
        assets=ASSETS,
        must_ops=MUST_OPS,
        nice_ops=NICE_OPS,
        optional_ops=OPTIONAL_OPS,
        sid=sid
    )

    print("\n[Baseline B - ABAC fixed thresholds]")
    print("  Tier      =", abac_gv.get("_ABAC_Tier"), "score=", abac_gv.get("_ABAC_Score"))
    print("  ResRisk   =", abac_gv.get("ResRisk"))
    print("  TotalRisk =", abac_gv.get("TotalRisk"))
    print("  AssetValue=", abac_gv.get("AssetValue"))
    print("  AuthPenalty=", abac_gv.get("AuthorizationPenalty"))

    print_ops_states(abac_gv, MUST_OPS, NICE_OPS, OPTIONAL_OPS)
    print_assets_states_and_crud(abac_gv, ASSETS)

    return abac_gv


   
def build_paths(sid: int) -> Tuple[str, str]:
    scenario_dir = os.path.join(BASE_DIR, f"Scenario{sid}")
    adapt_path = os.path.join(scenario_dir, ADAPT_FILENAME_TEMPLATE.format(sid=sid))
    residual_path = os.path.join(scenario_dir, RESIDUAL_FILENAME.format(sid=sid))
    return adapt_path, residual_path



def run_once(sid: int, write_outputs: bool = True, run_baseline: bool = False) -> Dict[str, Any]:
    if sid not in SCENARIO_CONFIG:
        raise RuntimeError(f"No scenario configuration for scenario {sid}")

    cfg = SCENARIO_CONFIG[sid]

    ASSETS = cfg["assets"]
    MUST_OPS = cfg["must_ops"]
    NICE_OPS = cfg["nice_ops"]
    OPTIONAL_OPS = cfg["optional_ops"]
    CONTEXT_VARS = cfg["context_vars"]

    globals()["CONTEXT_VARS"] = CONTEXT_VARS

    OP_TOGGLES = MUST_OPS + NICE_OPS + OPTIONAL_OPS
    CRUD = ["Read", "Write", "Update", "Delete"]
    DECISION_VARS = OP_TOGGLES + [f"{a}_{c}" for a in ASSETS for c in CRUD]

    adapt_path, residual_path = build_paths(sid)

    print(f"=== Scenario {sid} ===")
    print(f"Adaptive SMT : {adapt_path}")
    print(f"Residual SMT : {residual_path}")

    if not os.path.exists(adapt_path):
        raise FileNotFoundError(f"Adaptive model not found: {adapt_path}")
    if not os.path.exists(residual_path):
        raise FileNotFoundError(f"Residual model not found: {residual_path}")

    # ---------------- Phase 1 ----------------
    phase1 = AdaptivePhase(adapt_path)
    phase1.load()
    print("[Static] Phase1:", smt_static_metrics(phase1.base_smt))

    best_thr = phase1.binary_search(min_u=0.0, max_u=1.0, eps=0.001)
    print(f"\n[Phase1] Best Utility threshold ≈ {best_thr:.3f}")

    util1 = phase1.best_values.get("Utility")
    rr1 = phase1.best_values.get("ResRisk")
    tt = phase1.best_values.get("TotalRisk")

    

    chosen_auth = phase1.chosen_auth()

    freeze_context = {k: phase1.best_values.get(k) for k in CONTEXT_VARS}
    freeze_context = {k: v for k, v in freeze_context.items() if v is not None}

    print("\n[Phase1] Final values (from get-value):")
    print(f"  Utility = {util1}")
    print(f"  ResRisk = {rr1}")
    print(f"  TotalRisk = {tt}")
    print(f"  Auth method : {chosen_auth}")
    print(f"  Context : {freeze_context}")

    if not isinstance(rr1, (int, float)):
        raise RuntimeError("[Phase2] Phase1 ResRisk is not numeric; cannot do progressive reduction.")
    rr_start = float(rr1)

    # ---------------- Phase 2 ----------------
    print("\n[Phase2] Progressive reduction:")
    print(f"  Start ResRisk = {rr_start:.6f}")
    print(f"  Step         = {RR_STEP:.6f}")
    print(f"  Max configs  = {MAX_CONFIGS}")

    configs = run_phase2_progressive(
        residual_path=residual_path,
        freeze_auth=chosen_auth,
        freeze_context=freeze_context,
        rr_start=rr_start,
        decision_vars=DECISION_VARS,
        assets=ASSETS,
        step=RR_STEP,
        max_configs=MAX_CONFIGS,
        dump_unsat_smt=DUMP_UNSAT_SMT
    )

    print(f"\n[Done] Suggested configurations found: {len(configs)}")

    # Only write files / print big tables on the final run (recommended)
    if write_outputs:
        print_phase2_summary_table(configs, MUST_OPS, NICE_OPS, OPTIONAL_OPS)
        print_phase2_detailed(configs, MUST_OPS, NICE_OPS, OPTIONAL_OPS, ASSETS)

        tsv_path, md_path, jsonl_path = write_phase2_outputs(
            configs, residual_path, MUST_OPS, NICE_OPS, OPTIONAL_OPS, ASSETS
        )
        print("\n[Files written]")
        print(f"  - {tsv_path}")
        print(f"  - {md_path}")
        print(f"  - {jsonl_path}")
        
        # ---------------- Baseline B (Fixed ABAC) ----------------
    abac_gv = None
    if run_baseline:
        abac_gv = run_baseline_abac_once(
            residual_path=residual_path,
            freeze_auth=chosen_auth,
            freeze_context=freeze_context,
            assets=ASSETS,
            must_ops=MUST_OPS,
            nice_ops=NICE_OPS,
            optional_ops=OPTIONAL_OPS,
            sid=sid
        )
    # Return key outcomes + overhead summaries (read from OVERHEAD after this run)
    return {
        "sid": sid,
        "phase1_utility": util1,
        "phase1_resrisk": rr1,
        "configs_found": len(configs),
        "baseline_tier": (abac_gv.get("_ABAC_Tier") if abac_gv else None),
        "baseline_resrisk": (abac_gv.get("ResRisk") if abac_gv else None),
    }

    
def solve_adaptive_once(adapt_path: str, ctx_vars: List[str]) -> Tuple[Dict[str, Any], Dict[str, Any]]:
    """
    One SAT call to adaptive model (no search).
    Returns (chosen_auth, freeze_context).
    """
    with open(adapt_path, "r") as f:
        base = strip_trailing_solver_cmds(f.read())

    want = AUTH_METHODS + AUTH_EXTRA + ctx_vars
    status, gv, removed = get_values_safe(base, extra_asserts="", want_vars=want, tag="Phase1Once")

    if status != "SAT":
        raise RuntimeError(f"Adaptive model returned {status} in baseline-only. removed={removed}")

    # reuse your existing extraction logic
    tmp = AdaptivePhase(adapt_path)
    tmp.base_smt = base
    tmp.best_values = gv

    chosen_auth = tmp.chosen_auth()

    freeze_context = {k: gv.get(k) for k in ctx_vars}
    freeze_context = {k: v for k, v in freeze_context.items() if v is not None}

    return chosen_auth, freeze_context
    
def _to_ms_summary(s: Dict[str, Any]) -> Dict[str, Any]:
    out = dict(s)

    if "wall_sum_s" in out and isinstance(out["wall_sum_s"], (int, float)):
        out["wall_sum_ms"] = out["wall_sum_s"] * 1000.0
    else:
        out["wall_sum_ms"] = float("nan")

    if isinstance(out.get("z3_sum_s"), (int, float)):
        out["z3_sum_ms"] = out["z3_sum_s"] * 1000.0
    else:
        out["z3_sum_ms"] = float("nan")

    out["wall_avg_ms"] = float(out.get("wall_avg_ms", float("nan"))) if out.get("wall_avg_ms") is not None else float("nan")
    out["z3_avg_ms"]   = float(out.get("z3_avg_ms", float("nan"))) if out.get("z3_avg_ms") is not None else float("nan")

    out["peak_rss_mb"] = float(out.get("child_peak_mb", float("nan"))) if out.get("child_peak_mb") is not None else float("nan")

    cov = out.get("z3_time_coverage", "")
    try:
        k, n = cov.split("/")
        out["z3_time_coverage_ratio"] = (float(k) / float(n)) if float(n) > 0 else float("nan")
    except Exception:
        out["z3_time_coverage_ratio"] = float("nan")

    # (only if you added it in summary())
    out["z3_mem_avg_mb"] = float(out.get("z3_mem_avg_mb", float("nan"))) if out.get("z3_mem_avg_mb") is not None else float("nan")

    out["calls"] = int(out.get("calls", 0) or 0)
    return out

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("scenario_id", type=int, help="Scenario id, e.g., 1 or 4")
    parser.add_argument("--repeats", type=int, default=1, help="Measured runs")
    parser.add_argument("--warmup", type=int, default=1, help="Warmup runs (discarded)")
    parser.add_argument("--quiet", action="store_true", help="Less printing per run")
    parser.add_argument("--baseline", action="store_true",
                    help="Run ABAC baseline in the normal pipeline (after Phase1/Phase2)")

    parser.add_argument("--baseline-only", action="store_true", dest="baseline_only",
                    help="Run ONLY the ABAC baseline once (no Phase1/Phase2)")
    args = parser.parse_args()

    sid = args.scenario_id

    if args.baseline_only:
        if sid not in SCENARIO_CONFIG:
            raise RuntimeError(f"No scenario configuration for scenario {sid}")
        cfg = SCENARIO_CONFIG[sid]
        ASSETS = cfg["assets"]
        MUST_OPS = cfg["must_ops"]
        NICE_OPS = cfg["nice_ops"]
        OPTIONAL_OPS = cfg["optional_ops"]
        ctx_vars = cfg["context_vars"]

        adapt_path, residual_path = build_paths(sid)
        if not os.path.exists(adapt_path):
            raise FileNotFoundError(f"Adaptive model not found: {adapt_path}")
        if not os.path.exists(residual_path):
            raise FileNotFoundError(f"Residual model not found: {residual_path}")

        OVERHEAD.reset()

        # One-shot adaptive solve (no binary search)
        chosen_auth, freeze_context = solve_adaptive_once(adapt_path, ctx_vars)

        # Baseline once
        run_abac_baseline_once(
            residual_path=residual_path,
            chosen_auth=chosen_auth,
            freeze_context=freeze_context,
            ASSETS=ASSETS,
            MUST_OPS=MUST_OPS,
            NICE_OPS=NICE_OPS,
            OPTIONAL_OPS=OPTIONAL_OPS,
            sid=sid
        )

        OVERHEAD.print_summary("Phase1Once")
        OVERHEAD.print_summary("BaselineABAC")
        return

    # Warmup runs (discarded)
    for w in range(args.warmup):
        OVERHEAD.reset()
        if args.quiet:
            # You can optionally silence prints here if you want (not necessary)
            pass
        run_once(sid, write_outputs=False, run_baseline=args.baseline)

    phase1_runs: List[Dict[str, Any]] = []
    phase2_runs: List[Dict[str, Any]] = []

    for i in range(args.repeats):
        print(f"\n\n================ RUN {i+1}/{args.repeats} ================")
        OVERHEAD.reset()

        run_once(sid, write_outputs=(i == args.repeats - 1), run_baseline=args.baseline)

        s1 = _to_ms_summary(OVERHEAD.summary("Phase1"))
        s2 = _to_ms_summary(OVERHEAD.summary("Phase2"))

        phase1_runs.append(s1)
        phase2_runs.append(s2)

        print("\n[Run overhead]")
        OVERHEAD.print_summary("Phase1")
        OVERHEAD.print_summary("Phase2")
        

    # Final paper-style aggregation
    _print_overhead_mean_std(phase1_runs, label="PHASE 1")
    _print_overhead_mean_std(phase2_runs, label="PHASE 2")

    OVERHEAD.print_effort("Phase1")
    OVERHEAD.print_effort("Phase2")






if __name__ == "__main__":
    main()
    


    