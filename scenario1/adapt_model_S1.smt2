;;Fuzzy Goals
(declare-fun AdapAuthR () Real)
(declare-fun Security () Real)
(declare-fun Usability () Real)
(declare-fun Performance() Real)

;;AdapAuthR = Security && Usability && Performance 
(assert (and (<= AdapAuthR 
             (ite (<= Security Usability) 
                  (ite (<= Security Performance) Security  Performance) 
                  (ite (<= Usability Performance) Usability Performance)))))

(declare-fun AvgPerformance() Real)
(declare-fun AVGPerforSum() Real)
(declare-fun  PerforSum () Real)

(assert (and (<= 0 AdapAuthR ) (<= AdapAuthR 1)))
(assert (and (<= 0 Security ) (<= Security 1)))
(assert (and (<= 0 Usability) (<= Usability 1))) 
(assert (and (<= 0 Performance) (<= Performance 1)))
(assert (and (<= 0 AvgPerformance) (<= AvgPerformance 1)))
(assert (and (<= 0 AVGPerforSum  ) (<= AVGPerforSum   1)))

;;Fuzzy Security Goals
(declare-fun  Authenticity() Real)
(declare-fun  Confidentiality () Real)
(declare-fun  Integrity () Real)

;;Security = Authenticity && Confidentiality && Integrity 
(assert (and (<= Security 
             (ite (<= Authenticity Confidentiality) 
                  (ite (<= Authenticity Integrity) Authenticity  Integrity) 
                  (ite (<= Confidentiality Integrity) Confidentiality Integrity)))))

(declare-fun  AvgAuthenticity() Real)
(declare-fun  AvgConfidentiality () Real)
(declare-fun  AvgIntegrity () Real)
(declare-fun  AuthentPriority () Real)
(declare-fun  ConfPriority  () Real)
(declare-fun  IntegPriority () Real)
(declare-fun  PerformancePriority () Real)

(declare-fun  SumInteg () Real)
(declare-fun  AVGSumInteg () Real)
(declare-fun  SumConf () Real)
(declare-fun  AVGSumConf () Real)
(declare-fun  SumAuth () Real)
(declare-fun  AVGSumAuth () Real)

;;Fuzzy Security Goals
(assert (and (<= 0 Authenticity) (<= Authenticity 1)))
(assert (and (<= 0 Confidentiality) (<= Confidentiality 1)))
(assert (and (<= 0 Integrity) (<= Integrity 1)))

(assert (and (<= 0 AvgAuthenticity) (<= AvgAuthenticity 1)))
(assert (and (<= 0 AvgConfidentiality) (<= AvgConfidentiality 1)))
(assert (and (<= 0 AvgIntegrity) (<= AvgIntegrity 1)))

(assert (and (<= 0 AuthentPriority) (<= AuthentPriority 1)))
(assert (and (<= 0 ConfPriority) (<= ConfPriority 1)))
(assert (and (<= 0 IntegPriority) (<= IntegPriority 1)))
(assert (and (<= 0 PerformancePriority) (<= PerformancePriority 1)))

(assert (and (<= 0 AVGSumInteg) (<= AVGSumInteg 1)))
(assert (and (<= 0 AVGSumAuth ) (<= AVGSumAuth  1)))
(assert (and (<= 0 AVGSumConf ) (<= AVGSumConf 1)))

;;Fuzzy usability Goals
(declare-fun  Effectiveness  () Real)
(declare-fun  Efficiency () Real)

(declare-fun  AvgEfficiency () Real)
(declare-fun  AvgEffectiveness  () Real)

(declare-fun  EffectPriority  () Real)
(declare-fun  EfficPriority () Real)
(declare-fun  EfficSum () Real)
(declare-fun  AVGEfficSum () Real)
(declare-fun  EffetSum () Real)
(declare-fun  AVGEffetSum () Real)

;;Fuzzy usability Goals
(assert (and (<= 0 Effectiveness) (<= Effectiveness 1)))
(assert (and (<= 0 Efficiency) (<= Efficiency 1)))

(assert (and (<= 0 AvgEffectiveness) (<= AvgEffectiveness 1)))
(assert (and (<= 0 AvgEfficiency) (<= AvgEfficiency 1)))

(assert (and (<= 0 EffectPriority) (<= EffectPriority 1)))
(assert (and (<= 0 EfficPriority) (<= EfficPriority 1)))

(assert (and (<= 0 AVGEfficSum  ) (<= AVGEfficSum  1)))
(assert (and (<= 0 AVGEffetSum  ) (<= AVGEffetSum  1)))

;;Utility
(declare-fun Utility () Real)
(assert (and (<= 0 Utility) (<= Utility 1)))
(declare-fun count() Real)  
	     
;;Usability = Effectiveness && Efficiency
(assert (and (<= Usability (ite (<= Effectiveness  Efficiency)  Effectiveness   Efficiency))))

;; The second scenario contextual factors
(declare-fun Location() Real)
(declare-fun InsecNetwork() Real)
(declare-fun UnusualTime() Real)

(declare-fun PoorLighting () Real)

;; 0 positive and 1 negative
(assert (or (=  Location 0) (= Location 1)))
(assert (or (=  InsecNetwork 0) (= InsecNetwork 1)))
(assert (or (=  UnusualTime 0) (= UnusualTime 1)))
(assert (or (=  PoorLighting 0) (= PoorLighting 1)))

;; Assets
(declare-fun Diagnosis() Real)
(declare-fun TreatmentPlan() Real)
(declare-fun LabResults() Real)
(declare-fun TestReports() Real)
(declare-fun NonControlledPrescriptions() Real)
(declare-fun PatientHistory() Real)
(declare-fun ControlledPrescriptions() Real)
(declare-fun PatientInteractions() Real)
(declare-fun VisitSummaries() Real)
(declare-fun ReferralNotes() Real)
(declare-fun EncounterNotes() Real)
(declare-fun PatientRecords() Real)

