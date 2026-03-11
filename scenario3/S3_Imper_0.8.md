[Phase1] Final values (from get-value):
  Utility = 0.5138270833333334
  ResRisk = 0.420525
  TotalRisk = 0.7476
  Auth method : {'PinLeng': 0.0, 'PassStr': 0.0, 'OtpLeng': 0.0, 'Certificate': 0, 'SmartCard': 0, 'Token': 1, 'SignCryp': 0, 'GroupSign': 0, 'RingSign': 0, 'Iris': 0, 'Face': 1, 'Fingerprint': 0, 'TwoFactor': 1.0}
  Context : {'Location': 1.0, 'UnsecuredWiFi': 1.0, 'UnusualTime': 1.0, 'UnknownDevice': 1.0, 'PoorLighting': 0.0}
  
  
# Phase-2 Recommendations Report

Generated: 2026-02-01T10:36:20

## Config 1

- ResRisk: `0.4147`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.7372`
- AssetValue: `0.9215`
- AuthPenalty: `0.0202`

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
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | ON | RWUD | 1 | 1 | 1 | 1 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | RWU- | 1 | 1 | 1 | 0 |

## Config 2

- ResRisk: `0.3969`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.7056`
- AssetValue: `0.8820`
- AuthPenalty: `0.1305`

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
| Diagnosis | ON | RW-- | 1 | 1 | 0 | 0 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RWU- | 1 | 1 | 1 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | R--- | 1 | 0 | 0 | 0 |

## Config 3

- ResRisk: `0.3965`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.7048`
- AssetValue: `0.8810`
- AuthPenalty: `0.0630`

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
| NonControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RW-- | 1 | 1 | 0 | 0 |
| ReferralNotes | ON | RWU- | 1 | 1 | 1 | 0 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | ON | RW-- | 1 | 1 | 0 | 0 |

## Config 4

- ResRisk: `0.3807`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.6768`
- AssetValue: `0.8460`
- AuthPenalty: `0.0550`

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
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RW-- | 1 | 1 | 0 | 0 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | R--- | 1 | 0 | 0 | 0 |

## Config 5

- ResRisk: `0.3645`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.6480`
- AssetValue: `0.8100`
- AuthPenalty: `0.0843`

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
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientInteractions | ON | RWUD | 1 | 1 | 1 | 1 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 6

- ResRisk: `0.3497`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.6216`
- AssetValue: `0.7770`
- AuthPenalty: `0.1391`

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
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 7

- ResRisk: `0.3467`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.6164`
- AssetValue: `0.7705`
- AuthPenalty: `0.0961`

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
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RWUD | 1 | 1 | 1 | 1 |
| VisitSummaries | ON | RW-- | 1 | 1 | 0 | 0 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | ON | R--- | 1 | 0 | 0 | 0 |

## Config 8

- ResRisk: `0.3253`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5784`
- AssetValue: `0.7230`
- AuthPenalty: `0.1596`

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
| Diagnosis | ON | RW-- | 1 | 1 | 0 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | RW-- | 1 | 1 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | ON | R--- | 1 | 0 | 0 | 0 |

## Config 9

- ResRisk: `0.3224`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5732`
- AssetValue: `0.7165`
- AuthPenalty: `0.1878`

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
| Diagnosis | ON | RWU- | 1 | 1 | 1 | 0 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | ON | R--- | 1 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 10

- ResRisk: `0.3121`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5548`
- AssetValue: `0.6935`
- AuthPenalty: `0.1277`

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
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | RW-- | 1 | 1 | 0 | 0 |
| NonControlledPrescriptions | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RWU- | 1 | 1 | 1 | 0 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 11

- ResRisk: `0.3001`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5336`
- AssetValue: `0.6670`
- AuthPenalty: `0.1517`

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
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RW-- | 1 | 1 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RWU- | 1 | 1 | 1 | 0 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | ON | R--- | 1 | 0 | 0 | 0 |

## Config 12

- ResRisk: `0.2817`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5008`
- AssetValue: `0.6260`
- AuthPenalty: `0.1956`

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
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 13

- ResRisk: `0.2655`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4720`
- AssetValue: `0.5900`
- AuthPenalty: `0.2225`

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
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | RWU- | 1 | 1 | 1 | 0 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWU- | 1 | 1 | 1 | 0 |
| NonControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientHistory | ON | RW-- | 1 | 1 | 0 | 0 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 14

- ResRisk: `0.2538`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4512`
- AssetValue: `0.5640`
- AuthPenalty: `0.2352`

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
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 15

- ResRisk: `0.2430`
- PImpersAttack: `0.8000`
- PSessionAttack: `0.6100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4320`
- AssetValue: `0.5400`
- AuthPenalty: `0.2787`

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
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

