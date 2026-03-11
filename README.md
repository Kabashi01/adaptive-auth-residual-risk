# Residual Risk–Aware Adaptive Authentication (SMT Models + Artifacts)

This repository contains SMT-LIB models and supporting artifacts for **Residual Risk–Aware Adaptive Authentication** and **post-authentication Adaptive Authorization**. The models use **Z3** to (i) select authentication methods under contextual conditions and multi-objective requirements, and (ii) compute **residual risk** and recommend authorization configurations that contain impact while preserving essential functionality.

## Contents

### SMT Models
- **Adaptive Authentication model (Phase 1)**  
  Selects an authentication method by balancing:
  - Security (Authenticity, Confidentiality, Integrity)
  - Usability (Effectiveness, Efficiency)
  - Performance  
  and accounts for contextual factors and attack likelihoods.

- **Residual Risk + Authorization model (Phase 2)**  
  Freezes the authentication decision from Phase 1 and computes:
  - Total/Residual risk under modeled attacks
  - Asset-value weighted risk
  - Permission and operation restrictions
  - Authorization penalty/containment cost

### Key constraints included
- **Permission gating constraint** (example):
  - If an asset is enabled, `Read` must be enabled.
  - If an asset is disabled, all CRUD permissions must be disabled.

```smt2
;; If an asset is ON, Read must be ON; if OFF, all OFF
(define-fun AssetPermGate ((a Real) (R Bool) (W Bool) (U Bool) (D Bool)) Bool
  (ite (> a 0)
       (= R true)
       (and (= R false) (= W false) (= U false) (= D false))))

##The Repository structure##
.
├── Scenario1/
│   ├── adapt_model_S1.smt2
│   └── residual_model_S1.smt2
├── Scenario2/
│   ├── adapt_model_S2.smt2
│   └── residual_model_S2.smt2
├── Scenario3/
│   ├── adapt_model_S3.smt2
│   └── residual_model_S3.smt2
├── Scenario4/ ...
├── scripts/
│   └── run_models.py
├── results/
│   └── (optional outputs: TSV/MD/JSONL)
└── README.md


##How to run##

