[Phase1] Final values (from get-value):
  Utility = 0.5371895833333333
  ResRisk = 0.327075
  TotalRisk = 0.756945
  Auth method : {'PinLeng': 0.0, 'PassStr': 0.0, 'OtpLeng': 0.0, 'Certificate': 0, 'SmartCard': 0, 'Token': 1, 'SignCryp': 0, 'GroupSign': 0, 'RingSign': 0, 'Iris': 1, 'Face': 0, 'Fingerprint': 0, 'TwoFactor': 1.0}
  Context : {'Location': 1.0, 'UnsecuredWiFi': 1.0, 'UnusualTime': 1.0, 'UnknownDevice': 1.0, 'PoorLighting': 0.0}
  
  
# Phase-2 Recommendations Report

Generated: 2026-02-01T10:41:30

## Config 1

- ResRisk: `0.3155`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.7302`
- AssetValue: `0.9015`
- AuthPenalty: `0.0508`

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
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RW-- | 1 | 1 | 0 | 0 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 2

- ResRisk: `0.3134`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.7254`
- AssetValue: `0.8955`
- AuthPenalty: `0.0718`

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
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | RWU- | 1 | 1 | 1 | 0 |
| NonControlledPrescriptions | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RWU- | 1 | 1 | 1 | 0 |
| ReferralNotes | ON | RWU- | 1 | 1 | 1 | 0 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | ON | RWU- | 1 | 1 | 1 | 0 |

## Config 3

- ResRisk: `0.3022`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.6994`
- AssetValue: `0.8635`
- AuthPenalty: `0.0552`

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
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientInteractions | ON | RWU- | 1 | 1 | 1 | 0 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | ON | RW-- | 1 | 1 | 0 | 0 |

## Config 4

- ResRisk: `0.2791`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.6460`
- AssetValue: `0.7975`
- AuthPenalty: `0.1051`

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
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWU- | 1 | 1 | 1 | 0 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RWUD | 1 | 1 | 1 | 1 |
| VisitSummaries | ON | RW-- | 1 | 1 | 0 | 0 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 5

- ResRisk: `0.2677`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.6196`
- AssetValue: `0.7649`
- AuthPenalty: `0.1120`

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
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWU- | 1 | 1 | 1 | 0 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RW-- | 1 | 1 | 0 | 0 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 6

- ResRisk: `0.2662`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.6160`
- AssetValue: `0.7605`
- AuthPenalty: `0.1110`

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
| Diagnosis | ON | RWU- | 1 | 1 | 1 | 0 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 7

- ResRisk: `0.2539`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5877`
- AssetValue: `0.7255`
- AuthPenalty: `0.1245`

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
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 8

- ResRisk: `0.2315`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5358`
- AssetValue: `0.6615`
- AuthPenalty: `0.1847`

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
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RW-- | 1 | 1 | 0 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RWU- | 1 | 1 | 1 | 0 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 9

- ResRisk: `0.2306`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5338`
- AssetValue: `0.6590`
- AuthPenalty: `0.1980`

### Operations

| Operation | State |
|---|---|
| DiagnoseMedicalConditions | ON |
| ViewLabResults | ON |
| Controlled | ON |
| NonControlled | ON |
| AddEncounterNote | ON |
| AddReferralNote | OFF |
| GenerateReports | OFF |

### Assets and CRUD permissions

| Asset | AssetState | CRUD | Read | Write | Update | Delete |
|---|---|---|---|---|---|---|
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | ON | R--- | 1 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 10

- ResRisk: `0.2086`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4828`
- AssetValue: `0.5960`
- AuthPenalty: `0.2189`

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
| Diagnosis | ON | RWU- | 1 | 1 | 1 | 0 |
| TreatmentPlan | ON | RWU- | 1 | 1 | 1 | 0 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 11

- ResRisk: `0.2034`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4706`
- AssetValue: `0.5810`
- AuthPenalty: `0.2191`

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
| Diagnosis | ON | RWU- | 1 | 1 | 1 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 12

- ResRisk: `0.1948`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4508`
- AssetValue: `0.5565`
- AuthPenalty: `0.2058`

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
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 13

- ResRisk: `0.1766`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4086`
- AssetValue: `0.5045`
- AuthPenalty: `0.3779`

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
| TreatmentPlan | ON | RWU- | 1 | 1 | 1 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | ON | RWU- | 1 | 1 | 1 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 14

- ResRisk: `0.1696`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.3924`
- AssetValue: `0.4845`
- AuthPenalty: `0.3571`

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
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 15

- ResRisk: `0.1578`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.8100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.3653`
- AssetValue: `0.4510`
- AuthPenalty: `0.3732`

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
| LabResults | ON | RW-- | 1 | 1 | 0 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

