;; =========================
;; Phase-2 SMT (Residual Risk + Authorization)
;; - No adaptive-auth "binary search" / no goal-satisfaction utility search.
;; - Python should: (1) freeze chosen auth vars, (2) set context vars, (3) add RR bounds / objectives, then (check-sat)/(get-model).
;; =========================


;; -------------------------
;; Helpers
;; -------------------------
(define-fun _min2 ((a Real) (b Real)) Real (ite (<= a b) a b))
(define-fun _max2 ((a Real) (b Real)) Real (ite (>= a b) a b))
(define-fun _clamp01 ((x Real)) Real (_min2 1.0 (_max2 0.0 x)))

(define-fun _max3 ((a Real) (b Real) (c Real)) Real
  (ite (>= a b)
       (ite (>= a c) a c)
       (ite (>= b c) b c)))

;; -------------------------
;; Contextual factors (set/frozen from Python)
;; -------------------------
(declare-fun Location () Real)
(declare-fun InsecNetwork () Real)
(declare-fun UnusualTime () Real)
(declare-fun PoorLighting () Real)

(assert (or (= Location 0) (= Location 1)))
(assert (or (= InsecNetwork 0) (= InsecNetwork 1)))
(assert (or (= UnusualTime 0) (= UnusualTime 1)))
(assert (or (= PoorLighting 0) (= PoorLighting 1)))

;; Optional (leave unconstrained or set in Python if you use them later)
(declare-fun SessionTime () Real)
(declare-fun BehaviorDeviation () Real)
(assert (and (>= SessionTime 0) (<= SessionTime 1)))
(assert (and (>= BehaviorDeviation 0) (<= BehaviorDeviation 1)))

;; -------------------------
;; Operations (authorization decisions explored in Phase-2)
;; -------------------------
(declare-fun DiagnoseMedicalConditions () Real)  ;; must
(declare-fun ViewLabResults () Real)             ;; must
(declare-fun Controlled () Real)                 ;; nice
(declare-fun NonControlled () Real)              ;; nice
(declare-fun AddEncounterNote () Real)           ;; optional
(declare-fun AddReferralNote () Real)            ;; optional
(declare-fun GenerateReports () Real)            ;; optional

(assert (or (= DiagnoseMedicalConditions 0) (= DiagnoseMedicalConditions 1)))
(assert (or (= ViewLabResults 0) (= ViewLabResults 1)))
(assert (or (= Controlled 0) (= Controlled 1)))
(assert (or (= NonControlled 0) (= NonControlled 1)))
(assert (or (= AddEncounterNote 0) (= AddEncounterNote 1)))
(assert (or (= AddReferralNote 0) (= AddReferralNote 1)))
(assert (or (= GenerateReports 0) (= GenerateReports 1)))

;; (Must-Have) operations must be on
(assert (and (> DiagnoseMedicalConditions 0)
            (> ViewLabResults 0) ))

;; Must/Nice/Optional category flags (derived)
(declare-fun Must () Real)
(declare-fun Nice () Real)
(declare-fun Optional () Real)
(assert (or (= Must 0) (= Must 1)))
(assert (or (= Nice 0) (= Nice 1)))
(assert (or (= Optional 0) (= Optional 1)))

;; Must operations are always on
(assert (and (> Must 0) (> DiagnoseMedicalConditions 0) (> ViewLabResults 0)))

(assert (ite (or (> Controlled 0) (> NonControlled 0)) (> Nice 0) (= Nice 0)) )
(assert (ite (> Nice 0) (or (> Controlled 0) (> NonControlled 0)) (and (= Controlled 0) (= NonControlled 0)) ))

(assert  (ite (or (> AddEncounterNote 0) (> AddReferralNote 0) (> GenerateReports 0)) (> Optional 0) (= Optional 0)) )
(assert  (ite (> Optional 0) (or (> AddEncounterNote 0) (> AddReferralNote 0) (> GenerateReports 0)) (and (= AddEncounterNote 0) (= AddReferralNote 0) (= GenerateReports 0) )) )

(assert (or (> DiagnoseMedicalConditions 0) (> ViewLabResults 0 )
            (> Controlled 0) (> NonControlled 0) (> AddEncounterNote 0)
            (> AddReferralNote 0) (> GenerateReports 0)))

;; If the Optional is active then the Nice should be active
;all Optional OFF ?
(define-fun OptionalAllOff () Bool
  (and (= AddEncounterNote 0.0)
       (= AddReferralNote 0.0)
       (= GenerateReports 0.0)))

; Enforce: Nice can be OFF only after all Optional are OFF
(assert (=> (= Controlled 0.0)     OptionalAllOff))
(assert (=> (= NonControlled 0.0)  OptionalAllOff))

;; If all optional operations are off then nice operations can be disabled
(assert (ite (= Nice 0) (= Optional 0) true))

; Must > Nice > Optional ==> 

;; -------------------------
;; Assets (0/1) + permissions (Bool) + sensitivities
;; -------------------------
(declare-fun Diagnosis () Real)
(declare-fun TreatmentPlan () Real)
(declare-fun LabResults () Real)
(declare-fun TestReports () Real)
(declare-fun NonControlledPrescriptions () Real)
(declare-fun PatientHistory () Real)
(declare-fun ControlledPrescriptions () Real)
(declare-fun PatientInteractions () Real)
(declare-fun VisitSummaries () Real)
(declare-fun ReferralNotes () Real)
(declare-fun EncounterNotes () Real)
(declare-fun PatientRecords () Real)

(assert (or (= Diagnosis 0) (= Diagnosis 1)))
(assert (or (= TreatmentPlan 0) (= TreatmentPlan 1)))
(assert (or (= LabResults 0) (= LabResults 1)))
(assert (or (= TestReports 0) (= TestReports 1)))
(assert (or (= NonControlledPrescriptions 0) (= NonControlledPrescriptions 1)))
(assert (or (= PatientHistory 0) (= PatientHistory 1)))
(assert (or (= ControlledPrescriptions 0) (= ControlledPrescriptions 1)))
(assert (or (= PatientInteractions 0) (= PatientInteractions 1)))
(assert (or (= VisitSummaries 0) (= VisitSummaries 1)))
(assert (or (= ReferralNotes 0) (= ReferralNotes 1)))
(assert (or (= EncounterNotes 0) (= EncounterNotes 1)))
(assert (or (= PatientRecords 0) (= PatientRecords 1)))

;; Asset ON/OFF depends on operations (mirrors your mapping)
(assert (ite (or (> DiagnoseMedicalConditions 0) (> NonControlled 0) (> Controlled 0) (> GenerateReports 0))
             (= Diagnosis 1) (= Diagnosis 0)))

(assert (ite (or (> DiagnoseMedicalConditions 0) (> GenerateReports 0))
             (= TreatmentPlan 1) (= TreatmentPlan 0)))

(assert (ite (or (> ViewLabResults 0) (> GenerateReports 0))
             (= LabResults 1) (= LabResults 0)))

(assert (ite (> ViewLabResults 0)
             (= TestReports 1) (= TestReports 0)))

