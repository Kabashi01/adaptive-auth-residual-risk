# Residual-Risk-Aware Adaptive Authentication + Adaptive Authorization (Z3 / SMT-LIB)

This repository contains:
- **Phase 1 (Adaptive Authentication model)**: an SMT-LIB model that selects an authentication method by maximizing goal satisfaction (Security, Usability, Performance) while accounting for context and attack likelihoods.
- **Phase 2 (Residual Risk + Adaptive Authorization model)**: an SMT-LIB model that **freezes** the chosen authentication method and context, then reasons about **residual risk** and **permission/operation tightening** (authorization) to contain impact.
- **Python runner**: a script that automates Phase 1 (searching for a best utility threshold) and Phase 2 (enumerating alternative authorization configurations and reporting results). It also supports an **ABAC-style baseline**.

> If you prefer running everything manually, you can still use these models directly with `z3 -smt2` by adding your own `(assert ...)`, `(check-sat)`, and `(get-value ...)` commands.

---

## Repository structure

A typical layout is:

.
├── scenario1/
│   ├── adapt_model_S1.smt2
│   └── residual_model_S1.smt2
├── scenario2/
│   ├── adapt_model_S2.smt2
│   └── residual_model_S2.smt2
├── scenario3/
│   ├── adapt_model_S3.smt2
│   └── residual_model_S3.smt2
├── scenario4/
│   ├── adapt_model_S4.smt2
│   └── residual_model_S4.smt2
├── scenario5/
│   ├── adapt_model_S5.smt2
│   └── residual_model_S5.smt2
├── scenario6/
│   ├── adapt_model_S6.smt2
│   └── residual_model_S6.smt2
└── scenario.py

Where:
- `adapt_model_S{sid}.smt2` = Phase-1 adaptive authentication model for scenario `sid`
- `residual_model_S{sid}.smt2` = Phase-2 residual-risk + authorization model for scenario `sid`
- `run_models.py` = runner (binary search in Phase 1 + progressive enumeration in Phase 2 + optional ABAC baseline)

---

## Requirements

- You need the Z3 solver installed and available in your PATH.
- Python 3.9+ recommended.

## Common CLI options

- Run a single scenario (Phase-1 + Phase-2): python3 run_models.py scenario_number
- Run with ABAC baseline too: python3 run_models.py scenario_number --baseline
- Repeat runs (e.g., for overhead statistics): python3 run_models.py scenario_number --repeats 10 --warmup 1
- Run baseline-only (skip Phase-1/Phase-2): python3 run_models.py scenario_number --baseline-only



