[Phase1] Final values (from get-value):
  Utility = 0.5714545833333333
  ResRisk = 0.190015
  TotalRisk = 0.563815
  Auth method : {'PinLeng': 0.0, 'PassStr': 0.0, 'OtpLeng': 0.0, 'Certificate': 0, 'SmartCard': 0, 'Token': 1, 'SignCryp': 0, 'GroupSign': 0, 'RingSign': 0, 'Iris': 1, 'Face': 0, 'Fingerprint': 0, 'TwoFactor': 1.0}
  Context : {'Location': 1.0, 'UnsecuredWiFi': 1.0, 'UnusualTime': 1.0, 'UnknownDevice': 1.0, 'PoorLighting': 0.0}
  
  
# Phase-2 Recommendations Report

Generated: 2026-02-01T10:26:24

## Config 1

- ResRisk: `0.1846`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5478`
- AssetValue: `0.9080`
- AuthPenalty: `0.0656`

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
| TreatmentPlan | ON | RWU- | 1 | 1 | 1 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RW-- | 1 | 1 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RWUD | 1 | 1 | 1 | 1 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | ON | RWU- | 1 | 1 | 1 | 0 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | RW-- | 1 | 1 | 0 | 0 |

## Config 2

- ResRisk: `0.1661`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4929`
- AssetValue: `0.8170`
- AuthPenalty: `0.0896`

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
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 3

- ResRisk: `0.1551`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4603`
- AssetValue: `0.7630`
- AuthPenalty: `0.1447`

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
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RW-- | 1 | 1 | 0 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 4

- ResRisk: `0.1523`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4519`
- AssetValue: `0.7490`
- AuthPenalty: `0.1231`

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
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientHistory | ON | RWU- | 1 | 1 | 1 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | R--- | 1 | 0 | 0 | 0 |

## Config 5

- ResRisk: `0.1414`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4196`
- AssetValue: `0.6955`
- AuthPenalty: `0.1789`

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
| Diagnosis | ON | RWU- | 1 | 1 | 1 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | RWU- | 1 | 1 | 1 | 0 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | ON | RWU- | 1 | 1 | 1 | 0 |

## Config 6

- ResRisk: `0.1294`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.3840`
- AssetValue: `0.6365`
- AuthPenalty: `0.1740`

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
| Diagnosis | ON | RW-- | 1 | 1 | 0 | 0 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWU- | 1 | 1 | 1 | 0 |
| ControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 7

- ResRisk: `0.1080`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.3203`
- AssetValue: `0.5309`
- AuthPenalty: `0.3404`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | OFF |
| AddEncounterNote | OFF |
| AddReferralNote | OFF |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 8

- ResRisk: `0.0978`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.2902`
- AssetValue: `0.4810`
- AuthPenalty: `0.3562`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | OFF |
| AddEncounterNote | OFF |
| AddReferralNote | OFF |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | RWU- | 1 | 1 | 1 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 9

- ResRisk: `0.0939`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.2787`
- AssetValue: `0.4620`
- AuthPenalty: `0.3708`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | OFF |
| AddEncounterNote | OFF |
| AddReferralNote | OFF |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | RW-- | 1 | 1 | 0 | 0 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | ON | RW-- | 1 | 1 | 0 | 0 |
| ControlledPrescriptions | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 10

- ResRisk: `0.0702`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.2082`
- AssetValue: `0.3450`
- AuthPenalty: `0.4605`

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
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | OFF | ---- | 0 | 0 | 0 | 0 |
| ControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 11

- ResRisk: `0.0606`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.1797`
- AssetValue: `0.2978`
- AuthPenalty: `0.4762`

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
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | OFF | ---- | 0 | 0 | 0 | 0 |
| ControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 12

- ResRisk: `0.0574`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.1704`
- AssetValue: `0.2825`
- AuthPenalty: `0.4672`

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
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
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