(assert (ite (> NonControlled 0)
             (= NonControlledPrescriptions 1) (= NonControlledPrescriptions 0)))

(assert (ite (or (> Controlled 0) (> NonControlled 0))
             (= PatientHistory 1) (= PatientHistory 0)))

(assert (ite (> Controlled 0)
             (= ControlledPrescriptions 1) (= ControlledPrescriptions 0)))

(assert (ite (> AddEncounterNote 0)
             (= PatientInteractions 1) (= PatientInteractions 0)))

(assert (ite (> AddEncounterNote 0)
             (= VisitSummaries 1) (= VisitSummaries 0)))

(assert (ite (> AddReferralNote 0)
             (= ReferralNotes 1) (= ReferralNotes 0)))

(assert (ite (or (> AddReferralNote 0) (> AddEncounterNote 0) )
             (= EncounterNotes 1) (= EncounterNotes 0)))

(assert (ite (> GenerateReports 0)
             (= PatientRecords 1) (= PatientRecords 0)))

;; Permissions
(declare-fun Diagnosis_Read () Bool)
(declare-fun Diagnosis_Write () Bool)
(declare-fun Diagnosis_Update () Bool)
(declare-fun Diagnosis_Delete () Bool)

(declare-fun TreatmentPlan_Read () Bool)
(declare-fun TreatmentPlan_Write () Bool)
(declare-fun TreatmentPlan_Update () Bool)
(declare-fun TreatmentPlan_Delete () Bool)

(declare-fun LabResults_Read () Bool)
(declare-fun LabResults_Write () Bool)
(declare-fun LabResults_Update () Bool)
(declare-fun LabResults_Delete () Bool)

(declare-fun TestReports_Read () Bool)
(declare-fun TestReports_Write () Bool)
(declare-fun TestReports_Update () Bool)
(declare-fun TestReports_Delete () Bool)

(declare-fun NonControlledPrescriptions_Read () Bool)
(declare-fun NonControlledPrescriptions_Write () Bool)
(declare-fun NonControlledPrescriptions_Update () Bool)
(declare-fun NonControlledPrescriptions_Delete () Bool)

(declare-fun PatientHistory_Read () Bool)
(declare-fun PatientHistory_Write () Bool)
(declare-fun PatientHistory_Update () Bool)
(declare-fun PatientHistory_Delete () Bool)

(declare-fun ControlledPrescriptions_Read () Bool)
(declare-fun ControlledPrescriptions_Write () Bool)
(declare-fun ControlledPrescriptions_Update () Bool)
(declare-fun ControlledPrescriptions_Delete () Bool)

(declare-fun PatientInteractions_Read () Bool)
(declare-fun PatientInteractions_Write () Bool)
(declare-fun PatientInteractions_Update () Bool)
(declare-fun PatientInteractions_Delete () Bool)

(declare-fun VisitSummaries_Read () Bool)
(declare-fun VisitSummaries_Write () Bool)
(declare-fun VisitSummaries_Update () Bool)
(declare-fun VisitSummaries_Delete () Bool)

(declare-fun ReferralNotes_Read () Bool)
(declare-fun ReferralNotes_Write () Bool)
(declare-fun ReferralNotes_Update () Bool)
(declare-fun ReferralNotes_Delete () Bool)

(declare-fun EncounterNotes_Read () Bool)
(declare-fun EncounterNotes_Write () Bool)
(declare-fun EncounterNotes_Update () Bool)
(declare-fun EncounterNotes_Delete () Bool)

(declare-fun PatientRecords_Read () Bool)
(declare-fun PatientRecords_Write () Bool)
(declare-fun PatientRecords_Update () Bool)
(declare-fun PatientRecords_Delete () Bool)

;; Hierarchical permissions: Delete ⇒ Update ⇒ Write ⇒ Read
(define-fun HierarchicalPermissions ((D Bool) (U Bool) (W Bool) (R Bool)) Bool
  (and (=> D U) (=> D W) (=> D R)
       (=> U W) (=> U R)
       (=> W R)))

;; Down-close: if Read is false then others must be false too
(define-fun Downclose ((D Bool) (U Bool) (W Bool) (R Bool)) Bool
  (and (=> (not R) (and (not W) (not U) (not D)))
       (=> (not W) (and (not U) (not D)))
       (=> (not U) (not D))))

;; If an asset is ON, Read must be ON; if OFF, all OFF
(define-fun AssetPermGate ((a Real) (R Bool) (W Bool) (U Bool) (D Bool)) Bool
  (ite (> a 0)
       (= R true)
       (and (= R false) (= W false) (= U false) (= D false))))

(assert (AssetPermGate Diagnosis Diagnosis_Read Diagnosis_Write Diagnosis_Update Diagnosis_Delete))
(assert (AssetPermGate TreatmentPlan TreatmentPlan_Read TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete))
(assert (AssetPermGate LabResults LabResults_Read LabResults_Write LabResults_Update LabResults_Delete))
(assert (AssetPermGate TestReports TestReports_Read TestReports_Write TestReports_Update TestReports_Delete))
(assert (AssetPermGate NonControlledPrescriptions NonControlledPrescriptions_Read NonControlledPrescriptions_Write NonControlledPrescriptions_Update NonControlledPrescriptions_Delete))
(assert (AssetPermGate PatientHistory PatientHistory_Read PatientHistory_Write PatientHistory_Update PatientHistory_Delete))
(assert (AssetPermGate ControlledPrescriptions ControlledPrescriptions_Read ControlledPrescriptions_Write ControlledPrescriptions_Update ControlledPrescriptions_Delete))
(assert (AssetPermGate PatientInteractions PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete))
(assert (AssetPermGate VisitSummaries VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete))
(assert (AssetPermGate ReferralNotes ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete))
(assert (AssetPermGate EncounterNotes EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete))
(assert (AssetPermGate PatientRecords PatientRecords_Read PatientRecords_Write PatientRecords_Update PatientRecords_Delete))

;; Apply hierarchy + downclose
(assert (HierarchicalPermissions Diagnosis_Delete Diagnosis_Update Diagnosis_Write Diagnosis_Read))
(assert (HierarchicalPermissions TreatmentPlan_Delete TreatmentPlan_Update TreatmentPlan_Write TreatmentPlan_Read))
(assert (HierarchicalPermissions LabResults_Delete LabResults_Update LabResults_Write LabResults_Read))
(assert (HierarchicalPermissions TestReports_Delete TestReports_Update TestReports_Write TestReports_Read))
(assert (HierarchicalPermissions NonControlledPrescriptions_Delete NonControlledPrescriptions_Update NonControlledPrescriptions_Write NonControlledPrescriptions_Read))
(assert (HierarchicalPermissions PatientHistory_Delete PatientHistory_Update PatientHistory_Write PatientHistory_Read))
(assert (HierarchicalPermissions ControlledPrescriptions_Delete ControlledPrescriptions_Update ControlledPrescriptions_Write ControlledPrescriptions_Read))
(assert (HierarchicalPermissions PatientInteractions_Delete PatientInteractions_Update PatientInteractions_Write PatientInteractions_Read))
(assert (HierarchicalPermissions VisitSummaries_Delete VisitSummaries_Update VisitSummaries_Write VisitSummaries_Read))
(assert (HierarchicalPermissions ReferralNotes_Delete ReferralNotes_Update ReferralNotes_Write ReferralNotes_Read))
(assert (HierarchicalPermissions EncounterNotes_Delete EncounterNotes_Update EncounterNotes_Write EncounterNotes_Read))
(assert (HierarchicalPermissions PatientRecords_Delete PatientRecords_Update PatientRecords_Write PatientRecords_Read))