;; Asset value is >= 0 and <= 1
(assert (and (>=  Diagnosis 0) (<= Diagnosis 1)))
(assert (and (>=  TreatmentPlan 0) (<= TreatmentPlan 1)))
(assert (and (>=  LabResults 0) (<= LabResults 1)))
(assert (and (>=  TestReports 0) (<= TestReports 1)))
(assert (and (>=  NonControlledPrescriptions 0) (<= NonControlledPrescriptions 1)))
(assert (and (>=  PatientHistory 0) (<= PatientHistory 1)))
(assert (and (>=  ControlledPrescriptions 0) (<= ControlledPrescriptions 1)))
(assert (and (>=  PatientInteractions 0) (<= PatientInteractions 1)))
(assert (and (>=  VisitSummaries 0) (<= VisitSummaries 1)))
(assert (and (>=  ReferralNotes 0) (<= ReferralNotes 1)))
(assert (and (>=  EncounterNotes 0) (<= EncounterNotes 1)))
(assert (and (>=  PatientRecords 0) (<= PatientRecords 1)))

;;Operations 
(declare-fun DiagnoseMedicalConditions() Real)      ;; must have
(declare-fun ViewLabResults() Real)                 ;; must have
(declare-fun Controlled() Real)                     ;; nice to have
(declare-fun NonControlled() Real)                  ;; nice to have
(declare-fun AddEncounterNote() Real)               ;; optional
(declare-fun AddReferralNote() Real)                ;; optional
(declare-fun GenerateReports() Real)                ;; optional

;; Controlled VS Non-Controlled
(assert (or (=  DiagnoseMedicalConditions 0) (= DiagnoseMedicalConditions 1)))
(assert (or (=  ViewLabResults 0) (= ViewLabResults 1)))
(assert (or (=  Controlled 0) (= Controlled 1)))
(assert (or (=  NonControlled 0) (= NonControlled 1)))
(assert (or (=  AddEncounterNote 0) (= AddEncounterNote 1)))
(assert (or (=  AddReferralNote 0) (= AddReferralNote 1)))


(declare-fun CredType () Real)
(declare-fun SomeKnow() Real)
(declare-fun SomeHave () Real)
(declare-fun Signature () Real)
(declare-fun SomeAre() Real)
(declare-fun TwoFactor() Real)
(declare-fun PassStr() Real)
(declare-fun PinLeng() Real)
(declare-fun OtpLeng() Real)

(declare-fun Certificate () Real)
(declare-fun SmartCard () Real)
(declare-fun Token () Real)
(declare-fun PlateLicense () Real)
(declare-fun Face () Real)
(declare-fun Iris() Real)
(declare-fun Fingerprint() Real) 
(declare-fun SignCryp () Real)
(declare-fun GroupSign() Real)
(declare-fun RingSign () Real)

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

