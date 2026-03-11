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
;; The second scenario contextual factors
(declare-fun Location() Real)
(declare-fun UnsecuredWiFi() Real)
(declare-fun InsecNetwork() Real)
(declare-fun Emergency() Real)
(declare-fun PoorLighting () Real)

;; 0 positive and 1 negative
(assert (or (=  Location 0) (= Location 1)))
(assert (or (=  UnsecuredWiFi 0) (= UnsecuredWiFi 1)))
(assert (or (=  InsecNetwork 0) (= InsecNetwork 1)))
(assert (or (=  Emergency 0) (= Emergency 1)))
(assert (or (=  PoorLighting 0) (= PoorLighting 1)))



;; Operation Declarations
(declare-fun AccessPatientProfile () Real)
(declare-fun OrderLabTest () Real)
(declare-fun ViewRadiologyImages () Real)
(declare-fun ApproveDischargeSummary () Real)
(declare-fun AdjustCarePlan () Real)
(declare-fun RequestConsultation () Real)
(declare-fun ManageAppointment () Real)
(declare-fun CommunicateWithPatient () Real)
(declare-fun PrintMedicalReport () Real)


;; Operations values 
(assert (or (= AccessPatientProfile 0) (= AccessPatientProfile 1)))
(assert (or (= OrderLabTest 0) (= OrderLabTest 1)))
(assert (or (= ViewRadiologyImages 0) (= ViewRadiologyImages 1)))
(assert (or (= ApproveDischargeSummary 0) (= ApproveDischargeSummary 1)))
(assert (or (= AdjustCarePlan 0) (= AdjustCarePlan 1)))
(assert (or (= RequestConsultation 0) (= RequestConsultation 1)))
(assert (or (= ManageAppointment 0) (= ManageAppointment 1)))
(assert (or (= CommunicateWithPatient 0) (= CommunicateWithPatient 1)))
(assert (or (= PrintMedicalReport 0) (= PrintMedicalReport 1)))


;; (Must-Have) operations must be on
(assert (and (> AccessPatientProfile 0) (> OrderLabTest 0) (> AdjustCarePlan 0) ))

;; Must/Nice/Optional category flags (derived)
(declare-fun Must () Real)
(declare-fun Nice () Real)
(declare-fun Optional () Real)
(assert (or (= Must 0) (= Must 1)))
(assert (or (= Nice 0) (= Nice 1)))
(assert (or (= Optional 0) (= Optional 1)))

;; Must category logic
(assert (and (> Must 0) (> AccessPatientProfile 0) (> OrderLabTest 0) (> AdjustCarePlan 0)))

;; Nice category logic
(assert (ite (or (> ApproveDischargeSummary 0) (> RequestConsultation 0) (> CommunicateWithPatient 0)) (> Nice 0) (= Nice 0)) )
(assert (ite (> Nice 0) (or (> ApproveDischargeSummary 0) (> RequestConsultation 0) (> CommunicateWithPatient 0)) 
            (and (= ApproveDischargeSummary 0) (= RequestConsultation 0) (= CommunicateWithPatient 0)) ))

;; Optional category logic
(assert (ite (or (> ViewRadiologyImages 0) (> ManageAppointment 0) (> PrintMedicalReport 0)) (> Optional 0) (= Optional 0)) )
(assert (ite (> Optional 0) (or (> ViewRadiologyImages 0) (> ManageAppointment 0) (> PrintMedicalReport 0)) 
             (and (= ViewRadiologyImages 0) (= ManageAppointment 0) (= PrintMedicalReport 0)) ))

;; At least one operation should be active
(assert (or (> AccessPatientProfile 0) (> OrderLabTest 0) (> AdjustCarePlan 0)
            (> ApproveDischargeSummary 0) (> RequestConsultation 0) (> CommunicateWithPatient 0)
            (> ViewRadiologyImages 0) (> ManageAppointment 0) (> PrintMedicalReport 0)))


;; If the Optional is active then the Nice should be active
;all Optional OFF ?
(define-fun OptionalAllOff () Bool
  (and (= ViewRadiologyImages 0.0)
       (= ManageAppointment 0.0)
       (= PrintMedicalReport 0.0)))

; Enforce: Nice can be OFF only after all Optional are OFF
(assert (=> (= ApproveDischargeSummary 0.0)     OptionalAllOff))
(assert (=> (= RequestConsultation 0.0)  OptionalAllOff))
(assert (=> (= CommunicateWithPatient 0.0)  OptionalAllOff))

;; If all optional operations are off then nice operations can be disabled
(assert (ite (= Nice 0) (= Optional 0) true))

; Must > Nice > Optional ==> 

;; -------------------------
;; Assets (0/1) + permissions (Bool) + sensitivities
;; Asset Declarations
(declare-fun Diagnosis () Real)
(declare-fun TreatmentPlan () Real)
(declare-fun LabResults () Real)
(declare-fun TestReports () Real)
(declare-fun PatientHistory () Real)
(declare-fun PatientInteractions () Real)
(declare-fun VisitSummaries () Real)
(declare-fun ReferralNotes () Real)
(declare-fun EncounterNotes () Real)
(declare-fun PatientRecords () Real)
(declare-fun PatientDemographics () Real)
(declare-fun RadiologyImages () Real)
(declare-fun DischargeSummaries () Real)
(declare-fun PatientCommunications () Real)


;; Asset domain: each asset is binary (0 or 1)
(assert (or (= Diagnosis 0) (= Diagnosis 1)))
(assert (or (= TreatmentPlan 0) (= TreatmentPlan 1)))
(assert (or (= LabResults 0) (= LabResults 1)))
(assert (or (= TestReports 0) (= TestReports 1)))
(assert (or (= PatientHistory 0) (= PatientHistory 1)))
(assert (or (= PatientInteractions 0) (= PatientInteractions 1)))
(assert (or (= VisitSummaries 0) (= VisitSummaries 1)))
(assert (or (= ReferralNotes 0) (= ReferralNotes 1)))
(assert (or (= EncounterNotes 0) (= EncounterNotes 1)))
(assert (or (= PatientRecords 0) (= PatientRecords 1)))
(assert (or (= PatientDemographics 0) (= PatientDemographics 1)))
(assert (or (= RadiologyImages 0) (= RadiologyImages 1)))
(assert (or (= DischargeSummaries 0) (= DischargeSummaries 1)))
(assert (or (= PatientCommunications 0) (= PatientCommunications 1)))

;; Asset ON/OFF depends on operations (mirrors your mapping)
;; Asset value is >= 0 and <= 1
(assert (or (=  Diagnosis 0) (= Diagnosis 1)))
(assert (ite (or (> AdjustCarePlan 0) (> PrintMedicalReport 0) )(> Diagnosis 0)(= Diagnosis 0) ))

(assert (or (=  PatientRecords 0) (= PatientRecords 1)))
(assert (ite (or (> AccessPatientProfile 0) (> ViewRadiologyImages 0) (> ManageAppointment 0) (> PrintMedicalReport 0))(> PatientRecords 0)(= PatientRecords 0) ))