(assert (Downclose Diagnosis_Delete Diagnosis_Update Diagnosis_Write Diagnosis_Read))
(assert (Downclose TreatmentPlan_Delete TreatmentPlan_Update TreatmentPlan_Write TreatmentPlan_Read))
(assert (Downclose LabResults_Delete LabResults_Update LabResults_Write LabResults_Read))
(assert (Downclose TestReports_Delete TestReports_Update TestReports_Write TestReports_Read))
(assert (Downclose NonControlledPrescriptions_Delete NonControlledPrescriptions_Update NonControlledPrescriptions_Write NonControlledPrescriptions_Read))
(assert (Downclose PatientHistory_Delete PatientHistory_Update PatientHistory_Write PatientHistory_Read))
(assert (Downclose ControlledPrescriptions_Delete ControlledPrescriptions_Update ControlledPrescriptions_Write ControlledPrescriptions_Read))
(assert (Downclose PatientInteractions_Delete PatientInteractions_Update PatientInteractions_Write PatientInteractions_Read))
(assert (Downclose VisitSummaries_Delete VisitSummaries_Update VisitSummaries_Write VisitSummaries_Read))
(assert (Downclose ReferralNotes_Delete ReferralNotes_Update ReferralNotes_Write ReferralNotes_Read))
(assert (Downclose EncounterNotes_Delete EncounterNotes_Update EncounterNotes_Write EncounterNotes_Read))
(assert (Downclose PatientRecords_Delete PatientRecords_Update PatientRecords_Write PatientRecords_Read))

;; Minimum permissions required for each operation
(define-fun NeedsRead  ((op Real) (p Bool)) Bool (=> (> op 0) p))
(define-fun NeedsWrite ((op Real) (p Bool)) Bool (=> (> op 0) p))

;; MUST
(assert (NeedsRead DiagnoseMedicalConditions Diagnosis_Read))
(assert (NeedsRead DiagnoseMedicalConditions TreatmentPlan_Read))
(assert (NeedsRead ViewLabResults LabResults_Read))
(assert (NeedsRead ViewLabResults TestReports_Read))

;; NICE
(assert (NeedsRead Controlled ControlledPrescriptions_Read))
(assert (NeedsRead Controlled PatientHistory_Read))
(assert (NeedsRead NonControlled NonControlledPrescriptions_Read))
(assert (NeedsRead NonControlled PatientHistory_Read))

;; OPTIONAL
(assert (NeedsWrite AddEncounterNote PatientInteractions_Write))
(assert (NeedsWrite AddEncounterNote VisitSummaries_Write))
(assert (NeedsWrite AddReferralNote ReferralNotes_Write))
(assert (NeedsWrite AddReferralNote EncounterNotes_Write))
(assert (NeedsRead GenerateReports Diagnosis_Read))
(assert (NeedsRead GenerateReports TreatmentPlan_Read))
(assert (NeedsRead GenerateReports LabResults_Read))
(assert (NeedsRead GenerateReports PatientRecords_Read))

;; -------------------------
;; Sensitivity (ranges depend on highest permission granted)
;; -------------------------
(declare-fun DiagnosisSensitivity () Real)
(declare-fun TreatmentPlanSensitivity () Real)
(declare-fun LabResultsSensitivity () Real)
(declare-fun TestReportsSensitivity () Real)
(declare-fun NonControlledPrescriptionsSensitivity () Real)
(declare-fun PatientHistorySensitivity () Real)
(declare-fun ControlledPrescriptionsSensitivity () Real)
(declare-fun PatientInteractionsSensitivity () Real)
(declare-fun VisitSummariesSensitivity () Real)
(declare-fun ReferralNotesSensitivity () Real)
(declare-fun EncounterNotesSensitivity () Real)
(declare-fun PatientRecordsSensitivity () Real)

;; Diagnosis
(assert (ite Diagnosis_Delete
            (and (>= DiagnosisSensitivity 0.67) (<= DiagnosisSensitivity 0.70))
            (ite Diagnosis_Update
                 (and (>= DiagnosisSensitivity 0.64) (<= DiagnosisSensitivity 0.67))
                 (ite Diagnosis_Write
                      (and (>= DiagnosisSensitivity 0.60) (<= DiagnosisSensitivity 0.64))
                      (and (>= DiagnosisSensitivity 0.50) (<= DiagnosisSensitivity 0.60))))))

;; TreatmentPlan
(assert (ite TreatmentPlan_Delete
            (and (>= TreatmentPlanSensitivity 0.57) (<= TreatmentPlanSensitivity 0.60))
            (ite TreatmentPlan_Update
                 (and (>= TreatmentPlanSensitivity 0.54) (<= TreatmentPlanSensitivity 0.57))
                 (ite TreatmentPlan_Write
                      (and (>= TreatmentPlanSensitivity 0.50) (<= TreatmentPlanSensitivity 0.54))
                      (and (>= TreatmentPlanSensitivity 0.40) (<= TreatmentPlanSensitivity 0.50))))))

;; LabResults
(assert (ite LabResults_Delete
            (and (>= LabResultsSensitivity 0.57) (<= LabResultsSensitivity 0.60))
            (ite LabResults_Update
                 (and (>= LabResultsSensitivity 0.54) (<= LabResultsSensitivity 0.57))
                 (ite LabResults_Write
                      (and (>= LabResultsSensitivity 0.50) (<= LabResultsSensitivity 0.54))
                      (and (>= LabResultsSensitivity 0.40) (<= LabResultsSensitivity 0.50))))))

;; TestReports
(assert (ite TestReports_Delete
            (and (>= TestReportsSensitivity 0.57) (<= TestReportsSensitivity 0.60))
            (ite TestReports_Update
                 (and (>= TestReportsSensitivity 0.54) (<= TestReportsSensitivity 0.57))
                 (ite TestReports_Write
                      (and (>= TestReportsSensitivity 0.50) (<= TestReportsSensitivity 0.54))
                      (and (>= TestReportsSensitivity 0.40) (<= TestReportsSensitivity 0.50))))))

;; NonControlledPrescriptions
(assert (ite NonControlledPrescriptions_Delete
            (and (>= NonControlledPrescriptionsSensitivity 0.67) (<= NonControlledPrescriptionsSensitivity 0.70))
            (ite NonControlledPrescriptions_Update
                 (and (>= NonControlledPrescriptionsSensitivity 0.64) (<= NonControlledPrescriptionsSensitivity 0.67))
                 (ite NonControlledPrescriptions_Write
                      (and (>= NonControlledPrescriptionsSensitivity 0.60) (<= NonControlledPrescriptionsSensitivity 0.64))
                      (and (>= NonControlledPrescriptionsSensitivity 0.50) (<= NonControlledPrescriptionsSensitivity 0.60))))))