;; NonControlledPrescriptions
(declare-fun NonControlledPrescriptions_Read () Bool)
(declare-fun NonControlledPrescriptions_Write () Bool)
(declare-fun NonControlledPrescriptions_Update () Bool)
(declare-fun NonControlledPrescriptions_Delete () Bool)
(declare-fun NonControlledPrescriptionsSensitivity () Real)
(assert
  (ite NonControlledPrescriptions_Delete
    (and (>= NonControlledPrescriptionsSensitivity 0.67) (<= NonControlledPrescriptionsSensitivity 0.7))
    (ite NonControlledPrescriptions_Update
      (and (>= NonControlledPrescriptionsSensitivity 0.64) (<= NonControlledPrescriptionsSensitivity 0.67))
      (ite NonControlledPrescriptions_Write
        (and (>= NonControlledPrescriptionsSensitivity 0.6) (<= NonControlledPrescriptionsSensitivity 0.64))
        (and (>= NonControlledPrescriptionsSensitivity 0.5) (<= NonControlledPrescriptionsSensitivity 0.6))
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

;; ControlledPrescriptions
(declare-fun ControlledPrescriptions_Read () Bool)
(declare-fun ControlledPrescriptions_Write () Bool)
(declare-fun ControlledPrescriptions_Update () Bool)
(declare-fun ControlledPrescriptions_Delete () Bool)
(declare-fun ControlledPrescriptionsSensitivity () Real)
(assert
  (ite ControlledPrescriptions_Delete
    (and (>= ControlledPrescriptionsSensitivity 0.86) (<= ControlledPrescriptionsSensitivity 0.87))
    (ite ControlledPrescriptions_Update
      (and (>= ControlledPrescriptionsSensitivity 0.84) (<= ControlledPrescriptionsSensitivity 0.86))
      (ite ControlledPrescriptions_Write
        (and (>= ControlledPrescriptionsSensitivity 0.8) (<= ControlledPrescriptionsSensitivity 0.84))
        (and (>= ControlledPrescriptionsSensitivity 0.75) (<= ControlledPrescriptionsSensitivity 0.8))
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
    (and (>= PatientInteractionsSensitivity 0.86) (<= PatientInteractionsSensitivity 0.88))
    (ite PatientInteractions_Update
      (and (>= PatientInteractionsSensitivity 0.84) (<= PatientInteractionsSensitivity 0.86))
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
    (and (>= PatientRecordsSensitivity 0.97) (<= PatientRecordsSensitivity 1.0))
    (ite PatientRecords_Update
      (and (>= PatientRecordsSensitivity 0.94) (<= PatientRecordsSensitivity 0.97))
      (ite PatientRecords_Write
        (and (>= PatientRecordsSensitivity 0.92) (<= PatientRecordsSensitivity 0.94))
        (and (>= PatientRecordsSensitivity 0.9) (<= PatientRecordsSensitivity 0.92))
      )
    )
  )
)


;; setup the count variable
(assert (ite (> TwoFactor 0) (= count 2) (= count 1)))

;; CRISP Authentication Methods
(assert (or (=  Certificate 0) (= Certificate 1)))
(assert (or (=  SmartCard 0) (= SmartCard 1)))
(assert (or (=  Token 0) (= Token 1)))
(assert (or (=  Face 0) (= Face 1)))
(assert (or (=  Iris 0) (= Iris 1)))
(assert (or (=  Fingerprint 0) (= Fingerprint 1)))
(assert (or (=  SignCryp 0) (= SignCryp 1)))
(assert (or (=  GroupSign 0) (= GroupSign 1)))
(assert (or (=  RingSign 0) (= RingSign 1)))
(declare-fun CredRnew () Real)
(declare-fun CredRnewFactor () Real)

;; FUZZY Authentication Methods
(assert (and (< 0 CredType) (<= CredType 1)))
(assert (and (<= 0 SomeKnow) (<=  SomeKnow 1)))
(assert (and (<= 0 SomeHave) (<= SomeHave 1)))
(assert (and (<= 0 Signature) (<= Signature 1)))
(assert (and (<= 0 SomeAre) (<= SomeAre 1)))
(assert (and (<= 0 TwoFactor) (<= TwoFactor 1)))

;; PassStr= short(0.5) || medium (0.7) ||  Long(1.0)
(assert (or (=  PassStr 0.0) (=  PassStr 0.5) (= PassStr 0.7) (= PassStr 1.0)))

;; PinLeng= short(0.5) || medium (0.7) ||  Long(1.0)
(assert (or (=  PinLeng 0.0) (=  PinLeng 0.5) (= PinLeng 0.7) (= PinLeng 1.0)))
;; OtpLeng= short(0.5) || medium (0.7) ||  Long(1.0)
(assert (or (=  OtpLeng 0.0) (=  OtpLeng 0.5) (= OtpLeng 0.7) (= OtpLeng 1.0)))
 
;;;;;;;;;;;;;;;;;;;;Authentication methods;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;Assign value to CredType;;;;;;;;;;
(assert (= CredType (ite (> TwoFactor 0) TwoFactor
                          (ite (>= SomeKnow SomeHave)
                               (ite (>= SomeKnow  SomeAre) SomeKnow SomeAre) 
                               (ite (>= SomeHave SomeAre) SomeHave SomeAre)) 
)))

;;TwoFactor =  Select two from (SomeKnow, SomeHave, SomeAre)
(assert (ite (and (> SomeKnow 0) (> SomeHave 0))
             (and (> TwoFactor 0) (= SomeAre 0)) true))

(assert (ite (and (> SomeAre 0) (> SomeHave 0))
             (and (> TwoFactor 0) (= SomeKnow 0)) true))

(assert (ite (and (> SomeAre 0) (> SomeKnow 0))
             (and (> TwoFactor 0) (= SomeHave 0)) true))

(assert (ite (> TwoFactor 0) (or (and (> SomeAre 0) (> SomeHave 0) (= SomeKnow 0)) 
                                 (and (> SomeHave 0) (> SomeKnow 0) (= SomeAre 0)) 
                                 (and (> SomeKnow 0) (> SomeAre 0) (= SomeHave 0))) true))

;;TwoFactor value = Max(1, MAX(SomeKnow,SomeHave,SomeAre) + 0.2)
;;0.2 is the impact of the weakiest auth method
(assert (ite (and (> SomeKnow 0) (> SomeHave 0)) 
              (= TwoFactor (ite (> SomeKnow SomeHave) (ite (< SomeKnow 0.8) (+ SomeKnow 0.2) 1) (ite (< SomeHave 0.8) (+ SomeHave 0.2) 1)) ) true))

(assert (ite (and (> SomeAre 0) (> SomeHave 0)) 
              (= TwoFactor (ite (> SomeAre SomeHave) (ite (< SomeAre 0.8) (+ SomeAre 0.2) 1) (ite (< SomeHave 0.8) (+ SomeHave 0.2) 1)) ) true))

(assert (ite (and (> SomeAre 0) (> SomeKnow 0)) 
              (= TwoFactor (ite (> SomeAre SomeKnow) (ite (< SomeAre 0.8) (+ SomeAre 0.2) 1) (ite (< SomeKnow 0.8) (+ SomeKnow 0.2) 1)) ) true))

;;if TwoFactor = 0 then Choose one between (SomeKnow, SomeHave, SomeAre)
(assert (ite (and (= TwoFactor 0) (> SomeKnow 0)) (and (= SomeAre 0) (= SomeHave 0)) true))
(assert (ite (and (= TwoFactor 0) (> SomeHave 0)) (and (= SomeAre 0) (= SomeKnow 0)) true))
(assert (ite (and (= TwoFactor 0) (> SomeAre 0)) (and (= SomeKnow 0) (= SomeHave 0)) true))

;;SomeKnow = MAX (PinLeng,PassStr,OtpLeng)
(assert (= SomeKnow (ite (>= PinLeng PassStr)
                    (ite (>= PinLeng OtpLeng) PinLeng OtpLeng )
                    (ite (>= PassStr OtpLeng) PassStr OtpLeng ))))

;; Choose only one from (PinLeng,PassStr,OtpLeng)
(assert (ite (> PinLeng 0) (and (= PassStr 0) (= OtpLeng 0)) true))
(assert (ite (> PassStr 0) (and (= PinLeng 0) (= OtpLeng 0)) true))
(assert (ite (> OtpLeng 0) (and (= PassStr 0) (= PinLeng 0)) true))

;;SomeHave = MAX (Certificate, SmartCard, Signature)  
(assert (= SomeHave (ite (>= Certificate SmartCard) 
		               (ite (>= Certificate Signature) Certificate Signature) 
	                         (ite (>= SmartCard  Signature) SmartCard Signature))))    

;; Choose only one from (Certificate, SmartCard, Signature)
(assert (ite (> Certificate 0) (and (= SmartCard 0) (= Signature 0)) true))

(assert (ite (> SmartCard 0) (and (= Certificate 0) (= Signature 0)) true))

(assert (ite (> Signature 0) (and (= Certificate 0) (= SmartCard 0)) true))

;;Signature = MAX (Token,SignCryp, GroupSign, RingSign)
(assert (= Signature (ite (>= Token SignCryp )
                          (ite (>= Token  GroupSign)
                               (ite (>= Token  RingSign ) Token  RingSign) 
                               (ite (>= GroupSign   RingSign ) GroupSign RingSign)) 
		    (ite (>= SignCryp GroupSign) 
	                 (ite (>= SignCryp  RingSign) SignCryp  RingSign) 
	                 (ite (>= GroupSign RingSign) GroupSign RingSign))
)))

;; Choose only one between (Token, SignCryp, GroupSign, RingSign)
(assert (ite (> Token 0) (and (= SignCryp 0) (= GroupSign 0) (= RingSign 0)) true))

(assert (ite (> SignCryp 0) (and (= Token 0) (= GroupSign 0) (= RingSign 0)) true))

(assert (ite (> GroupSign 0) (and (= Token 0) (= SignCryp 0) (= RingSign 0)) true))

(assert (ite (> RingSign 0) (and (= Token 0) (= SignCryp 0) (= GroupSign 0)) true))

;;SomeAre = MAX (Face,Iris,Fingerprint)
(assert (= SomeAre (ite (>= Face Iris)
                        (ite (>= Face Fingerprint) Face Fingerprint)
                        (ite (>= Iris Fingerprint) Iris Fingerprint ))))

;;;;Choose only one between (Face,Iris,Fingerprint)               
(assert (ite (> Face 0) (and (= Iris 0) (= Fingerprint 0)) true))
(assert (ite (> Iris 0) (and (= Face 0) (= Fingerprint 0)) true))
(assert (ite (> Fingerprint 0) (and (= Face 0) (= Iris 0)) true))

;;Automation level
(declare-fun AutoLevel () Real)

;; AutoLevel = Not-Automated (0)|| semi-Automated (0.5) || FullAutomated(1.0)
;; PIN&Password&OTP are not automated 
(assert (ite (or (> PinLeng 0) (> PassStr 0) (> OtpLeng 0)) (= AutoLevel 0) 
        (ite (or (> Token 0) (> SmartCard 0) (> Fingerprint 0)(> Face 0)(> Iris 0) (> SignCryp 0) (> GroupSign 0)
           (> RingSign 0)) (= AutoLevel 0.5)
              (= AutoLevel 1) )))

;;;; CredRnew => (Face&Iris&Fingerprint are not Renewal(0) || Daily(0.90) || Weekly(0.50) || Monthly(0.30) || Yearly(0.10) )

(assert (ite (> SomeKnow 0)  
                  (or (= CredRnew  0.90) (= CredRnew 0.50) (= CredRnew 0.30) (= CredRnew 0.10))    
                  (= CredRnew  0)))

;; DevType
;;(declare-fun DevType () Real)
(declare-fun PC () Real)
(declare-fun LapTop () Real)
(declare-fun Phone () Real)
(declare-fun Reader () Real)
(declare-fun Camera () Real)
(declare-fun Scanner () Real)

(assert (or (=  PC 0) (= PC 1)))
(assert (or (=  LapTop 0) (= LapTop 1)))
(assert (or (=  Reader 0) (= Reader 1)))
(assert (or (=  Phone 0) (= Phone 1)))
(assert (or (=  Camera 0) (= Camera 1)))
(assert (or (=  Scanner 0) (= Scanner 1)))

;; DevType (PC,LapTop,Phone,Reader, Camera, Scanner)               
(assert (ite (or (> PinLeng 0) (> PassStr 0) (> OtpLeng 0) (> Certificate 0) (> Token 0) (> SignCryp 0) (> GroupSign 0) (> RingSign 0))  (or (> PC 0) (> LapTop 0) (> Phone 0)) true))  

(assert (ite (or  (> Face 0) (> Iris 0) ) (> Camera 0) true ))
(assert (ite  (>  Fingerprint 0)   (> Scanner 0) true ))
(assert (ite  (>  SmartCard  0)    (> Reader 0)  true )) 

;;;;;;;;;;;;;;;;;;Impact on the requirements;;;;;;;;;;;;;;;;;;

;; SUM (authentication methods  impact on the Confidentiality psitive (0.5) very positively (0.8) , negative (0.3), very negative(0.1) and not impact (0)                                                                                                                           
(assert (= SumConf (+ (* PinLeng  0.5) 
                      (* PassStr 0.5)
                      (* OtpLeng 0.5) 
                      (* PlateLicense 0.4)
                      (* Certificate 0.8)
                      (* SmartCard 0.6)
                      (* Token 0.8)
                      (* SignCryp 0.8)
                      (* GroupSign 0.8)
                      (* RingSign 0.8)
                      (* Iris 0.8)
                      (* Face 0.8)
                      (* Fingerprint 0.8) (ite (> TwoFactor 0) 0.4 0)  )))

;; Proper average + clamp
(assert (= AVGSumConf (/ SumConf count)))

;; Credential Renewal Discount Factor
(assert (= CredRnewFactor  (/ (- 1 CredRnew) 2))) 

;; the impact of  CredRnew on the Confidentiality 
(assert (ite (> SomeKnow 0)
             (ite (>= AVGSumConf CredRnew)
                  (= AvgConfidentiality (ite (> 0 (- AVGSumConf CredRnewFactor)) 0 (- AVGSumConf CredRnewFactor)))
                  (= AvgConfidentiality (ite (> 1 (+ AVGSumConf CredRnewFactor)) (+ AVGSumConf CredRnewFactor) 1))) true))  

(assert (ite (= SomeKnow 0) (= AvgConfidentiality AVGSumConf) true))

;;; SUM (authentication methods  impact on the Authenticity positive (0.5) very positively (0.8) , negative (0.3), very negative(0.1) and not impact (0)                                                           
(assert (= SumAuth (+ (* PinLeng 0.1) 
                      (* PassStr 0.1)  
                      (* OtpLeng 0.1) 
                      (* PlateLicense 0.5)
                      (* Certificate 0.8 )
                      (* SmartCard 0.5 )
                      (* Token  0.5)
                      (* SignCryp 0.8)
                      (* GroupSign 0.8)
                      (* RingSign 0.8)
                      (* Iris  0.5)
                      (* Face 0.5)
                      (* Fingerprint 0.5) (ite (> TwoFactor 0) 0.4 0) )))

(assert (= AVGSumAuth (/ SumAuth count)))

(assert (= AvgAuthenticity AVGSumAuth))

                                             
;; SUM(authentication methods  impact on the Integrity psitive (0.5) very positively (0.8) , negative (0.3), very negative(0.1) and not impact (0)              
(assert (= SumInteg (+ (* PinLeng  0.5) 
                       (* PassStr 0.5)
                       (* OtpLeng 0.5) 
                       (* PlateLicense 0.4)
                       (* Certificate 0.8)
                       (* SmartCard 0.6)
                       (* Token 0.8)
                       (* SignCryp 0.8)
                       (* GroupSign 0.8)
                       (* RingSign 0.8)
                       (* Iris 0.8)
                       (* Face 0.8)
                       (* Fingerprint 0.8) (ite (> TwoFactor 0) 0.4 0 )
                        )))

(assert (= AVGSumInteg (/ SumInteg count)))

;; the impact of  CredRnew on the Integrity  
;; the impact of  CredRnew on the Confidentiality 
(assert (ite (> SomeKnow 0)
             (ite (>= AVGSumInteg CredRnew)
                  (= AvgIntegrity (ite (> 0 (- AVGSumInteg CredRnewFactor)) 0 (- AVGSumInteg CredRnewFactor)))
                  (= AvgIntegrity (ite (> 1 (+ AVGSumInteg CredRnewFactor)) (+ AVGSumInteg CredRnewFactor) 1))) true))  

;; I added the AvgIntegrity in case that SomeKnow not greater than 0
(assert (ite (= SomeKnow 0) (= AvgIntegrity AVGSumInteg) true))       
                                  
;;SUM (authentication methods  impact on the Efficiency psitive (0.5) very positively (0.8) , negative (0.3), very negative(0.1) and not impact (0)                          

(declare-fun EfficSumBase () Real)

(assert (= EfficSumBase
    (+ (* PinLeng 0.3)
       (* PassStr 0.3)
       (* OtpLeng 0.3) 
       (* PlateLicense 0.8)
       (* Certificate 0.1)
       (* SmartCard 0.6)
       (* Token 0.5)
       (* SignCryp 0.1)
       (* GroupSign 0.1)
       (* RingSign 0.1)
       (* Iris 0.5)
       (* Face 0.5)
       (* Fingerprint 0.5)
    )))

;; Penalty on usability when TwoFactor is used
;; Here we subtract 0.1 from the efficiency score if TwoFactor > 0

(assert
  (ite (> TwoFactor 0)
       (= EfficSum
          (ite (> (- EfficSumBase 0.1) 0)
               (- EfficSumBase 0.1)
               0))           
       (= EfficSum EfficSumBase)))
                                  
 ;; Avg Efficiency                                   
 (assert (= AVGEfficSum (/ EfficSum  count) ))
 
;; AvgEfficiency =MAX (AVGEfficSum , AutoLevel)                                         
 (assert  (ite (> AVGEfficSum AutoLevel) 
               (= AvgEfficiency AVGEfficSum)                                                
               (= AvgEfficiency AutoLevel)))


;; SUM (authentication methods  impact on the Effectiveness psitive (0.5) very positively (0.8) , negative (0.3), very negative(0.1) and not impact (0)                          

(declare-fun EffetSumBase () Real)
(assert (= EffetSumBase  (+ (* PinLeng 0.1)
                                 (* PassStr 0.1)
                                 (* OtpLeng 0.1) 
                                 (* PlateLicense 0.8)
                                 (* Certificate 0.4)
                                 (* SmartCard 0.6)
                                 (* Token 0.5)
                                 (* SignCryp 0.8)
                                 (* GroupSign 0.8)
                                 (* RingSign 0.8)
                                 (* Iris 0.5)
                                 (* Face 0.5)
                                 (* Fingerprint 0.5) )
                                  )) 

;; Penalty on usability when TwoFactor is used
;; Here we subtract from the Effectiveness score if TwoFactor > 0

(assert
  (ite (> TwoFactor 0)
       (= EffetSum
          (ite (> (- EffetSumBase 0.1) 0)
               (- EffetSumBase 0.1)
               0))           
       (= EffetSum EffetSumBase)))

;; Avg Effectiveness                                   
(assert (= AVGEffetSum  (/ EffetSum  count) ))

;;AvgEffectiveness =MAX(AVGEffetSum ,(- 1 CredRnew), AutoLevel )
(assert  (ite (>= AVGEffetSum (-  1 CredRnew))
              (ite (>= AVGEffetSum  AutoLevel) 
                   (= AvgEffectiveness AVGEffetSum) 
                   (= AvgEffectiveness AutoLevel))
              (ite (>= (-  1 CredRnew)  AutoLevel) 
                   (= AvgEffectiveness (-  1 CredRnew)) 
                   (= AvgEffectiveness AutoLevel))
))

;; SUM (authentication methods impact on the Performance psitive (0.5) very positively (0.8) , negative (0.3), very negative(0.1) and not impact (0)                          

(declare-fun PerforSumBase () Real)

(assert (= PerforSumBase  (+ (* PinLeng 0.8)
                               (* PassStr 0.8)
                               (* OtpLeng 0.8) 
                               (* PlateLicense 0.8)
                               (* Certificate 0.1)
                               (* SmartCard 0.6)
                               (* Token 0.5)
                               (* SignCryp 0.1)
                               (* GroupSign 0.1)
                               (* RingSign 0.1)
                               (* Iris 0.3)
                               (* Face 0.3)
                               (* Fingerprint 0.5) )
                                  ))        

;; Penalty on performance when TwoFactor is used
(assert
  (ite (> TwoFactor 0)
       (= PerforSum
          (ite (> (- PerforSumBase 0.1) 0)
               (- PerforSumBase 0.1)
               0))
       (= PerforSum PerforSumBase)))  


 ;; Avg Performance 
(assert (= AVGPerforSum  (/ PerforSum  count) ))
(assert (= AvgPerformance AVGPerforSum)    )     
 
;;  AutoLevel
;; (assert  (ite (>= AVGPerforSum  AutoLevel) 
;;               (= AvgPerformance AVGPerforSum)   
;;               (= AvgPerformance AutoLevel))) 

;;;;; Impact of contextual factors on asset value ;;;;;

(declare-fun AssetValue() Real)
(assert (and (>= AssetValue 0) (<= AssetValue 1)))

;; Calculate AssetValue
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
     (* PatientRecords PatientRecordsSensitivity 0.15))
))

;Controlled and DiagnoseMedicalConditions shared the diagnose asset so they should either 1 together or 0 together
(assert (or (and (= Controlled 1) (= DiagnoseMedicalConditions 1)) (and (= Controlled 0) (= DiagnoseMedicalConditions 0) )))

;;---------------------------------
;;;;The contextual factors impact on the requirements priority

;; The impact of the unfamiliar location or the unusual time on the requirements 
(assert (ite (> Location 0)  
     (and (= ConfPriority 0.8) (= AuthentPriority  0.8) (= IntegPriority 0.7) 
          (= EffectPriority 0.5) (= EfficPriority 0.6) (= PerformancePriority 0.6))  true )) 

;; The impact of the unusual time on the requirements
(assert (ite (> UnusualTime 0)
     (and (>= ConfPriority 0.6) (>= AuthentPriority  0.7) (>= IntegPriority 0.5) 
          (= EffectPriority 0.5) (>= EfficPriority 0.5) (= PerformancePriority 0.6)) true ))
             

;; The impact of the assets and operations on the priority of the security requirements
(assert (ite (and (> Controlled 0) (> NonControlled 0) (> TreatmentPlan 0))
             (and (>= ConfPriority 0.8) (>= AuthentPriority 0.8) (>= IntegPriority 0.7) )
             true))

(assert (ite (and (= Controlled 0) (> NonControlled 0) (> TreatmentPlan 0))
             (and (>= ConfPriority 0.7) (>= AuthentPriority 0.8) (>= IntegPriority 0.65) )
             true))

(assert (ite (and (= Controlled 0) (> NonControlled 0) (= TreatmentPlan 0))
             (and (>= ConfPriority 0.6) (>= AuthentPriority 0.8) (>= IntegPriority 0.6) )
             true))

;;  If (> NightTime 0) ( (= Iris 0)& (= Face  0) )                   
(assert (ite (> PoorLighting 0)  (and (= Iris 0) (= Face  0) ) true ))   


;;--------------------------------

;;I added a new equation for the satisfaction calculation 
;; Confidentiality= (AvgConfidentiality * ConfPriority)
;; Implement Confidentiality = AvgConfidentiality - max(0, ConfPriority - AvgConfidentiality)
(assert (= Confidentiality (ite (>= AvgConfidentiality ConfPriority) (* AvgConfidentiality ConfPriority)
          (- AvgConfidentiality (/ (* (- ConfPriority AvgConfidentiality) (- ConfPriority AvgConfidentiality)) ConfPriority)))))

(assert (= Integrity (ite (>= AvgIntegrity IntegPriority) (* AvgIntegrity IntegPriority)
          (- AvgIntegrity (/ (* (- IntegPriority AvgIntegrity) (- IntegPriority AvgIntegrity)) IntegPriority)))))

(assert (= Authenticity (ite (>= AvgAuthenticity AuthentPriority) (* AvgAuthenticity AuthentPriority)
          (- AvgAuthenticity (/ (* (- AuthentPriority AvgAuthenticity) (- AuthentPriority AvgAuthenticity)) AuthentPriority)))))

(assert (= Efficiency (ite (>= AvgEfficiency EfficPriority) (* AvgEfficiency EfficPriority)
          (- AvgEfficiency (/ (* (- EfficPriority AvgEfficiency) (- EfficPriority AvgEfficiency)) EfficPriority)))))

(assert (= Effectiveness (ite (>= AvgEffectiveness EffectPriority) (* AvgEffectiveness EffectPriority)
          (- AvgEffectiveness (/ (* (- EffectPriority AvgEffectiveness) (- EffectPriority AvgEffectiveness)) EffectPriority)))))

(assert (= Performance (ite (>= AvgPerformance PerformancePriority) (* AvgPerformance PerformancePriority)
          (- AvgPerformance (/ (* (- PerformancePriority AvgPerformance) (- PerformancePriority AvgPerformance)) PerformancePriority)))))

;;;;Attacks
;; I have added the Risk before the mitigation as BPRisk
(declare-fun PImpersAttack() Real)
(declare-fun FPImpersAttack() Real)
(declare-fun PRiskPImpersAttack() Real )
(declare-fun BPRiskPImpersAttack() Real )

(assert (and (<= 0 PImpersAttack ) (<= PImpersAttack 1)))
(assert (and (<= 0 FPImpersAttack ) (<= FPImpersAttack 1)))
(assert (and (<= 0 PRiskPImpersAttack ) (<= PRiskPImpersAttack 1)))
(assert (and (<= 0 BPRiskPImpersAttack ) (<= BPRiskPImpersAttack 1)))

(declare-fun PReplayAttack() Real)
(declare-fun FPReplayAttack() Real)
(declare-fun PRiskReplayAttack() Real)
(declare-fun BPRiskReplayAttack() Real)

(assert (and (<= 0 PReplayAttack ) (<= PReplayAttack 1)))
(assert (and (<= 0 FPReplayAttack ) (<= FPReplayAttack 1)))
(assert (and (<= 0 PRiskReplayAttack ) (<= PRiskReplayAttack 1)))
(assert (and (<= 0 BPRiskReplayAttack ) (<= BPRiskReplayAttack 1)))


;;Session Hijacking attack
(declare-fun PSessionAttack() Real)
(declare-fun FPSessionAttack() Real)
(declare-fun PRiskSessionAttack() Real)
(declare-fun BPRiskSessionAttack() Real)

(assert (and (<= 0 PSessionAttack ) (<= PSessionAttack 1)))
(assert (and (<= 0 FPSessionAttack ) (<= FPSessionAttack 1)))
(assert (and (<= 0 PRiskSessionAttack ) (<= PRiskSessionAttack 1)))
(assert (and (<= 0 BPRiskSessionAttack ) (<= BPRiskSessionAttack 1)))




;If(> Insecure Network 0)                
;(assert (ite (> InsecNetwork 0) (and (= PImpersAttack 0.5) (= PSessionAttack 0.7) (= PReplayAttack 0.6) ) true  )) 


; --- Sensitivity: Impersonation likelihood (baseline=0.5, Δ=0.1) ---
;If(> InsecNetwork 0)                
; (assert (ite (> InsecNetwork 0)(and (= PImpersAttack 0.3) (= PSessionAttack 0.7) (= PReplayAttack 0.6))
;     true))

; If(> InsecNetwork 0)                
;(assert (ite (> InsecNetwork 0)
 ;   (and (= PImpersAttack 0.4) (= PSessionAttack 0.7) (= PReplayAttack 0.6))
  ;  true))

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

; ===== Replay sensitivity: PReplayAttack = 0.5 (-0.1) =====
; If(> Insecure Network 0)
; (assert (ite (> InsecNetwork 0)
;     (and (= PImpersAttack 0.5) (= PSessionAttack 0.7) (= PReplayAttack 0.5))
;     true))


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

; ; ===== Session sensitivity: PSessionAttack = 0.6 (-0.1) =====
; If(> Insecure Network 0)
; (assert (ite (> InsecNetwork 0)
;     (and (= PImpersAttack 0.5) (= PSessionAttack 0.6) (= PReplayAttack 0.6))
;     true))


; ; ===== Session sensitivity: PSessionAttack = 0.8 (+0.1) =====
; ; If(> InsecNetwork 0)
; (assert (ite (> InsecNetwork 0)
;     (and (= PImpersAttack 0.5) (= PSessionAttack 0.8) (= PReplayAttack 0.6))
;     true))

; ; ===== Session sensitivity: PSessionAttack = 0.9 (+0.2) =====
; ; If(> InsecNetwork 0)
(assert (ite (> InsecNetwork 0)
    (and (= PImpersAttack 0.5) (= PSessionAttack 0.9) (= PReplayAttack 0.6))
    true))

;; -----------Consider this section after the authentication-------------
(declare-fun  ImpersAttackImpact () Real) 
(declare-fun  ReplayAttackImpact () Real) 
(declare-fun  SessionAttackImpact () Real) 

(assert (and (<= 0 ImpersAttackImpact ) (<= ImpersAttackImpact 1)))
(assert (and (<= 0 ReplayAttackImpact ) (<= ReplayAttackImpact 1)))
(assert (and (<= 0 SessionAttackImpact ) (<= SessionAttackImpact 1)))


(declare-fun  ResRisk () Real)

;; Total Risk before any Mitigation
(declare-fun  TotalRisk () Real)

(assert (and (<= 0 ResRisk ) (<= ResRisk 1)))
(assert (and (<= 0 TotalRisk ) (<= TotalRisk 1)))

; Should I make the impact between 0 and 1 ??
;I change it from <= to = because these values should be fixed
;; AVG (authentication methods impact on the PImpersAttack psitive (0.5) very positively (0.8) , negative (0.3), very negative(0.1) and not impact (0)
;; AVG (authentication methods impact on the PImpersAttack psitive (0.5) very positively (0.8) , negative (0.3), very negative(0.1) and not impact (0)                          
(assert (= ImpersAttackImpact (/ (+ (* PinLeng 0.3)
                               (* PassStr 0.3)
                               (* OtpLeng 0.3) 
                               (* PlateLicense 0.1)
                               (* Certificate 0.7)
                               (* SmartCard 0.3)
                               (* Token 0.3)
                               (* SignCryp 0.1)
                               (* GroupSign 0.1)
                               (* RingSign 0.1)
                               (* Iris 0.1)
                               (* Face 0.1)
                               (* Fingerprint 0.1) (ite (> TwoFactor 0) 0.3 0) ) count )
                                  )) 

;;PPImpersAttack=(PkPImpersAttack - ImpersAttackImpact)
(assert (=  FPImpersAttack (- PImpersAttack ImpersAttackImpact ))) 

;; AVG (authentication methods impact on the PImpersAttack psitive (0.5) very positively (0.8) , negative (0.3), very negative(0.1) and not impact (0)                          
(assert (= ReplayAttackImpact (/ (+ (* PinLeng 0.3)
                               (* PassStr 0.3)
                               (* OtpLeng 0.1) 
                               (* PlateLicense 0.1)
                               (* Certificate 0.7)
                               (* SmartCard 0.3)
                               (* Token 0.1)
                               (* SignCryp 0.1)
                               (* GroupSign 0.1)
                               (* RingSign 0.1)
                               (* Iris 0.1)
                               (* Face 0.1)
                               (* Fingerprint 0.1) (ite (> TwoFactor 0) 0.3 0) ) count )
                                  ))  


;;Final PReplayAttack  =(PReplayAttack - ReplayAttackImpact )
(assert (= FPReplayAttack (- PReplayAttack  ReplayAttackImpact )))


;; AVG (authentication methods impact on the PImpersAttack psitive (0.5) very positively (0.8) , negative (0.3), very negative(0.1) and not impact (0)                          
(assert (= SessionAttackImpact (/ (+ (* PinLeng 0.3)
                               (* PassStr 0.3)
                               (* OtpLeng 0.3) 
                               (* Certificate 0.6)
                               (* SmartCard 0.5)
                               (* Token 0.5)
                               (* SignCryp 0.3)
                               (* GroupSign 0.3)
                               (* RingSign 0.3)
                               (* Iris 0.4)
                               (* Face 0.4)
                               (* Fingerprint 0.4)  (ite (> TwoFactor 0) 0.3 0)) count )
                                  )) 
;; We turned these authentication methdos off as they are not suitable for the healthcare scenarios
(assert (= PlateLicense 0))

;;Final FPSessionAttack  =(PSessionAttack - SessionAttackImpact )
(assert (= FPSessionAttack (- PSessionAttack  SessionAttackImpact )))

;;Risk of the attack = Probability of attack after mitigation * Asset value 
(assert (= PRiskPImpersAttack (* FPImpersAttack AssetValue) ) )
(assert (= PRiskReplayAttack (* FPReplayAttack AssetValue) ) )
(assert (= PRiskSessionAttack (* FPSessionAttack AssetValue) ) )

;;Risk of the attacks before the mitigation
(assert (= BPRiskPImpersAttack (* PImpersAttack AssetValue) ) )
(assert (= BPRiskReplayAttack (* PReplayAttack AssetValue) ) )
(assert (= BPRiskSessionAttack (* PSessionAttack AssetValue) ) )

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


;; Utility=AVG(Security  Usability Performance (- 1 ResidualRisk))
(assert (<= Utility (/ (+ Security  Usability Performance (- 1 ResRisk)) 4))) 


(assert (= Location 1))

(assert (= UnusualTime 1))

(assert (= InsecNetwork 1))
(assert (= PoorLighting 0))

(assert (= UseMaxAgg true))




(assert (= Controlled 1))
(assert (= TreatmentPlan 1))
(assert (= AddEncounterNote 1))
(assert (= NonControlled 1))
(assert (= AddReferralNote 1))
(assert (= DiagnoseMedicalConditions 1))
(assert (= GenerateReports 1))

(assert (= Diagnosis 1))
(assert (= TreatmentPlan 1))
(assert (= LabResults 1))
(assert (= TestReports 1))
(assert (= NonControlledPrescriptions 1))
(assert (= PatientHistory 1))
(assert (= ControlledPrescriptions 1))
(assert (= PatientInteractions 1))
(assert (= VisitSummaries 1))
(assert (= ReferralNotes 1))
(assert (= EncounterNotes 1))
(assert (= PatientRecords 1))

; ===== Phase-1 FULL CRUD (full access) =====
(assert (and Diagnosis_Read Diagnosis_Write Diagnosis_Update Diagnosis_Delete))
(assert (and TreatmentPlan_Read TreatmentPlan_Write TreatmentPlan_Update TreatmentPlan_Delete))
(assert (and LabResults_Read LabResults_Write LabResults_Update LabResults_Delete))
(assert (and TestReports_Read TestReports_Write TestReports_Update TestReports_Delete))
(assert (and NonControlledPrescriptions_Read NonControlledPrescriptions_Write NonControlledPrescriptions_Update NonControlledPrescriptions_Delete))
(assert (and PatientHistory_Read PatientHistory_Write PatientHistory_Update PatientHistory_Delete))
(assert (and ControlledPrescriptions_Read ControlledPrescriptions_Write ControlledPrescriptions_Update ControlledPrescriptions_Delete))
(assert (and PatientInteractions_Read PatientInteractions_Write PatientInteractions_Update PatientInteractions_Delete))
(assert (and VisitSummaries_Read VisitSummaries_Write VisitSummaries_Update VisitSummaries_Delete))
(assert (and ReferralNotes_Read ReferralNotes_Write ReferralNotes_Update ReferralNotes_Delete))
(assert (and EncounterNotes_Read EncounterNotes_Write EncounterNotes_Update EncounterNotes_Delete))
(assert (and PatientRecords_Read PatientRecords_Write PatientRecords_Update PatientRecords_Delete))