(assert (or (=  TreatmentPlan 0) (= TreatmentPlan 1)))
(assert (ite (or (> ApproveDischargeSummary 0) (> AdjustCarePlan 0) (> PrintMedicalReport 0))(> TreatmentPlan 0)(= TreatmentPlan 0) ))

(assert (or (=  LabResults 0) (= LabResults 1)))
(assert (ite (> OrderLabTest 0) (> LabResults 0)(= LabResults 0) ))

(assert (or (=  TestReports 0) (= TestReports 1)))
(assert (ite ( or (> OrderLabTest 0) (> ViewRadiologyImages 0)) (> TestReports 0) (= TestReports 0) ))

(assert (or (=  PatientHistory 0) (= PatientHistory 1)))
(assert (ite (> AccessPatientProfile 0) (> PatientHistory 0)(= PatientHistory 0) ))

(assert (or (=  PatientInteractions 0) (= PatientInteractions 1)))
(assert (ite (> CommunicateWithPatient 0) (> PatientInteractions 0) (= PatientInteractions 0) ))

(assert (or (=  VisitSummaries 0) (= VisitSummaries 1)))
(assert (ite (or (> ApproveDischargeSummary 0) (> ManageAppointment 0))(> VisitSummaries 0)(= VisitSummaries 0) ))


(assert (or (=  ReferralNotes 0) (= ReferralNotes 1)))
(assert (ite (> RequestConsultation 0) (> ReferralNotes 0) (= ReferralNotes 0) ))

(assert (or (=  EncounterNotes 0) (= EncounterNotes 1)))
(assert (ite (> RequestConsultation 0) (> EncounterNotes 0) (= EncounterNotes 0) ))

(assert (or (=  PatientDemographics 0) (= PatientDemographics 1)))
(assert (ite (> AccessPatientProfile 0) (> PatientDemographics 0) (= PatientDemographics 0) ))

(assert (or (=  RadiologyImages 0) (= RadiologyImages 1)))
(assert (ite (> ViewRadiologyImages 0) (> RadiologyImages 0) (= RadiologyImages 0) ))

(assert (or (=  DischargeSummaries 0) (= DischargeSummaries 1)))
(assert (ite (> ApproveDischargeSummary 0) (> DischargeSummaries 0) (= DischargeSummaries 0) ))

(assert (or (=  PatientCommunications 0) (= PatientCommunications 1)))
(assert (ite (> CommunicateWithPatient 0) (> PatientCommunications 0) (= PatientCommunications 0) ))

;;---------------------

;; --- Asset Permission Declarations and Sensitivity Ranges ---

;; Diagnosis
(declare-fun Diagnosis_Read () Bool)
(declare-fun Diagnosis_Write () Bool)
(declare-fun Diagnosis_Update () Bool)
(declare-fun Diagnosis_Delete () Bool)
(declare-fun DiagnosisSensitivity () Real)
(assert
  (ite Diagnosis_Delete
    (and (>= DiagnosisSensitivity 0.67) (<= DiagnosisSensitivity 0.7))
    (ite Diagnosis_Update
      (and (>= DiagnosisSensitivity 0.64) (<= DiagnosisSensitivity 0.67))
      (ite Diagnosis_Write
        (and (>= DiagnosisSensitivity 0.6) (<= DiagnosisSensitivity 0.64))
        (and (>= DiagnosisSensitivity 0.5) (<= DiagnosisSensitivity 0.6))
      )
    )
  )
)

;; TreatmentPlan
(declare-fun TreatmentPlan_Read () Bool)
(declare-fun TreatmentPlan_Write () Bool)
(declare-fun TreatmentPlan_Update () Bool)
(declare-fun TreatmentPlan_Delete () Bool)
(declare-fun TreatmentPlanSensitivity () Real)
(assert
  (ite TreatmentPlan_Delete
    (and (>= TreatmentPlanSensitivity 0.57) (<= TreatmentPlanSensitivity 0.6))
    (ite TreatmentPlan_Update
      (and (>= TreatmentPlanSensitivity 0.54) (<= TreatmentPlanSensitivity 0.57))
      (ite TreatmentPlan_Write
        (and (>= TreatmentPlanSensitivity 0.5) (<= TreatmentPlanSensitivity 0.54))
        (and (>= TreatmentPlanSensitivity 0.4) (<= TreatmentPlanSensitivity 0.5))
      )
    )
  )
)

;; LabResults
(declare-fun LabResults_Read () Bool)
(declare-fun LabResults_Write () Bool)
(declare-fun LabResults_Update () Bool)
(declare-fun LabResults_Delete () Bool)
(declare-fun LabResultsSensitivity () Real)
(assert
  (ite LabResults_Delete
    (and (>= LabResultsSensitivity 0.57) (<= LabResultsSensitivity 0.6))
    (ite LabResults_Update
      (and (>= LabResultsSensitivity 0.54) (<= LabResultsSensitivity 0.57))
      (ite LabResults_Write
        (and (>= LabResultsSensitivity 0.5) (<= LabResultsSensitivity 0.54))
        (and (>= LabResultsSensitivity 0.4) (<= LabResultsSensitivity 0.5))
      )
    )
  )
)

;; TestReports
(declare-fun TestReports_Read () Bool)
(declare-fun TestReports_Write () Bool)
(declare-fun TestReports_Update () Bool)
(declare-fun TestReports_Delete () Bool)
(declare-fun TestReportsSensitivity () Real)
(assert
  (ite TestReports_Delete
    (and (>= TestReportsSensitivity 0.57) (<= TestReportsSensitivity 0.6))
    (ite TestReports_Update
      (and (>= TestReportsSensitivity 0.54) (<= TestReportsSensitivity 0.57))
      (ite TestReports_Write
        (and (>= TestReportsSensitivity 0.5) (<= TestReportsSensitivity 0.54))
        (and (>= TestReportsSensitivity 0.4) (<= TestReportsSensitivity 0.5))
      )
    )
  )
)

;; PatientHistory
(declare-fun PatientHistory_Read () Bool)
(declare-fun PatientHistory_Write () Bool)
(declare-fun PatientHistory_Update () Bool)
(declare-fun PatientHistory_Delete () Bool)
(declare-fun PatientHistorySensitivity () Real)
(assert
  (ite PatientHistory_Delete
    (and (>= PatientHistorySensitivity 0.77) (<= PatientHistorySensitivity 0.8))
    (ite PatientHistory_Update
      (and (>= PatientHistorySensitivity 0.74) (<= PatientHistorySensitivity 0.77))
      (ite PatientHistory_Write
        (and (>= PatientHistorySensitivity 0.7) (<= PatientHistorySensitivity 0.74))
        (and (>= PatientHistorySensitivity 0.65) (<= PatientHistorySensitivity 0.7))
      )
    )
  )
)

;; PatientInteractions
(declare-fun PatientInteractions_Read () Bool)
(declare-fun PatientInteractions_Write () Bool)
(declare-fun PatientInteractions_Update () Bool)
(declare-fun PatientInteractions_Delete () Bool)
(declare-fun PatientInteractionsSensitivity () Real)
(assert
  (ite PatientInteractions_Delete
    (and (>= PatientInteractionsSensitivity 0.87) (<= PatientInteractionsSensitivity 0.9))
    (ite PatientInteractions_Update
      (and (>= PatientInteractionsSensitivity 0.84) (<= PatientInteractionsSensitivity 0.87))
      (ite PatientInteractions_Write
        (and (>= PatientInteractionsSensitivity 0.8) (<= PatientInteractionsSensitivity 0.84))
        (and (>= PatientInteractionsSensitivity 0.75) (<= PatientInteractionsSensitivity 0.8))
      )
    )
  )
)