;; PatientHistory
(assert (ite PatientHistory_Delete
            (and (>= PatientHistorySensitivity 0.77) (<= PatientHistorySensitivity 0.80))
            (ite PatientHistory_Update
                 (and (>= PatientHistorySensitivity 0.74) (<= PatientHistorySensitivity 0.77))
                 (ite PatientHistory_Write
                      (and (>= PatientHistorySensitivity 0.70) (<= PatientHistorySensitivity 0.74))
                      (and (>= PatientHistorySensitivity 0.65) (<= PatientHistorySensitivity 0.70))))))

;; ControlledPrescriptions
(assert (ite ControlledPrescriptions_Delete
            (and (>= ControlledPrescriptionsSensitivity 0.86) (<= ControlledPrescriptionsSensitivity 0.87))
            (ite ControlledPrescriptions_Update
                 (and (>= ControlledPrescriptionsSensitivity 0.84) (<= ControlledPrescriptionsSensitivity 0.86))
                 (ite ControlledPrescriptions_Write
                      (and (>= ControlledPrescriptionsSensitivity 0.80) (<= ControlledPrescriptionsSensitivity 0.84))
                      (and (>= ControlledPrescriptionsSensitivity 0.75) (<= ControlledPrescriptionsSensitivity 0.80))))))

;; PatientInteractions
(assert (ite PatientInteractions_Delete
            (and (>= PatientInteractionsSensitivity 0.86) (<= PatientInteractionsSensitivity 0.88))
            (ite PatientInteractions_Update
                 (and (>= PatientInteractionsSensitivity 0.84) (<= PatientInteractionsSensitivity 0.86))
                 (ite PatientInteractions_Write
                      (and (>= PatientInteractionsSensitivity 0.80) (<= PatientInteractionsSensitivity 0.84))
                      (and (>= PatientInteractionsSensitivity 0.75) (<= PatientInteractionsSensitivity 0.80))))))

;; VisitSummaries
(assert (ite VisitSummaries_Delete
            (and (>= VisitSummariesSensitivity 0.77) (<= VisitSummariesSensitivity 0.80))
            (ite VisitSummaries_Update
                 (and (>= VisitSummariesSensitivity 0.74) (<= VisitSummariesSensitivity 0.77))
                 (ite VisitSummaries_Write
                      (and (>= VisitSummariesSensitivity 0.70) (<= VisitSummariesSensitivity 0.74))
                      (and (>= VisitSummariesSensitivity 0.65) (<= VisitSummariesSensitivity 0.70))))))

;; ReferralNotes
(assert (ite ReferralNotes_Delete
            (and (>= ReferralNotesSensitivity 0.67) (<= ReferralNotesSensitivity 0.70))
            (ite ReferralNotes_Update
                 (and (>= ReferralNotesSensitivity 0.64) (<= ReferralNotesSensitivity 0.67))
                 (ite ReferralNotes_Write
                      (and (>= ReferralNotesSensitivity 0.60) (<= ReferralNotesSensitivity 0.64))
                      (and (>= ReferralNotesSensitivity 0.55) (<= ReferralNotesSensitivity 0.60))))))

;; EncounterNotes
(assert (ite EncounterNotes_Delete
            (and (>= EncounterNotesSensitivity 0.67) (<= EncounterNotesSensitivity 0.70))
            (ite EncounterNotes_Update
                 (and (>= EncounterNotesSensitivity 0.64) (<= EncounterNotesSensitivity 0.67))
                 (ite EncounterNotes_Write
                      (and (>= EncounterNotesSensitivity 0.60) (<= EncounterNotesSensitivity 0.64))
                      (and (>= EncounterNotesSensitivity 0.55) (<= EncounterNotesSensitivity 0.60))))))

;; PatientRecords
(assert (ite PatientRecords_Delete
            (and (>= PatientRecordsSensitivity 0.97) (<= PatientRecordsSensitivity 1.00))
            (ite PatientRecords_Update
                 (and (>= PatientRecordsSensitivity 0.94) (<= PatientRecordsSensitivity 0.97))
                 (ite PatientRecords_Write
                      (and (>= PatientRecordsSensitivity 0.92) (<= PatientRecordsSensitivity 0.94))
                      (and (>= PatientRecordsSensitivity 0.90) (<= PatientRecordsSensitivity 0.92))))))

;; -------------------------
;; AssetValue aggregation
;; -------------------------
(declare-fun AssetValue () Real)
(assert (and (>= AssetValue 0) (<= AssetValue 1)))

(assert (= AssetValue
  (+ (* Diagnosis DiagnosisSensitivity 0.2)
     (* TreatmentPlan TreatmentPlanSensitivity 0.2)
     (* LabResults LabResultsSensitivity 0.1)
     (* TestReports TestReportsSensitivity 0.05)
     (* NonControlledPrescriptions NonControlledPrescriptionsSensitivity 0.1)
     (* PatientHistory PatientHistorySensitivity 0.15)
     (* ControlledPrescriptions ControlledPrescriptionsSensitivity 0.1)
     (* PatientInteractions PatientInteractionsSensitivity 0.05)
     (* VisitSummaries VisitSummariesSensitivity 0.1)
     (* ReferralNotes ReferralNotesSensitivity 0.05)
     (* EncounterNotes EncounterNotesSensitivity 0.05)
     (* PatientRecords PatientRecordsSensitivity 0.15))))

;; -------------------------
;; Auth variables (Phase-1 freezes these; Phase-2 only uses them)
;; -------------------------
(declare-fun PassStr () Real)
(declare-fun PinLeng () Real)
(declare-fun OtpLeng () Real)

(declare-fun Certificate () Real)
(declare-fun SmartCard () Real)
(declare-fun Token () Real)
(declare-fun SignCryp () Real)
(declare-fun GroupSign () Real)
(declare-fun RingSign () Real)
(declare-fun Iris () Real)
(declare-fun Face () Real)
(declare-fun Fingerprint () Real)

(declare-fun TwoFactor () Real)
(declare-fun count () Real)

;; Ranges (safe, even if frozen)
(assert (or (= PassStr 0.0) (= PassStr 0.5) (= PassStr 0.7) (= PassStr 1.0)))
(assert (or (= PinLeng 0.0) (= PinLeng 0.5) (= PinLeng 0.7) (= PinLeng 1.0)))
(assert (or (= OtpLeng 0.0) (= OtpLeng 0.5) (= OtpLeng 0.7) (= OtpLeng 1.0)))

(assert (or (= Certificate 0) (= Certificate 1)))
(assert (or (= SmartCard 0) (= SmartCard 1)))
(assert (or (= Token 0) (= Token 1)))
(assert (or (= SignCryp 0) (= SignCryp 1)))
(assert (or (= GroupSign 0) (= GroupSign 1)))
(assert (or (= RingSign 0) (= RingSign 1)))
(assert (or (= Iris 0) (= Iris 1)))
(assert (or (= Face 0) (= Face 1)))
(assert (or (= Fingerprint 0) (= Fingerprint 1)))

