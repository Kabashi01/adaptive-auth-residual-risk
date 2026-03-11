[Phase1] Final values (from get-value):
  Utility = 0.43111239583333333
  ResRisk = 0.2756775
  TotalRisk = 0.5607
  Auth method : {'PinLeng': 0.7, 'PassStr': 0.0, 'OtpLeng': 0.0, 'Certificate': 0, 'SmartCard': 0, 'Token': 1, 'SignCryp': 0, 'GroupSign': 0, 'RingSign': 0, 'Iris': 0, 'Face': 0, 'Fingerprint': 0, 'TwoFactor': 1.0}
  Context : {'Location': 1.0, 'UnsecuredWiFi': 1.0, 'UnusualTime': 1.0, 'UnknownDevice': 1.0, 'PoorLighting': 0.0}
  

# Phase-2 Recommendations Report

Generated: 2026-02-01T10:39:17

## Config 1

- ResRisk: `0.2708`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5508`
- AssetValue: `0.9180`
- AuthPenalty: `0.0377`

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
| Diagnosis | ON | RW-- | 1 | 1 | 0 | 0 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | R--- | 1 | 0 | 0 | 0 |

## Config 2

- ResRisk: `0.2615`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5319`
- AssetValue: `0.8865`
- AuthPenalty: `0.0368`

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
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | ON | RWU- | 1 | 1 | 1 | 0 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | R--- | 1 | 0 | 0 | 0 |

## Config 3

- ResRisk: `0.2503`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.5091`
- AssetValue: `0.8485`
- AuthPenalty: `0.0456`

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
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RWUD | 1 | 1 | 1 | 1 |
| VisitSummaries | ON | RWUD | 1 | 1 | 1 | 1 |
| ReferralNotes | ON | RWU- | 1 | 1 | 1 | 0 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 4

- ResRisk: `0.2395`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4872`
- AssetValue: `0.8120`
- AuthPenalty: `0.1544`

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
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RW-- | 1 | 1 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RW-- | 1 | 1 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | ON | R--- | 1 | 0 | 0 | 0 |
| PatientRecords | ON | RW-- | 1 | 1 | 0 | 0 |

## Config 5

- ResRisk: `0.2274`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4626`
- AssetValue: `0.7710`
- AuthPenalty: `0.1578`

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
| Diagnosis | ON | R--- | 1 | 0 | 0 | 0 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RW-- | 1 | 1 | 0 | 0 |
| NonControlledPrescriptions | ON | RWU- | 1 | 1 | 1 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | ON | RW-- | 1 | 1 | 0 | 0 |
| VisitSummaries | ON | RW-- | 1 | 1 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | ON | R--- | 1 | 0 | 0 | 0 |
| PatientRecords | ON | R--- | 1 | 0 | 0 | 0 |

## Config 6

- ResRisk: `0.2154`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4380`
- AssetValue: `0.7300`
- AuthPenalty: `0.0996`

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
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | RWUD | 1 | 1 | 1 | 1 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | ON | RWUD | 1 | 1 | 1 | 1 |

## Config 7

- ResRisk: `0.2016`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.4101`
- AssetValue: `0.6835`
- AuthPenalty: `0.1283`

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
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| EncounterNotes | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientRecords | ON | RWU- | 1 | 1 | 1 | 0 |

## Config 8

- ResRisk: `0.1916`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.3897`
- AssetValue: `0.6495`
- AuthPenalty: `0.2033`

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
| TreatmentPlan | ON | RWU- | 1 | 1 | 1 | 0 |
| LabResults | ON | RWU- | 1 | 1 | 1 | 0 |
| TestReports | ON | RWU- | 1 | 1 | 1 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | ON | R--- | 1 | 0 | 0 | 0 |

## Config 9

- ResRisk: `0.1712`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.3483`
- AssetValue: `0.5805`
- AuthPenalty: `0.2094`

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
| TreatmentPlan | ON | RWU- | 1 | 1 | 1 | 0 |
| LabResults | ON | RW-- | 1 | 1 | 0 | 0 |
| TestReports | ON | R--- | 1 | 0 | 0 | 0 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 10

- ResRisk: `0.1628`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.3312`
- AssetValue: `0.5520`
- AuthPenalty: `0.1941`

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
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | RWUD | 1 | 1 | 1 | 1 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| EncounterNotes | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 11

- ResRisk: `0.1493`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.3036`
- AssetValue: `0.5060`
- AuthPenalty: `0.3741`

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
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | R--- | 1 | 0 | 0 | 0 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | RW-- | 1 | 1 | 0 | 0 |
| NonControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | ON | RW-- | 1 | 1 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 12

- ResRisk: `0.1420`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.2889`
- AssetValue: `0.4815`
- AuthPenalty: `0.3588`

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
| Diagnosis | ON | RWUD | 1 | 1 | 1 | 1 |
| TreatmentPlan | ON | RWUD | 1 | 1 | 1 | 1 |
| LabResults | ON | R--- | 1 | 0 | 0 | 0 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 13

- ResRisk: `0.1294`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.2632`
- AssetValue: `0.4386`
- AuthPenalty: `0.3671`

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
| LabResults | ON | RWUD | 1 | 1 | 1 | 1 |
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 14

- ResRisk: `0.1173`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.2385`
- AssetValue: `0.3975`
- AuthPenalty: `0.3713`

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
| TestReports | ON | RWUD | 1 | 1 | 1 | 1 |
| NonControlledPrescriptions | ON | R--- | 1 | 0 | 0 | 0 |
| PatientHistory | ON | R--- | 1 | 0 | 0 | 0 |
| ControlledPrescriptions | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientInteractions | OFF | ---- | 0 | 0 | 0 | 0 |
| VisitSummaries | OFF | ---- | 0 | 0 | 0 | 0 |
| ReferralNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| EncounterNotes | OFF | ---- | 0 | 0 | 0 | 0 |
| PatientRecords | OFF | ---- | 0 | 0 | 0 | 0 |

## Config 15

- ResRisk: `0.0971`
- PImpersAttack: `0.6000`
- PSessionAttack: `0.5100`
- PReplayAttack: `0.6000`
- TotalRisk: `0.1974`
- AssetValue: `0.3290`
- AuthPenalty: `0.4720`

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
| TreatmentPlan | ON | RWU- | 1 | 1 | 1 | 0 |
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