;; VisitSummaries
(declare-fun VisitSummaries_Read () Bool)
(declare-fun VisitSummaries_Write () Bool)
(declare-fun VisitSummaries_Update () Bool)
(declare-fun VisitSummaries_Delete () Bool)
(declare-fun VisitSummariesSensitivity () Real)
(assert
  (ite VisitSummaries_Delete
    (and (>= VisitSummariesSensitivity 0.77) (<= VisitSummariesSensitivity 0.8))
    (ite VisitSummaries_Update
      (and (>= VisitSummariesSensitivity 0.74) (<= VisitSummariesSensitivity 0.77))
      (ite VisitSummaries_Write
        (and (>= VisitSummariesSensitivity 0.7) (<= VisitSummariesSensitivity 0.74))
        (and (>= VisitSummariesSensitivity 0.65) (<= VisitSummariesSensitivity 0.7))
      )
    )
  )
)

;; ReferralNotes
(declare-fun ReferralNotes_Read () Bool)
(declare-fun ReferralNotes_Write () Bool)
(declare-fun ReferralNotes_Update () Bool)
(declare-fun ReferralNotes_Delete () Bool)
(declare-fun ReferralNotesSensitivity () Real)
(assert
  (ite ReferralNotes_Delete
    (and (>= ReferralNotesSensitivity 0.67) (<= ReferralNotesSensitivity 0.7))
    (ite ReferralNotes_Update
      (and (>= ReferralNotesSensitivity 0.64) (<= ReferralNotesSensitivity 0.67))
      (ite ReferralNotes_Write
        (and (>= ReferralNotesSensitivity 0.6) (<= ReferralNotesSensitivity 0.64))
        (and (>= ReferralNotesSensitivity 0.55) (<= ReferralNotesSensitivity 0.6))
      )
    )
  )
)

;; EncounterNotes
(declare-fun EncounterNotes_Read () Bool)
(declare-fun EncounterNotes_Write () Bool)
(declare-fun EncounterNotes_Update () Bool)
(declare-fun EncounterNotes_Delete () Bool)
(declare-fun EncounterNotesSensitivity () Real)
(assert
  (ite EncounterNotes_Delete
    (and (>= EncounterNotesSensitivity 0.67) (<= EncounterNotesSensitivity 0.7))
    (ite EncounterNotes_Update
      (and (>= EncounterNotesSensitivity 0.64) (<= EncounterNotesSensitivity 0.67))
      (ite EncounterNotes_Write
        (and (>= EncounterNotesSensitivity 0.6) (<= EncounterNotesSensitivity 0.64))
        (and (>= EncounterNotesSensitivity 0.55) (<= EncounterNotesSensitivity 0.6))
      )
    )
  )
)

;; PatientRecords
(declare-fun PatientRecords_Read () Bool)
(declare-fun PatientRecords_Write () Bool)
(declare-fun PatientRecords_Update () Bool)
(declare-fun PatientRecords_Delete () Bool)
(declare-fun PatientRecordsSensitivity () Real)
(assert
  (ite PatientRecords_Delete
    (and (>= PatientRecordsSensitivity 0.97) (<= PatientRecordsSensitivity 0.99))
    (ite PatientRecords_Update
      (and (>= PatientRecordsSensitivity 0.94) (<= PatientRecordsSensitivity 0.97))
      (ite PatientRecords_Write
        (and (>= PatientRecordsSensitivity 0.92) (<= PatientRecordsSensitivity 0.94))
        (and (>= PatientRecordsSensitivity 0.9) (<= PatientRecordsSensitivity 0.92))
      )
    )
  )
)




;; PatientDemographics Sensitivity and Permissions
(declare-fun PatientDemographics_Read () Bool)
(declare-fun PatientDemographics_Write () Bool)
(declare-fun PatientDemographics_Update () Bool)
(declare-fun PatientDemographics_Delete () Bool)
(declare-fun PatientDemographicsSensitivity () Real)

(assert
  (ite PatientDemographics_Delete
    (and (>= PatientDemographicsSensitivity 0.7) (<= PatientDemographicsSensitivity 0.75))
    (ite PatientDemographics_Update
      (and (>= PatientDemographicsSensitivity 0.65) (<= PatientDemographicsSensitivity 0.7))
      (ite PatientDemographics_Write
        (and (>= PatientDemographicsSensitivity 0.6) (<= PatientDemographicsSensitivity 0.65))
        (and (>= PatientDemographicsSensitivity 0.5) (<= PatientDemographicsSensitivity 0.6))
      )
    )
  )
)

;; RadiologyImages
(declare-fun RadiologyImages_Read () Bool)
(declare-fun RadiologyImages_Write () Bool)
(declare-fun RadiologyImages_Update () Bool)
(declare-fun RadiologyImages_Delete () Bool)
(declare-fun RadiologyImagesSensitivity () Real)

(assert
  (ite RadiologyImages_Delete
    (and (>= RadiologyImagesSensitivity 0.85) (<= RadiologyImagesSensitivity 0.9))
    (ite RadiologyImages_Update
      (and (>= RadiologyImagesSensitivity 0.8) (<= RadiologyImagesSensitivity 0.85))
      (ite RadiologyImages_Write
        (and (>= RadiologyImagesSensitivity 0.77) (<= RadiologyImagesSensitivity 0.8))
        (and (>= RadiologyImagesSensitivity 0.75) (<= RadiologyImagesSensitivity 0.77))
      )
    )
  )
)

;; DischargeSummary
(declare-fun DischargeSummaries_Read () Bool)
(declare-fun DischargeSummaries_Write () Bool)
(declare-fun DischargeSummaries_Update () Bool)
(declare-fun DischargeSummaries_Delete () Bool)
(declare-fun DischargeSummariesSensitivity () Real)

(assert
  (ite DischargeSummaries_Delete
    (and (>= DischargeSummariesSensitivity 0.8) (<= DischargeSummariesSensitivity 0.83))
    (ite DischargeSummaries_Update
      (and (>= DischargeSummariesSensitivity 0.78) (<= DischargeSummariesSensitivity 0.83))
      (ite DischargeSummaries_Write
        (and (>= DischargeSummariesSensitivity 0.73) (<= DischargeSummariesSensitivity 0.78))
        (and (>= DischargeSummariesSensitivity 0.65) (<= DischargeSummariesSensitivity 0.73))
      )
    )
  )
)



;; PatientCommunications
(declare-fun PatientCommunications_Read () Bool)
(declare-fun PatientCommunications_Write () Bool)
(declare-fun PatientCommunications_Update () Bool)
(declare-fun PatientCommunications_Delete () Bool)
(declare-fun PatientCommunicationsSensitivity () Real)