(assert (or (= TwoFactor 0) (= TwoFactor 1)))
(assert (= count (ite (> TwoFactor 0) 2 1)))

;; NightTime constraint example (keep if you want it in Phase-2)
(assert (ite (> PoorLighting 0) (and (= Iris 0) (= Face 0)) true))

;; -------------------------
;; Attacks: base likelihood + mitigation + residual risk
;; -------------------------
(declare-fun PImpersAttack () Real)
(declare-fun PReplayAttack () Real)
(declare-fun PSessionAttack () Real)

(assert (and (>= PImpersAttack 0) (<= PImpersAttack 1)))
(assert (and (>= PReplayAttack 0) (<= PReplayAttack 1)))
(assert (and (>= PSessionAttack 0) (<= PSessionAttack 1)))



;If(> Insecure Network 0)                
;(assert (ite (> InsecNetwork 0) (and (= PImpersAttack 0.5) (= PSessionAttack 0.7) (= PReplayAttack 0.6) ) true  )) 


; --- Sensitivity: Impersonation likelihood (baseline=0.5, Δ=0.1) ---
; ;If(> InsecNetwork 0)                
; (assert (ite (> InsecNetwork 0)(and (= PImpersAttack 0.3) (= PSessionAttack 0.7) (= PReplayAttack 0.6))
;     true))

; If(> InsecNetwork 0)                
; (assert (ite (> InsecNetwork 0)
;     (and (= PImpersAttack 0.4) (= PSessionAttack 0.7) (= PReplayAttack 0.6))
;     true))

; If(> InsecNetwork 0)                
;(assert (ite (> InsecNetwork 0)
 ;   (and (= PImpersAttack 0.5) (= PSessionAttack 0.7) (= PReplayAttack 0.6))
  ;  true))

;If(> InsecNetwork 0)                
; (assert (ite (> InsecNetwork 0)
;    (and (= PImpersAttack 0.6) (= PSessionAttack 0.7) (= PReplayAttack 0.6))
;    true))

; If(> InsecNetwork 0)                
;(assert (ite (> InsecNetwork 0)
 ;   (and (= PImpersAttack 0.7) (= PSessionAttack 0.7) (= PReplayAttack 0.6))
  ;  true))





; ===== Replay sensitivity: PReplayAttack = 0.4 (-0.2) =====
; If(> Insecure Network 0)
; (assert (ite (> InsecNetwork 0)
;     (and (= PImpersAttack 0.5) (= PSessionAttack 0.7) (= PReplayAttack 0.4))
;     true))

; ; ===== Replay sensitivity: PReplayAttack = 0.5 (-0.1) =====
; If(> Insecure Network 0)
(assert (ite (> InsecNetwork 0)
    (and (= PImpersAttack 0.5) (= PSessionAttack 0.7) (= PReplayAttack 0.5))
    true))


; ; ===== Replay sensitivity: PReplayAttack = 0.7 (+0.1) =====
; If(> Insecure Network 0)
; (assert (ite (> InsecNetwork 0)
;     (and (= PImpersAttack 0.5) (= PSessionAttack 0.7) (= PReplayAttack 0.7))
;     true))

; ===== Replay sensitivity: PReplayAttack = 0.8 (+0.2) =====
; If(> Insecure Network 0)
; (assert (ite (> InsecNetwork 0)
;     (and (= PImpersAttack 0.5) (= PSessionAttack 0.7) (= PReplayAttack 0.8))
;     true))


; ===== Session sensitivity: PSessionAttack = 0.5 (-0.2) =====
; If(> Insecure Network 0)
; (assert (ite (> InsecNetwork 0)
;     (and (= PImpersAttack 0.5) (= PSessionAttack 0.5) (= PReplayAttack 0.6))
;     true))

; ===== Session sensitivity: PSessionAttack = 0.6 (-0.1) =====
; If(> Insecure Network 0)
; (assert (ite (> InsecNetwork 0)
;     (and (= PImpersAttack 0.5) (= PSessionAttack 0.6) (= PReplayAttack 0.6))
;     true))


; ; ===== Session sensitivity: PSessionAttack = 0.8 (+0.1) =====
; If(> InsecNetwork 0)
; (assert (ite (> InsecNetwork 0)
;     (and (= PImpersAttack 0.5) (= PSessionAttack 0.8) (= PReplayAttack 0.6))
;     true))

; ; ===== Session sensitivity: PSessionAttack = 0.9 (+0.2) =====
; If(> InsecNetwork 0)
; (assert (ite (> InsecNetwork 0)
;     (and (= PImpersAttack 0.5) (= PSessionAttack 0.9) (= PReplayAttack 0.6))
;     true))



(declare-fun ImpersAttackImpact () Real)
(declare-fun ReplayAttackImpact () Real)
(declare-fun SessionAttackImpact () Real)

(assert (and (>= ImpersAttackImpact 0) (<= ImpersAttackImpact 1)))
(assert (and (>= ReplayAttackImpact 0) (<= ReplayAttackImpact 1)))
(assert (and (>= SessionAttackImpact 0) (<= SessionAttackImpact 1)))

;; Deterministic mitigation impacts (clamped)
(assert (= ImpersAttackImpact
  (_clamp01
    (/ (+ (* PinLeng 0.3)
          (* PassStr 0.3)
          (* OtpLeng 0.3)
          (* Certificate 0.7)
          (* SmartCard 0.3)
          (* Token 0.3)
          (* SignCryp 0.1)
          (* GroupSign 0.1)
          (* RingSign 0.1)
          (* Iris 0.1)
          (* Face 0.1)
          (* Fingerprint 0.1)
          (ite (> TwoFactor 0) 0.3 0.0))
       count))))

(assert (= ReplayAttackImpact
  (_clamp01
    (/ (+ (* PinLeng 0.3)
          (* PassStr 0.3)
          (* OtpLeng 0.1)
          (* Certificate 0.7)
          (* SmartCard 0.3)
          (* Token 0.1)
          (* SignCryp 0.1)
          (* GroupSign 0.1)
          (* RingSign 0.1)
          (* Iris 0.1)
          (* Face 0.1)
          (* Fingerprint 0.1)
          (ite (> TwoFactor 0) 0.3 0.0))
       count))))

(assert (= SessionAttackImpact
  (_clamp01
    (/ (+ (* PinLeng 0.3)
          (* PassStr 0.3)
          (* OtpLeng 0.3)
          (* Certificate 0.5)
          (* SmartCard 0.6)
          (* Token 0.6)
          (* SignCryp 0.2)
          (* GroupSign 0.2)
          (* RingSign 0.2)
          (* Iris 0.3)
          (* Face 0.3)
          (* Fingerprint 0.3)
          (ite (> TwoFactor 0) 0.3 0.0))
       count))))

;; Likelihood after applying mitigation
(declare-fun FPImpersAttack () Real)
(declare-fun FPReplayAttack () Real)
(declare-fun FPSessionAttack () Real)

