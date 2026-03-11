[Phase1] Final values (from get-value):
  Utility = 0.5605520833333333
  ResRisk = 0.233625
  TotalRisk = 0.570045
  Auth method : {'PinLeng': 0.0, 'PassStr': 0.0, 'OtpLeng': 0.0, 'Certificate': 0, 'SmartCard': 0, 'Token': 1, 'SignCryp': 0, 'GroupSign': 0, 'RingSign': 0, 'Iris': 1, 'Face': 0, 'Fingerprint': 0, 'TwoFactor': 1.0}
  Context : {'Location': 1.0, 'UnsecuredWiFi': 1.0, 'UnusualTime': 1.0, 'UnknownDevice': 1.0, 'PoorLighting': 0.0}
  
  
  
# Phase-2 Recommendations Report

Generated: 2026-02-01T10:45:37

## Config 1

- ResRisk: `0.2309`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.5633`
- AssetValue: `0.9235`
- AuthPenalty: `0.0367`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | ON |
| AddEncounterNote | ON |
| AddReferralNote | ON |
| GenerateReports | ON |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 2

- ResRisk: `0.2212`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.5396`
- AssetValue: `0.8846`
- AuthPenalty: `0.0589`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | ON |
| AddEncounterNote | ON |
| AddReferralNote | ON |
| GenerateReports | ON |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | RWU- | 1 | 1 | 1 | 0 |
| TreatmentPlan | ON | RW-- | 1 | 1 | 0 | 0 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RW-- | 1 | 1 | 0 | 0 |
| ControlledPrescriptions | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RWU- | 1 | 1 | 1 | 0 |
| ReferralNotes | ON | RWU- | 1 | 1 | 1 | 0 |
| EncounterNotes | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 3

- ResRisk: `0.2086`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.5090`
- AssetValue: `0.8345`
- AuthPenalty: `0.0973`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | ON |
| AddEncounterNote | ON |
| AddReferralNote | OFF |
| GenerateReports | ON |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | ON | RWUD | 1 | 1 | 1 | 1 |
| VisitSummaries | ON | RW-- | 1 | 1 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 4

- ResRisk: `0.1935`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.4721`
- AssetValue: `0.7740`
- AuthPenalty: `0.1175`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | ON |
| AddEncounterNote | ON |
| AddReferralNote | ON |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | RWU- | 1 | 1 | 1 | 0 |
| TreatmentPlan | ON | RWU- | 1 | 1 | 1 | 0 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | RWU- | 1 | 1 | 1 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RW-- | 1 | 1 | 0 | 0 |
| ControlledPrescriptions | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientInteractions | ON | RWUD | 1 | 1 | 1 | 1 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 5

- ResRisk: `0.1851`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.4517`
- AssetValue: `0.7405`
- AuthPenalty: `0.1087`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | ON |
| AddEncounterNote | OFF |
| AddReferralNote | ON |
| GenerateReports | ON |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 6

- ResRisk: `0.1731`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.4224`
- AssetValue: `0.6925`
- AuthPenalty: `0.2011`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | ON |
| AddEncounterNote | OFF |
| AddReferralNote | OFF |
| GenerateReports | ON |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | RWU- | 1 | 1 | 1 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RW-- | 1 | 1 | 0 | 0 |
| ControlledPrescriptions | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | ON | RW-- | 1 | 1 | 0 | 0 |

## Config 7

- ResRisk: `0.1499`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.3657`
- AssetValue: `0.5995`
- AuthPenalty: `0.1766`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | ON |
| AddEncounterNote | OFF |
| AddReferralNote | ON |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 8

- ResRisk: `0.1388`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.3386`
- AssetValue: `0.5550`
- AuthPenalty: `0.2598`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | ON |
| AddEncounterNote | OFF |
| AddReferralNote | OFF |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | RW-- | 1 | 1 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 9

- ResRisk: `0.1370`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.3343`
- AssetValue: `0.5480`
- AuthPenalty: `0.1991`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | ON |
| AddEncounterNote | OFF |
| AddReferralNote | ON |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 10

- ResRisk: `0.1251`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.3053`
- AssetValue: `0.5005`
- AuthPenalty: `0.2468`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | ON |
| AddEncounterNote | OFF |
| AddReferralNote | OFF |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | RW-- | 1 | 1 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 11

- ResRisk: `0.1125`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.2745`
- AssetValue: `0.4500`
- AuthPenalty: `0.3652`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | OFF |
| NonControlled | ON |
| AddEncounterNote | OFF |
| AddReferralNote | OFF |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | RW-- | 1 | 1 | 0 | 0 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | RWU- | 1 | 1 | 1 | 0 |
| NonControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 12

- ResRisk: `0.1003`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.2446`
- AssetValue: `0.4010`
- AuthPenalty: `0.3712`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | OFF |
| NonControlled | ON |
| AddEncounterNote | OFF |
| AddReferralNote | OFF |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWU- | 1 | 1 | 1 | 0 |
| ControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 13

- ResRisk: `0.0834`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.2034`
- AssetValue: `0.3335`
- AuthPenalty: `0.4522`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | OFF |
| NonControlled | OFF |
| AddEncounterNote | OFF |
| AddReferralNote | OFF |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | OFF | ---- | 0 | 0 | 0 | 0 |
| ControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 14

- ResRisk: `0.0721`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.1760`
- AssetValue: `0.2885`
- AuthPenalty: `0.4772`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | OFF |
| NonControlled | OFF |
| AddEncounterNote | OFF |
| AddReferralNote | OFF |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | OFF | ---- | 0 | 0 | 0 | 0 |
| ControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 15

- ResRisk: `0.0643`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.5000`
- TotalRisk: `0.1568`
- AssetValue: `0.2570`
- AuthPenalty: `0.4738`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | OFF |
| NonControlled | OFF |
| AddEncounterNote | OFF |
| AddReferralNote | OFF |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | OFF | ---- | 0 | 0 | 0 | 0 |
| ControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