(assert
  (ite PatientCommunications_Delete
    (and (>= PatientCommunicationsSensitivity 0.65) (<= PatientCommunicationsSensitivity 0.68))
    (ite PatientCommunications_Update
      (and (>= PatientCommunicationsSensitivity 0.61) (<= PatientCommunicationsSensitivity 0.65))
      (ite PatientCommunications_Write
        (and (>= PatientCommunicationsSensitivity 0.55) (<= PatientCommunicationsSensitivity 0.61))
        (and (>= PatientCommunicationsSensitivity 0.5) (<= PatientCommunicationsSensitivity 0.55))
      )
    )
  )
)



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


; =========================
; AssetPermGate for ALL assets
; =========================
(assert (AssetPermGate Diagnosis Diagnosis_Read Diagnosis_Write Diagnosis_Update Diagnosis_Delete))
(assert (AssetPermGate TreatmentPlan TreatmentPlan_Read TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete))
(assert (AssetPermGate LabResults LabResults_Read LabResults_Write LabResults_Update LabResults_Delete))
(assert (AssetPermGate TestReports TestReports_Read TestReports_Write TestReports_Update TestReports_Delete))
(assert (AssetPermGate PatientHistory PatientHistory_Read PatientHistory_Write PatientHistory_Update PatientHistory_Delete))
(assert (AssetPermGate PatientInteractions PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete))
(assert (AssetPermGate VisitSummaries VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete))
(assert (AssetPermGate ReferralNotes ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete))
(assert (AssetPermGate EncounterNotes EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete))
(assert (AssetPermGate PatientRecords PatientRecords_Read PatientRecords_Write PatientRecords_Update PatientRecords_Delete))
(assert (AssetPermGate PatientDemographics PatientDemographics_Read PatientDemographics_Write PatientDemographics_Update PatientDemographics_Delete))
(assert (AssetPermGate RadiologyImages RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete))
(assert (AssetPermGate DischargeSummaries DischargeSummaries_Read DischargeSummaries_Write DischargeSummaries_Update DischargeSummaries_Delete))
(assert (AssetPermGate PatientCommunications PatientCommunications_Read PatientCommunications_Write PatientCommunications_Update PatientCommunications_Delete))


;; Apply the hierarchy to all assets
(assert (HierarchicalPermissions Diagnosis_Delete Diagnosis_Update Diagnosis_Write Diagnosis_Read))
(assert (HierarchicalPermissions TreatmentPlan_Delete TreatmentPlan_Update TreatmentPlan_Write TreatmentPlan_Read))
(assert (HierarchicalPermissions LabResults_Delete LabResults_Update LabResults_Write LabResults_Read))
(assert (HierarchicalPermissions TestReports_Delete TestReports_Update TestReports_Write TestReports_Read))
(assert (HierarchicalPermissions PatientHistory_Delete PatientHistory_Update PatientHistory_Write PatientHistory_Read))
(assert (HierarchicalPermissions PatientInteractions_Delete PatientInteractions_Update PatientInteractions_Write PatientInteractions_Read))
(assert (HierarchicalPermissions VisitSummaries_Delete VisitSummaries_Update VisitSummaries_Write VisitSummaries_Read))
(assert (HierarchicalPermissions ReferralNotes_Delete ReferralNotes_Update ReferralNotes_Write ReferralNotes_Read))
(assert (HierarchicalPermissions EncounterNotes_Delete EncounterNotes_Update EncounterNotes_Write EncounterNotes_Read))
(assert (HierarchicalPermissions PatientRecords_Delete PatientRecords_Update PatientRecords_Write PatientRecords_Read))
(assert (HierarchicalPermissions PatientDemographics_Delete PatientDemographics_Update PatientDemographics_Write PatientDemographics_Read))
(assert (HierarchicalPermissions RadiologyImages_Delete RadiologyImages_Update RadiologyImages_Write RadiologyImages_Read))
(assert (HierarchicalPermissions DischargeSummaries_Delete DischargeSummaries_Update DischargeSummaries_Write DischargeSummaries_Read))
(assert (HierarchicalPermissions PatientCommunications_Delete PatientCommunications_Update PatientCommunications_Write PatientCommunications_Read))

(assert (Downclose Diagnosis_Delete Diagnosis_Update Diagnosis_Write Diagnosis_Read))
(assert (Downclose TreatmentPlan_Delete TreatmentPlan_Update TreatmentPlan_Write TreatmentPlan_Read))
(assert (Downclose LabResults_Delete LabResults_Update LabResults_Write LabResults_Read))
(assert (Downclose TestReports_Delete TestReports_Update TestReports_Write TestReports_Read))
(assert (Downclose PatientHistory_Delete PatientHistory_Update PatientHistory_Write PatientHistory_Read))
(assert (Downclose PatientInteractions_Delete PatientInteractions_Update PatientInteractions_Write PatientInteractions_Read))
(assert (Downclose VisitSummaries_Delete VisitSummaries_Update VisitSummaries_Write VisitSummaries_Read))
(assert (Downclose ReferralNotes_Delete ReferralNotes_Update ReferralNotes_Write ReferralNotes_Read))
(assert (Downclose EncounterNotes_Delete EncounterNotes_Update EncounterNotes_Write EncounterNotes_Read))
(assert (Downclose PatientRecords_Delete PatientRecords_Update PatientRecords_Write PatientRecords_Read))
(assert (Downclose PatientDemographics_Delete PatientDemographics_Update PatientDemographics_Write PatientDemographics_Read))
(assert (Downclose RadiologyImages_Delete RadiologyImages_Update RadiologyImages_Write RadiologyImages_Read))
(assert (Downclose DischargeSummaries_Delete DischargeSummaries_Update DischargeSummaries_Write DischargeSummaries_Read))
(assert (Downclose PatientCommunications_Delete PatientCommunications_Update PatientCommunications_Write PatientCommunications_Read))


;; -------------------- MINIMUM PERMISSIONS (Scenario 2) --------------------

;; helper functions (reuse if already defined)
(define-fun NeedsRead  ((op Real) (p Bool)) Bool (=> (> op 0.0) p))
(define-fun NeedsWrite ((op Real) (p Bool)) Bool (=> (> op 0.0) p))
(define-fun NeedsUpdate ((op Real) (p Bool)) Bool (=> (> op 0.0) p))

;; AccessPatientProfile ⇒ Read PatientRecords, PatientDemographics, PatientHistory
(assert (NeedsRead AccessPatientProfile PatientRecords_Read))
(assert (NeedsRead AccessPatientProfile PatientDemographics_Read))
(assert (NeedsRead AccessPatientProfile PatientHistory_Read))

;; ViewRadiologyImages ⇒ Read RadiologyImages, TestReports, PatientRecords
(assert (NeedsRead ViewRadiologyImages RadiologyImages_Read))
(assert (NeedsRead ViewRadiologyImages TestReports_Read))
(assert (NeedsRead ViewRadiologyImages PatientRecords_Read))

;; ManageAppointment ⇒ Read PatientRecords, Write VisitSummaries
(assert (NeedsRead ManageAppointment PatientRecords_Read))
(assert (NeedsWrite ManageAppointment VisitSummaries_Write))