(assert (= FPImpersAttack (_clamp01 (- PImpersAttack ImpersAttackImpact))))
(assert (= FPReplayAttack (_clamp01 (- PReplayAttack ReplayAttackImpact))))
(assert (= FPSessionAttack (_clamp01 (- PSessionAttack SessionAttackImpact))))

;; Risks
(declare-fun BPRiskPImpersAttack () Real)
(declare-fun BPRiskReplayAttack () Real)
(declare-fun BPRiskSessionAttack () Real)

(declare-fun PRiskPImpersAttack () Real)
(declare-fun PRiskReplayAttack () Real)
(declare-fun PRiskSessionAttack () Real)

(assert (= BPRiskPImpersAttack (* PImpersAttack AssetValue)))
(assert (= BPRiskReplayAttack (* PReplayAttack AssetValue)))
(assert (= BPRiskSessionAttack (* PSessionAttack AssetValue)))

(assert (= PRiskPImpersAttack (* FPImpersAttack AssetValue)))
(assert (= PRiskReplayAttack (* FPReplayAttack AssetValue)))
(assert (= PRiskSessionAttack (* FPSessionAttack AssetValue)))

(declare-fun TotalRisk () Real)
(declare-fun ResRisk () Real)
(assert (and (>= TotalRisk 0) (<= TotalRisk 1)))
(assert (and (>= ResRisk 0) (<= ResRisk 1)))

;; These to help in changing the aggregation function 
(declare-fun UseMaxAgg () Bool)
(declare-fun UseSumAgg () Bool)
(assert (or UseMaxAgg UseSumAgg))
(assert (not (and UseMaxAgg UseSumAgg)))

(declare-fun ResRiskSum () Real)
(declare-fun TotalRiskSum () Real)
(assert (= ResRiskSum (/ (+ PRiskPImpersAttack PRiskReplayAttack PRiskSessionAttack) 3)))


;; The Total Risk before any mitigation
(assert (= TotalRiskSum (/ (+ BPRiskPImpersAttack BPRiskReplayAttack BPRiskSessionAttack) 3)))


;; The Total Risk before any mitigation
(assert (= TotalRisk
  (ite UseMaxAgg
    (ite (>= BPRiskPImpersAttack BPRiskReplayAttack)
      (ite (>= BPRiskPImpersAttack BPRiskSessionAttack) BPRiskPImpersAttack BPRiskSessionAttack)
      (ite (>= BPRiskReplayAttack BPRiskSessionAttack) BPRiskReplayAttack BPRiskSessionAttack))
    TotalRiskSum)))

(assert (= ResRisk
  (ite UseMaxAgg
    (ite (>= PRiskPImpersAttack PRiskReplayAttack)
      (ite (>= PRiskPImpersAttack PRiskSessionAttack) PRiskPImpersAttack PRiskSessionAttack)
      (ite (>= PRiskReplayAttack PRiskSessionAttack) PRiskReplayAttack PRiskSessionAttack))
    ResRiskSum))) 

(assert (= UseMaxAgg true))

;; -------------------------
;; Authorization penalty
;; -------------------------
;; Permission level (cumulative): Read=0, Write=1, Update=2, Delete=3
(define-fun _lvlcost ((D Bool) (U Bool) (W Bool) (R Bool)) Real
  (ite D 3.0 (ite U 2.0 (ite W 1.0 (ite R 0.0 0.0)))))

;; Reduction tightness (higher when permissions are reduced)
(define-fun _tight ((D Bool) (U Bool) (W Bool) (R Bool)) Real
  (- 1.0 (/ (_lvlcost D U W R) 3.0)))

(declare-fun PermPenaltyN () Real)
(assert (= PermPenaltyN
  (+ (* (_tight Diagnosis_Delete Diagnosis_Update Diagnosis_Write Diagnosis_Read) DiagnosisSensitivity Diagnosis)
     (* (_tight TreatmentPlan_Delete TreatmentPlan_Update TreatmentPlan_Write TreatmentPlan_Read) TreatmentPlanSensitivity TreatmentPlan)
     (* (_tight LabResults_Delete LabResults_Update LabResults_Write LabResults_Read) LabResultsSensitivity LabResults)
     (* (_tight TestReports_Delete TestReports_Update TestReports_Write TestReports_Read) TestReportsSensitivity TestReports)
     (* (_tight NonControlledPrescriptions_Delete NonControlledPrescriptions_Update NonControlledPrescriptions_Write NonControlledPrescriptions_Read)
        NonControlledPrescriptionsSensitivity NonControlledPrescriptions)
     (* (_tight PatientHistory_Delete PatientHistory_Update PatientHistory_Write PatientHistory_Read) PatientHistorySensitivity PatientHistory)
     (* (_tight ControlledPrescriptions_Delete ControlledPrescriptions_Update ControlledPrescriptions_Write ControlledPrescriptions_Read)
        ControlledPrescriptionsSensitivity ControlledPrescriptions)
     (* (_tight PatientInteractions_Delete PatientInteractions_Update PatientInteractions_Write PatientInteractions_Read)
        PatientInteractionsSensitivity PatientInteractions)
     (* (_tight VisitSummaries_Delete VisitSummaries_Update VisitSummaries_Write VisitSummaries_Read)
        VisitSummariesSensitivity VisitSummaries)
     (* (_tight ReferralNotes_Delete ReferralNotes_Update ReferralNotes_Write ReferralNotes_Read)
        ReferralNotesSensitivity ReferralNotes)
     (* (_tight EncounterNotes_Delete EncounterNotes_Update EncounterNotes_Write EncounterNotes_Read)
        EncounterNotesSensitivity EncounterNotes)
     (* (_tight PatientRecords_Delete PatientRecords_Update PatientRecords_Write PatientRecords_Read)
        PatientRecordsSensitivity PatientRecords))))

(declare-fun PermPenalty () Real)
(assert (= PermPenalty (_clamp01 (/ PermPenaltyN 12))))

(declare-fun OpDisabledPenalty () Real)
(assert (= OpDisabledPenalty
  (+ (* 1.0 (- 1.0 DiagnoseMedicalConditions))
     (* 1.0 (- 1.0 ViewLabResults))
     (* 0.7 (- 1.0 Controlled))
     (* 0.7 (- 1.0 NonControlled))
     (* 0.4 (- 1.0 AddEncounterNote))
     (* 0.4 (- 1.0 AddReferralNote))
     (* 0.4 (- 1.0 GenerateReports)))))

(declare-fun OpDisabledPenaltyN () Real)
(assert (= OpDisabledPenaltyN (_clamp01 (/ OpDisabledPenalty 4.6))))

(declare-fun AuthorizationPenalty () Real)
(assert (= AuthorizationPenalty
  (_clamp01 (+ (* 0.2 PermPenalty)
               (* 0.8 OpDisabledPenaltyN)))))
(assert (and (>= AuthorizationPenalty 0.0) (<= AuthorizationPenalty 1.0)))