;; PrintMedicalReport ⇒ Read Diagnosis, TreatmentPlan, LabResults, PatientRecords, DischargeSummaries, PatientCommunications
(assert (NeedsRead PrintMedicalReport Diagnosis_Read))
(assert (NeedsRead PrintMedicalReport TreatmentPlan_Read))
(assert (NeedsRead PrintMedicalReport LabResults_Read))
(assert (NeedsRead PrintMedicalReport PatientRecords_Read))
(assert (NeedsRead PrintMedicalReport DischargeSummaries_Read))
(assert (NeedsRead PrintMedicalReport PatientCommunications_Read))

;; AdjustCarePlan ⇒ Update TreatmentPlan, Read Diagnosis, Read PatientRecords
(assert (NeedsUpdate AdjustCarePlan TreatmentPlan_Update))
(assert (NeedsRead AdjustCarePlan Diagnosis_Read))
(assert (NeedsRead AdjustCarePlan PatientRecords_Read))

;; ApproveDischargeSummary ⇒ Update DischargeSummaries, Read VisitSummaries, Read TreatmentPlan
(assert (NeedsUpdate ApproveDischargeSummary DischargeSummaries_Update))
(assert (NeedsRead ApproveDischargeSummary VisitSummaries_Read))
(assert (NeedsRead ApproveDischargeSummary TreatmentPlan_Read))

;; OrderLabTest ⇒ Write LabResults, Read TestReports, Read PatientRecords
(assert (NeedsWrite OrderLabTest LabResults_Write))
(assert (NeedsRead OrderLabTest TestReports_Read))
(assert (NeedsRead OrderLabTest PatientRecords_Read))

;; RequestConsultation ⇒ Write ReferralNotes, Write EncounterNotes, Read PatientRecords
(assert (NeedsWrite RequestConsultation ReferralNotes_Write))
(assert (NeedsWrite RequestConsultation EncounterNotes_Write))
(assert (NeedsRead RequestConsultation PatientRecords_Read))

;; CommunicateWithPatient ⇒ Write PatientCommunications, Read PatientInteractions
(assert (NeedsWrite CommunicateWithPatient PatientCommunications_Write))
(assert (NeedsRead CommunicateWithPatient PatientInteractions_Read))

;; -------------------------


;; AssetValue aggregation
;; -------------------------
(declare-fun AssetValue () Real)
(assert (and (>= AssetValue 0) (<= AssetValue 1)))

(assert (= AssetValue
  (+ (* Diagnosis DiagnosisSensitivity 0.1)
     (* TreatmentPlan TreatmentPlanSensitivity 0.1)
     (* LabResults LabResultsSensitivity 0.08)
     (* TestReports TestReportsSensitivity 0.06)
     (* PatientHistory PatientHistorySensitivity 0.1)
     (* PatientInteractions PatientInteractionsSensitivity 0.05)
     (* VisitSummaries VisitSummariesSensitivity 0.07)
     (* ReferralNotes ReferralNotesSensitivity 0.07)
     (* EncounterNotes EncounterNotesSensitivity 0.05)
     (* PatientRecords PatientRecordsSensitivity 0.12)
     (* PatientDemographics PatientDemographicsSensitivity 0.05)
     (* RadiologyImages RadiologyImagesSensitivity 0.06)
     (* DischargeSummaries DischargeSummariesSensitivity 0.06)
     (* PatientCommunications PatientCommunicationsSensitivity 0.03))
))

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

;;---------- The Context Impact On Attacks Likelihood

;; Unsecured WiFi can be easily intercepted by attackers. Replay attacks are likely due to token reuse, 
;; and session hijacking is highly likely due to lack of encryption or protection.
;; Unfamiliar Location implies deviation from normal patterns, suggesting a potential attacker.
;; Moderate to high impersonation and session hijacking risk due to context anomaly.
(assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.7 0.2)))
(assert (= PImpersAttack  (ite (> Location 0)      0.7 0.2)))
(assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.9 0.2)))


;; Sensitivity Analysis
; --- S2 Sensitivity: Replay (−2) 0.5 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.5 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.7 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.6 0.2)))

; ; --- S2 Sensitivity: Replay (−1) 0.6 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.6 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.7 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.6 0.2)))



; ; --- S2 Sensitivity: Replay (+1) 0.8 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.8 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.7 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.6 0.2)))

; ; --- S2 Sensitivity: Replay (+2) 0.9 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.9 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.7 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.6 0.2)))



; ; --- S2 Sensitivity: Impersonation (−2) 0.5 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.7 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.5 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.6 0.2)))

; --- S2 Sensitivity: Impersonation (−1) 0.6 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.7 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.6 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.6 0.2)))



; ; --- S2 Sensitivity: Impersonation (+1) 0.8 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.7 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.8 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.6 0.2)))

; --- S2 Sensitivity: Impersonation (+2) 0.9 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.7 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.9 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.6 0.2)))




; --- S2 Sensitivity: Session (−2) 0.4 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.7 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.7 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.4 0.2)))

; ; --- S2 Sensitivity: Session (−1) 0.5 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.7 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.7 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.5 0.2)))



; ; --- S2 Sensitivity: Session (+1) 0.7 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.7 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.7 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.7 0.2)))

; ; --- S2 Sensitivity: Session (+2) 0.8 ---
; (assert (= PReplayAttack  (ite (> UnsecuredWiFi 0) 0.7 0.2)))
; (assert (= PImpersAttack  (ite (> Location 0)      0.7 0.2)))
; (assert (= PSessionAttack (ite (> UnsecuredWiFi 0) 0.8 0.2)))





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
  (+ (* (_tight Diagnosis_Delete Diagnosis_Update Diagnosis_Write Diagnosis_Read)                             DiagnosisSensitivity Diagnosis)
     (* (_tight TreatmentPlan_Delete TreatmentPlan_Update TreatmentPlan_Write TreatmentPlan_Read)             TreatmentPlanSensitivity TreatmentPlan)
     (* (_tight LabResults_Delete LabResults_Update LabResults_Write LabResults_Read)                         LabResultsSensitivity LabResults)
     (* (_tight TestReports_Delete TestReports_Update TestReports_Write TestReports_Read)                     TestReportsSensitivity TestReports)
     (* (_tight PatientHistory_Delete PatientHistory_Update PatientHistory_Write PatientHistory_Read)          PatientHistorySensitivity PatientHistory)
     (* (_tight PatientInteractions_Delete PatientInteractions_Update PatientInteractions_Write PatientInteractions_Read) PatientInteractionsSensitivity PatientInteractions)
     (* (_tight VisitSummaries_Delete VisitSummaries_Update VisitSummaries_Write VisitSummaries_Read)         VisitSummariesSensitivity VisitSummaries)
     (* (_tight ReferralNotes_Delete ReferralNotes_Update ReferralNotes_Write ReferralNotes_Read)             ReferralNotesSensitivity ReferralNotes)
     (* (_tight EncounterNotes_Delete EncounterNotes_Update EncounterNotes_Write EncounterNotes_Read)         EncounterNotesSensitivity EncounterNotes)
     (* (_tight PatientRecords_Delete PatientRecords_Update PatientRecords_Write PatientRecords_Read)         PatientRecordsSensitivity PatientRecords)
     (* (_tight PatientDemographics_Delete PatientDemographics_Update PatientDemographics_Write PatientDemographics_Read)         PatientDemographicsSensitivity PatientDemographics)
     (* (_tight RadiologyImages_Delete RadiologyImages_Update RadiologyImages_Write RadiologyImages_Read)         RadiologyImagesSensitivity RadiologyImages)
     (* (_tight DischargeSummaries_Delete DischargeSummaries_Update DischargeSummaries_Write DischargeSummaries_Read)         DischargeSummariesSensitivity DischargeSummaries)
     (* (_tight PatientCommunications_Delete PatientCommunications_Update PatientCommunications_Write PatientCommunications_Read)         PatientCommunicationsSensitivity PatientCommunications)
  )))

(declare-fun PermPenalty () Real)
(assert (= PermPenalty (_clamp01 (/ PermPenaltyN 14))))

(declare-fun OpDisabledPenalty () Real)
(assert (= OpDisabledPenalty
  (+ (* 1.0 (- 1.0 AccessPatientProfile))  ;; Must
     (* 1.0 (- 1.0 OrderLabTest))            ;; Must
     (* 1.0 (- 1.0 AdjustCarePlan))            ;; Must
     (* 0.7 (- 1.0 ApproveDischargeSummary))                ;; Nice
     (* 0.7 (- 1.0 RequestConsultation))                ;; Nice
     (* 0.7 (- 1.0 CommunicateWithPatient))             ;; Nice
     (* 0.4 (- 1.0 ViewRadiologyImages))          ;; Optional
     (* 0.4 (- 1.0 ManageAppointment))           ;; Optional
     (* 0.4 (- 1.0 PrintMedicalReport))           ;; Optional
  )))

(declare-fun OpDisabledPenaltyN () Real)
(assert (= OpDisabledPenaltyN (_clamp01 (/ OpDisabledPenalty 6.3))))

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
(assert (= Fingerprint 0))
(assert (= TwoFactor 0))
(assert (= Location 1))
(assert (= Emergency 1))
(assert (= UnsecuredWiFi 1))
(assert (= PoorLighting 0))