;; -------------------------
;; Phase-2 objective helper (you can optimize this from Python)
;; -------------------------
(declare-fun AuthUtility () Real)
(assert (and (>= AuthUtility 0) (<= AuthUtility 1)))
(assert (= AuthUtility (/ (+ (- 1.0 ResRisk) AssetValue) 2.0)))


; --- FREEZE (from Phase 1) ---
(assert (= PinLeng 0))
(assert (= PassStr 0))
(assert (= OtpLeng 0))
(assert (= Certificate 0))
(assert (= SmartCard 1))
(assert (= Token 0))
(assert (= SignCryp 0))
(assert (= GroupSign 0))
(assert (= RingSign 0))
(assert (= Iris 0))
(assert (= Face 0))
(assert (= Fingerprint 1))
(assert (= TwoFactor 1))
(assert (= Location 1))
(assert (= UnusualTime 1))
(assert (= InsecNetwork 1))
(assert (= PoorLighting 0))

; --- Progressive RR upper bound  ---
(assert (< ResRisk 0.008175))
(assert (> ResRisk 0.0))
; --- BLOCKING CLAUSES (global enumeration) ---
(assert (or (not (= DiagnoseMedicalConditions 1.0)) (not (= ViewLabResults 1.0)) (not (= Controlled 1.0)) (not (= NonControlled 1.0)) (not (= AddEncounterNote 1.0)) (not (= AddReferralNote 1.0)) (not (= GenerateReports 1.0)) (not Diagnosis_Read) Diagnosis_Write Diagnosis_Update Diagnosis_Delete (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) (not TreatmentPlan_Delete) (not LabResults_Read) (not LabResults_Write) (not LabResults_Update) (not LabResults_Delete) (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not NonControlledPrescriptions_Read) NonControlledPrescriptions_Write NonControlledPrescriptions_Update NonControlledPrescriptions_Delete (not PatientHistory_Read) (not PatientHistory_Write) (not PatientHistory_Update) (not PatientHistory_Delete) (not ControlledPrescriptions_Read) (not ControlledPrescriptions_Write) (not ControlledPrescriptions_Update) (not ControlledPrescriptions_Delete) (not PatientInteractions_Read) (not PatientInteractions_Write) (not PatientInteractions_Update) PatientInteractions_Delete (not VisitSummaries_Read) (not VisitSummaries_Write) (not VisitSummaries_Update) VisitSummaries_Delete (not ReferralNotes_Read) (not ReferralNotes_Write) ReferralNotes_Update ReferralNotes_Delete (not EncounterNotes_Read) (not EncounterNotes_Write) (not EncounterNotes_Update) (not EncounterNotes_Delete) (not PatientRecords_Read) (not PatientRecords_Write) (not PatientRecords_Update) (not PatientRecords_Delete)))
(assert (or (not (= DiagnoseMedicalConditions 1.0)) (not (= ViewLabResults 1.0)) (not (= Controlled 1.0)) (not (= NonControlled 1.0)) (not (= AddEncounterNote 0.0)) (not (= AddReferralNote 1.0)) (not (= GenerateReports 1.0)) (not Diagnosis_Read) (not Diagnosis_Write) (not Diagnosis_Update) (not Diagnosis_Delete) (not TreatmentPlan_Read) TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete (not LabResults_Read) LabResults_Write LabResults_Update LabResults_Delete (not TestReports_Read) (not TestReports_Write) TestReports_Update TestReports_Delete (not NonControlledPrescriptions_Read) (not NonControlledPrescriptions_Write) (not NonControlledPrescriptions_Update) (not NonControlledPrescriptions_Delete) (not PatientHistory_Read) (not PatientHistory_Write) (not PatientHistory_Update) PatientHistory_Delete (not ControlledPrescriptions_Read) (not ControlledPrescriptions_Write) (not ControlledPrescriptions_Update) (not ControlledPrescriptions_Delete) PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete (not ReferralNotes_Read) (not ReferralNotes_Write) (not ReferralNotes_Update) ReferralNotes_Delete (not EncounterNotes_Read) (not EncounterNotes_Write) EncounterNotes_Update EncounterNotes_Delete (not PatientRecords_Read) (not PatientRecords_Write) (not PatientRecords_Update) (not PatientRecords_Delete)))
(assert (or (not (= DiagnoseMedicalConditions 1.0)) (not (= ViewLabResults 1.0)) (not (= Controlled 1.0)) (not (= NonControlled 1.0)) (not (= AddEncounterNote 0.0)) (not (= AddReferralNote 1.0)) (not (= GenerateReports 1.0)) (not Diagnosis_Read) (not Diagnosis_Write) (not Diagnosis_Update) (not Diagnosis_Delete) (not TreatmentPlan_Read) TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete (not LabResults_Read) LabResults_Write LabResults_Update LabResults_Delete (not TestReports_Read) (not TestReports_Write) TestReports_Update TestReports_Delete (not NonControlledPrescriptions_Read) (not NonControlledPrescriptions_Write) (not NonControlledPrescriptions_Update) (not NonControlledPrescriptions_Delete) (not PatientHistory_Read) (not PatientHistory_Write) (not PatientHistory_Update) (not PatientHistory_Delete) (not ControlledPrescriptions_Read) (not ControlledPrescriptions_Write) (not ControlledPrescriptions_Update) (not ControlledPrescriptions_Delete) PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete (not ReferralNotes_Read) (not ReferralNotes_Write) (not ReferralNotes_Update) ReferralNotes_Delete (not EncounterNotes_Read) (not EncounterNotes_Write) (not EncounterNotes_Update) EncounterNotes_Delete (not PatientRecords_Read) (not PatientRecords_Write) (not PatientRecords_Update) (not PatientRecords_Delete)))
(assert (or (not (= DiagnoseMedicalConditions 1.0)) (not (= ViewLabResults 1.0)) (not (= Controlled 1.0)) (not (= NonControlled 1.0)) (not (= AddEncounterNote 0.0)) (not (= AddReferralNote 1.0)) (not (= GenerateReports 1.0)) (not Diagnosis_Read) (not Diagnosis_Write) (not Diagnosis_Update) (not Diagnosis_Delete) (not TreatmentPlan_Read) TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete (not LabResults_Read) LabResults_Write LabResults_Update LabResults_Delete (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not NonControlledPrescriptions_Read) NonControlledPrescriptions_Write NonControlledPrescriptions_Update NonControlledPrescriptions_Delete (not PatientHistory_Read) PatientHistory_Write PatientHistory_Update PatientHistory_Delete (not ControlledPrescriptions_Read) ControlledPrescriptions_Write ControlledPrescriptions_Update ControlledPrescriptions_Delete PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete (not ReferralNotes_Read) (not ReferralNotes_Write) ReferralNotes_Update ReferralNotes_Delete (not EncounterNotes_Read) (not EncounterNotes_Write) EncounterNotes_Update EncounterNotes_Delete (not PatientRecords_Read) PatientRecords_Write PatientRecords_Update PatientRecords_Delete))
(assert (or (not (= DiagnoseMedicalConditions 1.0)) (not (= ViewLabResults 1.0)) (not (= Controlled 1.0)) (not (= NonControlled 1.0)) (not (= AddEncounterNote 1.0)) (not (= AddReferralNote 0.0)) (not (= GenerateReports 0.0)) (not Diagnosis_Read) Diagnosis_Write Diagnosis_Update Diagnosis_Delete (not TreatmentPlan_Read) TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete (not LabResults_Read) (not LabResults_Write) LabResults_Update LabResults_Delete (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not NonControlledPrescriptions_Read) NonControlledPrescriptions_Write NonControlledPrescriptions_Update NonControlledPrescriptions_Delete (not PatientHistory_Read) PatientHistory_Write PatientHistory_Update PatientHistory_Delete (not ControlledPrescriptions_Read) ControlledPrescriptions_Write ControlledPrescriptions_Update ControlledPrescriptions_Delete (not PatientInteractions_Read) (not PatientInteractions_Write) PatientInteractions_Update PatientInteractions_Delete (not VisitSummaries_Read) (not VisitSummaries_Write) VisitSummaries_Update VisitSummaries_Delete ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete (not EncounterNotes_Read) (not EncounterNotes_Write) EncounterNotes_Update EncounterNotes_Delete PatientRecords_Read PatientRecords_Write PatientRecords_Update PatientRecords_Delete))
(assert (or (not (= DiagnoseMedicalConditions 1.0)) (not (= ViewLabResults 1.0)) (not (= Controlled 1.0)) (not (= NonControlled 1.0)) (not (= AddEncounterNote 0.0)) (not (= AddReferralNote 0.0)) (not (= GenerateReports 0.0)) (not Diagnosis_Read) Diagnosis_Write Diagnosis_Update Diagnosis_Delete (not TreatmentPlan_Read) TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete (not LabResults_Read) LabResults_Write LabResults_Update LabResults_Delete (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not NonControlledPrescriptions_Read) (not NonControlledPrescriptions_Write) (not NonControlledPrescriptions_Update) (not NonControlledPrescriptions_Delete) (not PatientHistory_Read) PatientHistory_Write PatientHistory_Update PatientHistory_Delete (not ControlledPrescriptions_Read) (not ControlledPrescriptions_Write) (not ControlledPrescriptions_Update) (not ControlledPrescriptions_Delete) PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete PatientRecords_Read PatientRecords_Write PatientRecords_Update PatientRecords_Delete))
(assert (or (not (= DiagnoseMedicalConditions 1.0)) (not (= ViewLabResults 1.0)) (not (= Controlled 0.0)) (not (= NonControlled 1.0)) (not (= AddEncounterNote 0.0)) (not (= AddReferralNote 0.0)) (not (= GenerateReports 0.0)) (not Diagnosis_Read) Diagnosis_Write Diagnosis_Update Diagnosis_Delete (not TreatmentPlan_Read) TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete (not LabResults_Read) (not LabResults_Write) (not LabResults_Update) LabResults_Delete (not TestReports_Read) (not TestReports_Write) TestReports_Update TestReports_Delete (not NonControlledPrescriptions_Read) (not NonControlledPrescriptions_Write) (not NonControlledPrescriptions_Update) (not NonControlledPrescriptions_Delete) (not PatientHistory_Read) (not PatientHistory_Write) (not PatientHistory_Update) (not PatientHistory_Delete) ControlledPrescriptions_Read ControlledPrescriptions_Write ControlledPrescriptions_Update ControlledPrescriptions_Delete PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete PatientRecords_Read PatientRecords_Write PatientRecords_Update PatientRecords_Delete))
(assert (or (not (= DiagnoseMedicalConditions 1.0)) (not (= ViewLabResults 1.0)) (not (= Controlled 0.0)) (not (= NonControlled 0.0)) (not (= AddEncounterNote 0.0)) (not (= AddReferralNote 0.0)) (not (= GenerateReports 0.0)) (not Diagnosis_Read) Diagnosis_Write Diagnosis_Update Diagnosis_Delete (not TreatmentPlan_Read) TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete (not LabResults_Read) LabResults_Write LabResults_Update LabResults_Delete (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete NonControlledPrescriptions_Read NonControlledPrescriptions_Write NonControlledPrescriptions_Update NonControlledPrescriptions_Delete PatientHistory_Read PatientHistory_Write PatientHistory_Update PatientHistory_Delete ControlledPrescriptions_Read ControlledPrescriptions_Write ControlledPrescriptions_Update ControlledPrescriptions_Delete PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete PatientRecords_Read PatientRecords_Write PatientRecords_Update PatientRecords_Delete))
(assert (or (not (= DiagnoseMedicalConditions 1.0)) (not (= ViewLabResults 1.0)) (not (= Controlled 0.0)) (not (= NonControlled 0.0)) (not (= AddEncounterNote 0.0)) (not (= AddReferralNote 0.0)) (not (= GenerateReports 0.0)) (not Diagnosis_Read) (not Diagnosis_Write) (not Diagnosis_Update) (not Diagnosis_Delete) (not TreatmentPlan_Read) (not TreatmentPlan_Write) TreatmentPlan_Update TreatmentPlan_Delete (not LabResults_Read) LabResults_Write LabResults_Update LabResults_Delete (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete NonControlledPrescriptions_Read NonControlledPrescriptions_Write NonControlledPrescriptions_Update NonControlledPrescriptions_Delete PatientHistory_Read PatientHistory_Write PatientHistory_Update PatientHistory_Delete ControlledPrescriptions_Read ControlledPrescriptions_Write ControlledPrescriptions_Update ControlledPrescriptions_Delete PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete PatientRecords_Read PatientRecords_Write PatientRecords_Update PatientRecords_Delete))

(check-sat)
(get-value (ResRisk AssetValue AuthorizationPenalty PermPenalty DiagnoseMedicalConditions ViewLabResults Controlled NonControlled AddEncounterNote AddReferralNote GenerateReports Diagnosis_Read Diagnosis_Write Diagnosis_Update Diagnosis_Delete TreatmentPlan_Read TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete LabResults_Read LabResults_Write LabResults_Update LabResults_Delete TestReports_Read TestReports_Write TestReports_Update TestReports_Delete NonControlledPrescriptions_Read NonControlledPrescriptions_Write NonControlledPrescriptions_Update NonControlledPrescriptions_Delete PatientHistory_Read PatientHistory_Write PatientHistory_Update PatientHistory_Delete ControlledPrescriptions_Read ControlledPrescriptions_Write ControlledPrescriptions_Update ControlledPrescriptions_Delete PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete PatientRecords_Read PatientRecords_Write PatientRecords_Update PatientRecords_Delete Diagnosis TreatmentPlan LabResults TestReports NonControlledPrescriptions PatientHistory ControlledPrescriptions PatientInteractions VisitSummaries ReferralNotes EncounterNotes PatientRecords PRiskPImpersAttack PRiskReplayAttack PRiskSessionAttack TotalRisk PImpersAttack PReplayAttack PSessionAttack FPImpersAttack FPReplayAttack FPSessionAttack))