; --- Progressive RR upper bound  ---
(assert (< ResRisk 0.0018))
(assert (> ResRisk 0.0))
; --- BLOCKING CLAUSES (global enumeration) ---
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 1.0)) (not (= RequestConsultation 1.0)) (not (= CommunicateWithPatient 1.0)) (not (= ViewRadiologyImages 1.0)) (not (= ManageAppointment 0.0)) (not (= PrintMedicalReport 1.0)) (not Diagnosis_Read) (not Diagnosis_Write) (not Diagnosis_Update) (not Diagnosis_Delete) (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) TreatmentPlan_Delete (not LabResults_Read) (not LabResults_Write) (not LabResults_Update) (not LabResults_Delete) (not TestReports_Read) (not TestReports_Write) (not TestReports_Update) (not TestReports_Delete) (not PatientHistory_Read) (not PatientHistory_Write) (not PatientHistory_Update) (not PatientHistory_Delete) (not PatientInteractions_Read) (not PatientInteractions_Write) (not PatientInteractions_Update) (not PatientInteractions_Delete) (not VisitSummaries_Read) (not VisitSummaries_Write) (not VisitSummaries_Update) (not VisitSummaries_Delete) (not ReferralNotes_Read) (not ReferralNotes_Write) ReferralNotes_Update ReferralNotes_Delete (not EncounterNotes_Read) (not EncounterNotes_Write) (not EncounterNotes_Update) (not EncounterNotes_Delete) (not PatientRecords_Read) (not PatientRecords_Write) (not PatientRecords_Update) (not PatientRecords_Delete) (not PatientDemographics_Read) (not PatientDemographics_Write) (not PatientDemographics_Update) (not PatientDemographics_Delete) (not RadiologyImages_Read) (not RadiologyImages_Write) RadiologyImages_Update RadiologyImages_Delete (not DischargeSummaries_Read) (not DischargeSummaries_Write) (not DischargeSummaries_Update) (not DischargeSummaries_Delete) (not PatientCommunications_Read) (not PatientCommunications_Write) (not PatientCommunications_Update) PatientCommunications_Delete))
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 1.0)) (not (= RequestConsultation 1.0)) (not (= CommunicateWithPatient 1.0)) (not (= ViewRadiologyImages 0.0)) (not (= ManageAppointment 0.0)) (not (= PrintMedicalReport 1.0)) (not Diagnosis_Read) (not Diagnosis_Write) (not Diagnosis_Update) (not Diagnosis_Delete) (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) (not TreatmentPlan_Delete) (not LabResults_Read) (not LabResults_Write) (not LabResults_Update) (not LabResults_Delete) (not TestReports_Read) (not TestReports_Write) TestReports_Update TestReports_Delete (not PatientHistory_Read) (not PatientHistory_Write) (not PatientHistory_Update) (not PatientHistory_Delete) (not PatientInteractions_Read) (not PatientInteractions_Write) (not PatientInteractions_Update) (not PatientInteractions_Delete) (not VisitSummaries_Read) (not VisitSummaries_Write) VisitSummaries_Update VisitSummaries_Delete (not ReferralNotes_Read) (not ReferralNotes_Write) ReferralNotes_Update ReferralNotes_Delete (not EncounterNotes_Read) (not EncounterNotes_Write) (not EncounterNotes_Update) (not EncounterNotes_Delete) (not PatientRecords_Read) PatientRecords_Write PatientRecords_Update PatientRecords_Delete (not PatientDemographics_Read) (not PatientDemographics_Write) (not PatientDemographics_Update) (not PatientDemographics_Delete) RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete (not DischargeSummaries_Read) (not DischargeSummaries_Write) (not DischargeSummaries_Update) DischargeSummaries_Delete (not PatientCommunications_Read) (not PatientCommunications_Write) (not PatientCommunications_Update) (not PatientCommunications_Delete)))
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 1.0)) (not (= RequestConsultation 1.0)) (not (= CommunicateWithPatient 1.0)) (not (= ViewRadiologyImages 1.0)) (not (= ManageAppointment 1.0)) (not (= PrintMedicalReport 0.0)) (not Diagnosis_Read) Diagnosis_Write Diagnosis_Update Diagnosis_Delete (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) (not TreatmentPlan_Delete) (not LabResults_Read) (not LabResults_Write) LabResults_Update LabResults_Delete (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not PatientHistory_Read) PatientHistory_Write PatientHistory_Update PatientHistory_Delete (not PatientInteractions_Read) PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete (not VisitSummaries_Read) (not VisitSummaries_Write) (not VisitSummaries_Update) (not VisitSummaries_Delete) (not ReferralNotes_Read) (not ReferralNotes_Write) ReferralNotes_Update ReferralNotes_Delete (not EncounterNotes_Read) (not EncounterNotes_Write) (not EncounterNotes_Update) (not EncounterNotes_Delete) (not PatientRecords_Read) PatientRecords_Write PatientRecords_Update PatientRecords_Delete (not PatientDemographics_Read) (not PatientDemographics_Write) (not PatientDemographics_Update) (not PatientDemographics_Delete) (not RadiologyImages_Read) (not RadiologyImages_Write) RadiologyImages_Update RadiologyImages_Delete (not DischargeSummaries_Read) (not DischargeSummaries_Write) (not DischargeSummaries_Update) (not DischargeSummaries_Delete) (not PatientCommunications_Read) (not PatientCommunications_Write) PatientCommunications_Update PatientCommunications_Delete))
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 1.0)) (not (= RequestConsultation 1.0)) (not (= CommunicateWithPatient 0.0)) (not (= ViewRadiologyImages 0.0)) (not (= ManageAppointment 0.0)) (not (= PrintMedicalReport 0.0)) (not Diagnosis_Read) (not Diagnosis_Write) (not Diagnosis_Update) (not Diagnosis_Delete) (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) (not TreatmentPlan_Delete) (not LabResults_Read) (not LabResults_Write) LabResults_Update LabResults_Delete (not TestReports_Read) (not TestReports_Write) (not TestReports_Update) (not TestReports_Delete) (not PatientHistory_Read) PatientHistory_Write PatientHistory_Update PatientHistory_Delete PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete (not VisitSummaries_Read) (not VisitSummaries_Write) (not VisitSummaries_Update) (not VisitSummaries_Delete) (not ReferralNotes_Read) (not ReferralNotes_Write) (not ReferralNotes_Update) (not ReferralNotes_Delete) (not EncounterNotes_Read) (not EncounterNotes_Write) EncounterNotes_Update EncounterNotes_Delete (not PatientRecords_Read) PatientRecords_Write PatientRecords_Update PatientRecords_Delete (not PatientDemographics_Read) (not PatientDemographics_Write) (not PatientDemographics_Update) (not PatientDemographics_Delete) RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete (not DischargeSummaries_Read) (not DischargeSummaries_Write) (not DischargeSummaries_Update) DischargeSummaries_Delete PatientCommunications_Read PatientCommunications_Write PatientCommunications_Update PatientCommunications_Delete))
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 1.0)) (not (= RequestConsultation 1.0)) (not (= CommunicateWithPatient 1.0)) (not (= ViewRadiologyImages 0.0)) (not (= ManageAppointment 0.0)) (not (= PrintMedicalReport 1.0)) (not Diagnosis_Read) Diagnosis_Write Diagnosis_Update Diagnosis_Delete (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) TreatmentPlan_Delete (not LabResults_Read) (not LabResults_Write) LabResults_Update LabResults_Delete (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not PatientHistory_Read) PatientHistory_Write PatientHistory_Update PatientHistory_Delete (not PatientInteractions_Read) (not PatientInteractions_Write) (not PatientInteractions_Update) (not PatientInteractions_Delete) (not VisitSummaries_Read) VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete (not ReferralNotes_Read) (not ReferralNotes_Write) ReferralNotes_Update ReferralNotes_Delete (not EncounterNotes_Read) (not EncounterNotes_Write) EncounterNotes_Update EncounterNotes_Delete (not PatientRecords_Read) (not PatientRecords_Write) (not PatientRecords_Update) (not PatientRecords_Delete) (not PatientDemographics_Read) PatientDemographics_Write PatientDemographics_Update PatientDemographics_Delete RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete (not DischargeSummaries_Read) (not DischargeSummaries_Write) (not DischargeSummaries_Update) DischargeSummaries_Delete (not PatientCommunications_Read) (not PatientCommunications_Write) (not PatientCommunications_Update) (not PatientCommunications_Delete)))
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 0.0)) (not (= RequestConsultation 1.0)) (not (= CommunicateWithPatient 1.0)) (not (= ViewRadiologyImages 0.0)) (not (= ManageAppointment 0.0)) (not (= PrintMedicalReport 0.0)) (not Diagnosis_Read) Diagnosis_Write Diagnosis_Update Diagnosis_Delete (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) TreatmentPlan_Delete (not LabResults_Read) (not LabResults_Write) LabResults_Update LabResults_Delete (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not PatientHistory_Read) (not PatientHistory_Write) (not PatientHistory_Update) PatientHistory_Delete (not PatientInteractions_Read) (not PatientInteractions_Write) (not PatientInteractions_Update) PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete (not ReferralNotes_Read) (not ReferralNotes_Write) ReferralNotes_Update ReferralNotes_Delete (not EncounterNotes_Read) (not EncounterNotes_Write) EncounterNotes_Update EncounterNotes_Delete (not PatientRecords_Read) PatientRecords_Write PatientRecords_Update PatientRecords_Delete (not PatientDemographics_Read) PatientDemographics_Write PatientDemographics_Update PatientDemographics_Delete RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete DischargeSummaries_Read DischargeSummaries_Write DischargeSummaries_Update DischargeSummaries_Delete (not PatientCommunications_Read) (not PatientCommunications_Write) PatientCommunications_Update PatientCommunications_Delete))
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 0.0)) (not (= RequestConsultation 1.0)) (not (= CommunicateWithPatient 1.0)) (not (= ViewRadiologyImages 0.0)) (not (= ManageAppointment 0.0)) (not (= PrintMedicalReport 0.0)) (not Diagnosis_Read) (not Diagnosis_Write) (not Diagnosis_Update) (not Diagnosis_Delete) (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) TreatmentPlan_Delete (not LabResults_Read) (not LabResults_Write) (not LabResults_Update) LabResults_Delete (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not PatientHistory_Read) (not PatientHistory_Write) (not PatientHistory_Update) (not PatientHistory_Delete) (not PatientInteractions_Read) PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete (not ReferralNotes_Read) (not ReferralNotes_Write) (not ReferralNotes_Update) (not ReferralNotes_Delete) (not EncounterNotes_Read) (not EncounterNotes_Write) EncounterNotes_Update EncounterNotes_Delete (not PatientRecords_Read) (not PatientRecords_Write) (not PatientRecords_Update) (not PatientRecords_Delete) (not PatientDemographics_Read) PatientDemographics_Write PatientDemographics_Update PatientDemographics_Delete RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete DischargeSummaries_Read DischargeSummaries_Write DischargeSummaries_Update DischargeSummaries_Delete (not PatientCommunications_Read) (not PatientCommunications_Write) (not PatientCommunications_Update) (not PatientCommunications_Delete)))
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 0.0)) (not (= RequestConsultation 1.0)) (not (= CommunicateWithPatient 1.0)) (not (= ViewRadiologyImages 0.0)) (not (= ManageAppointment 0.0)) (not (= PrintMedicalReport 0.0)) (not Diagnosis_Read) (not Diagnosis_Write) Diagnosis_Update Diagnosis_Delete (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) TreatmentPlan_Delete (not LabResults_Read) (not LabResults_Write) LabResults_Update LabResults_Delete (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not PatientHistory_Read) PatientHistory_Write PatientHistory_Update PatientHistory_Delete (not PatientInteractions_Read) (not PatientInteractions_Write) (not PatientInteractions_Update) (not PatientInteractions_Delete) VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete (not ReferralNotes_Read) (not ReferralNotes_Write) (not ReferralNotes_Update) ReferralNotes_Delete (not EncounterNotes_Read) (not EncounterNotes_Write) EncounterNotes_Update EncounterNotes_Delete (not PatientRecords_Read) PatientRecords_Write PatientRecords_Update PatientRecords_Delete (not PatientDemographics_Read) PatientDemographics_Write PatientDemographics_Update PatientDemographics_Delete RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete DischargeSummaries_Read DischargeSummaries_Write DischargeSummaries_Update DischargeSummaries_Delete (not PatientCommunications_Read) (not PatientCommunications_Write) (not PatientCommunications_Update) (not PatientCommunications_Delete)))
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 1.0)) (not (= RequestConsultation 0.0)) (not (= CommunicateWithPatient 0.0)) (not (= ViewRadiologyImages 0.0)) (not (= ManageAppointment 0.0)) (not (= PrintMedicalReport 0.0)) (not Diagnosis_Read) Diagnosis_Write Diagnosis_Update Diagnosis_Delete (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) TreatmentPlan_Delete (not LabResults_Read) (not LabResults_Write) LabResults_Update LabResults_Delete (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not PatientHistory_Read) PatientHistory_Write PatientHistory_Update PatientHistory_Delete PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete (not VisitSummaries_Read) (not VisitSummaries_Write) VisitSummaries_Update VisitSummaries_Delete ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete (not PatientRecords_Read) (not PatientRecords_Write) (not PatientRecords_Update) (not PatientRecords_Delete) (not PatientDemographics_Read) (not PatientDemographics_Write) (not PatientDemographics_Update) (not PatientDemographics_Delete) RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete (not DischargeSummaries_Read) (not DischargeSummaries_Write) (not DischargeSummaries_Update) DischargeSummaries_Delete PatientCommunications_Read PatientCommunications_Write PatientCommunications_Update PatientCommunications_Delete))
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 0.0)) (not (= RequestConsultation 0.0)) (not (= CommunicateWithPatient 0.0)) (not (= ViewRadiologyImages 0.0)) (not (= ManageAppointment 0.0)) (not (= PrintMedicalReport 0.0)) (not Diagnosis_Read) (not Diagnosis_Write) (not Diagnosis_Update) Diagnosis_Delete (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) (not TreatmentPlan_Delete) (not LabResults_Read) (not LabResults_Write) (not LabResults_Update) (not LabResults_Delete) (not TestReports_Read) (not TestReports_Write) (not TestReports_Update) (not TestReports_Delete) (not PatientHistory_Read) (not PatientHistory_Write) (not PatientHistory_Update) (not PatientHistory_Delete) PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete (not PatientRecords_Read) (not PatientRecords_Write) (not PatientRecords_Update) (not PatientRecords_Delete) (not PatientDemographics_Read) (not PatientDemographics_Write) (not PatientDemographics_Update) (not PatientDemographics_Delete) RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete DischargeSummaries_Read DischargeSummaries_Write DischargeSummaries_Update DischargeSummaries_Delete PatientCommunications_Read PatientCommunications_Write PatientCommunications_Update PatientCommunications_Delete))
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 0.0)) (not (= RequestConsultation 0.0)) (not (= CommunicateWithPatient 0.0)) (not (= ViewRadiologyImages 0.0)) (not (= ManageAppointment 0.0)) (not (= PrintMedicalReport 0.0)) (not Diagnosis_Read) (not Diagnosis_Write) (not Diagnosis_Update) Diagnosis_Delete (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) (not TreatmentPlan_Delete) (not LabResults_Read) (not LabResults_Write) (not LabResults_Update) (not LabResults_Delete) (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not PatientHistory_Read) (not PatientHistory_Write) (not PatientHistory_Update) (not PatientHistory_Delete) PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete (not PatientRecords_Read) (not PatientRecords_Write) (not PatientRecords_Update) (not PatientRecords_Delete) (not PatientDemographics_Read) PatientDemographics_Write PatientDemographics_Update PatientDemographics_Delete RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete DischargeSummaries_Read DischargeSummaries_Write DischargeSummaries_Update DischargeSummaries_Delete PatientCommunications_Read PatientCommunications_Write PatientCommunications_Update PatientCommunications_Delete))
(assert (or (not (= AccessPatientProfile 1.0)) (not (= OrderLabTest 1.0)) (not (= AdjustCarePlan 1.0)) (not (= ApproveDischargeSummary 0.0)) (not (= RequestConsultation 0.0)) (not (= CommunicateWithPatient 0.0)) (not (= ViewRadiologyImages 0.0)) (not (= ManageAppointment 0.0)) (not (= PrintMedicalReport 0.0)) (not Diagnosis_Read) (not Diagnosis_Write) (not Diagnosis_Update) (not Diagnosis_Delete) (not TreatmentPlan_Read) (not TreatmentPlan_Write) (not TreatmentPlan_Update) (not TreatmentPlan_Delete) (not LabResults_Read) (not LabResults_Write) (not LabResults_Update) (not LabResults_Delete) (not TestReports_Read) TestReports_Write TestReports_Update TestReports_Delete (not PatientHistory_Read) PatientHistory_Write PatientHistory_Update PatientHistory_Delete PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete (not PatientRecords_Read) PatientRecords_Write PatientRecords_Update PatientRecords_Delete (not PatientDemographics_Read) PatientDemographics_Write PatientDemographics_Update PatientDemographics_Delete RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete DischargeSummaries_Read DischargeSummaries_Write DischargeSummaries_Update DischargeSummaries_Delete PatientCommunications_Read PatientCommunications_Write PatientCommunications_Update PatientCommunications_Delete))

(check-sat)
(get-value (ResRisk AssetValue AuthorizationPenalty PermPenalty AccessPatientProfile OrderLabTest AdjustCarePlan ApproveDischargeSummary RequestConsultation CommunicateWithPatient ViewRadiologyImages ManageAppointment PrintMedicalReport Diagnosis_Read Diagnosis_Write Diagnosis_Update Diagnosis_Delete TreatmentPlan_Read TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete LabResults_Read LabResults_Write LabResults_Update LabResults_Delete TestReports_Read TestReports_Write TestReports_Update TestReports_Delete PatientHistory_Read PatientHistory_Write PatientHistory_Update PatientHistory_Delete PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete PatientRecords_Read PatientRecords_Write PatientRecords_Update PatientRecords_Delete PatientDemographics_Read PatientDemographics_Write PatientDemographics_Update PatientDemographics_Delete RadiologyImages_Read RadiologyImages_Write RadiologyImages_Update RadiologyImages_Delete DischargeSummaries_Read DischargeSummaries_Write DischargeSummaries_Update DischargeSummaries_Delete PatientCommunications_Read PatientCommunications_Write PatientCommunications_Update PatientCommunications_Delete Diagnosis TreatmentPlan LabResults TestReports PatientHistory PatientInteractions VisitSummaries ReferralNotes EncounterNotes PatientRecords PatientDemographics RadiologyImages DischargeSummaries PatientCommunications PRiskPImpersAttack PRiskReplayAttack PRiskSessionAttack TotalRisk PImpersAttack PReplayAttack PSessionAttack FPImpersAttack FPReplayAttack FPSessionAttack))
