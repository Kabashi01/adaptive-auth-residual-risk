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

;; The Fifth scenario contextual factors
(declare-fun Emergency() Real)
(declare-fun OffSite() Real)
(declare-fun SharedDevice() Real)
(declare-fun PoorLighting () Real)

;; 0 positive and 1 negative
(assert (or (=  Emergency 0) (= Emergency 1)))
(assert (or (=  OffSite 0) (= OffSite 1)))
(assert (or (=  SharedDevice 0) (= SharedDevice 1)))
(assert (or (=  PoorLighting 0) (= PoorLighting 1)))

;; =========================
;; ICS Scenario S4 Assets
;; (Remote Maintenance)
;; =========================

;; Asset sensitivity / value in [0,1]
(declare-fun SafetyLimits () Real)
(declare-fun AlarmRules () Real)
(declare-fun DiagnosticData () Real)
(declare-fun SystemLogs () Real)
(declare-fun ControllerConfiguration () Real)
(declare-fun ControlParameters () Real)
(declare-fun ActuatorCommands () Real)
(declare-fun CalibrationProfiles () Real)
(declare-fun MaintenanceRecords () Real)
(declare-fun FirmwareImages () Real)

;; Bounds
(assert (and (<= 0 SafetyLimits) (<= SafetyLimits 1)))
(assert (and (<= 0 AlarmRules) (<= AlarmRules 1)))
(assert (and (<= 0 DiagnosticData) (<= DiagnosticData 1)))
(assert (and (<= 0 SystemLogs) (<= SystemLogs 1)))
(assert (and (<= 0 ControllerConfiguration) (<= ControllerConfiguration 1)))
(assert (and (<= 0 ControlParameters) (<= ControlParameters 1)))
(assert (and (<= 0 ActuatorCommands) (<= ActuatorCommands 1)))
(assert (and (<= 0 CalibrationProfiles) (<= CalibrationProfiles 1)))
(assert (and (<= 0 MaintenanceRecords) (<= MaintenanceRecords 1)))
(assert (and (<= 0 FirmwareImages) (<= FirmwareImages 1)))

;;Operations 
;; ----------------------------
(declare-fun ViewSafetyStatusAndAlarms () Real) ; M
(declare-fun ViewDiagnostics () Real)           ; M
(declare-fun AcknowledgeAlarms () Real)         ; M
(declare-fun EmergencyShutdown  () Real)         ; M

(declare-fun SwitchControlMode () Real)           ; N
(declare-fun AdjustControlSetpoints () Real)      ; N
(declare-fun RestartSubsystemController () Real)  ; N

(declare-fun ExportDownloadLogs () Real)    ; O
(declare-fun UploadFirmware () Real)        ; O


;; ----------------------------
(assert (and (<= 0 ViewSafetyStatusAndAlarms) (<= ViewSafetyStatusAndAlarms 1)))
(assert (and (<= 0 ViewDiagnostics) (<= ViewDiagnostics 1)))
(assert (and (<= 0 AcknowledgeAlarms) (<= AcknowledgeAlarms 1)))
(assert (and (<= 0 EmergencyShutdown) (<= EmergencyShutdown 1)))

(assert (and (<= 0 SwitchControlMode) (<= SwitchControlMode 1)))
(assert (and (<= 0 AdjustControlSetpoints) (<= AdjustControlSetpoints 1)))
(assert (and (<= 0 RestartSubsystemController) (<= RestartSubsystemController 1)))

(assert (and (<= 0 ExportDownloadLogs) (<= ExportDownloadLogs 1)))
(assert (and (<= 0 UploadFirmware) (<= UploadFirmware 1)))



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


;; ============================================================
;; ICS S4 — Asset Permission Declarations and Sensitivity Ranges
;; ============================================================

;; ------------------------------------------------------------
;; SafetyLimits (Very High Criticality – Physical Safety)
;; ------------------------------------------------------------
(declare-fun SafetyLimits_Read () Bool)
(declare-fun SafetyLimits_Write () Bool)
(declare-fun SafetyLimits_Update () Bool)
(declare-fun SafetyLimits_Delete () Bool)
(declare-fun SafetyLimitsSensitivity () Real)

(assert
  (ite SafetyLimits_Delete
    (and (>= SafetyLimitsSensitivity 0.90) (<= SafetyLimitsSensitivity 0.95))
    (ite SafetyLimits_Update
      (and (>= SafetyLimitsSensitivity 0.85) (<= SafetyLimitsSensitivity 0.90))
      (ite SafetyLimits_Write
        (and (>= SafetyLimitsSensitivity 0.80) (<= SafetyLimitsSensitivity 0.85))
        (and (>= SafetyLimitsSensitivity 0.70) (<= SafetyLimitsSensitivity 0.80))
      )
    )
  )
)

;; ------------------------------------------------------------
;; AlarmRules (High – Safety & Monitoring Integrity)
;; ------------------------------------------------------------
(declare-fun AlarmRules_Read () Bool)
(declare-fun AlarmRules_Write () Bool)
(declare-fun AlarmRules_Update () Bool)
(declare-fun AlarmRules_Delete () Bool)
(declare-fun AlarmRulesSensitivity () Real)

(assert
  (ite AlarmRules_Delete
    (and (>= AlarmRulesSensitivity 0.80) (<= AlarmRulesSensitivity 0.85))
    (ite AlarmRules_Update
      (and (>= AlarmRulesSensitivity 0.75) (<= AlarmRulesSensitivity 0.80))
      (ite AlarmRules_Write
        (and (>= AlarmRulesSensitivity 0.70) (<= AlarmRulesSensitivity 0.75))
        (and (>= AlarmRulesSensitivity 0.60) (<= AlarmRulesSensitivity 0.70))
      )
    )
  )
)

;; ------------------------------------------------------------
;; DiagnosticData (Medium – Observational)
;; ------------------------------------------------------------
(declare-fun DiagnosticData_Read () Bool)
(declare-fun DiagnosticData_Write () Bool)
(declare-fun DiagnosticData_Update () Bool)
(declare-fun DiagnosticData_Delete () Bool)
(declare-fun DiagnosticDataSensitivity () Real)

(assert
  (ite DiagnosticData_Delete
    (and (>= DiagnosticDataSensitivity 0.60) (<= DiagnosticDataSensitivity 0.65))
    (ite DiagnosticData_Update
      (and (>= DiagnosticDataSensitivity 0.55) (<= DiagnosticDataSensitivity 0.60))
      (ite DiagnosticData_Write
        (and (>= DiagnosticDataSensitivity 0.50) (<= DiagnosticDataSensitivity 0.55))
        (and (>= DiagnosticDataSensitivity 0.40) (<= DiagnosticDataSensitivity 0.50))
      )
    )
  )
)

;; ------------------------------------------------------------
;; SystemLogs (Medium – Audit & Forensics)
;; ------------------------------------------------------------
(declare-fun SystemLogs_Read () Bool)
(declare-fun SystemLogs_Write () Bool)
(declare-fun SystemLogs_Update () Bool)
(declare-fun SystemLogs_Delete () Bool)
(declare-fun SystemLogsSensitivity () Real)

(assert
  (ite SystemLogs_Delete
    (and (>= SystemLogsSensitivity 0.70) (<= SystemLogsSensitivity 0.75))
    (ite SystemLogs_Update
      (and (>= SystemLogsSensitivity 0.65) (<= SystemLogsSensitivity 0.70))
      (ite SystemLogs_Write
        (and (>= SystemLogsSensitivity 0.60) (<= SystemLogsSensitivity 0.65))
        (and (>= SystemLogsSensitivity 0.50) (<= SystemLogsSensitivity 0.60))
      )
    )
  )
)

;; ------------------------------------------------------------
;; ControllerConfiguration (High – Control Logic)
;; ------------------------------------------------------------
(declare-fun ControllerConfiguration_Read () Bool)
(declare-fun ControllerConfiguration_Write () Bool)
(declare-fun ControllerConfiguration_Update () Bool)
(declare-fun ControllerConfiguration_Delete () Bool)
(declare-fun ControllerConfigurationSensitivity () Real)

(assert
  (ite ControllerConfiguration_Delete
    (and (>= ControllerConfigurationSensitivity 0.95) (<= ControllerConfigurationSensitivity 0.99))
    (ite ControllerConfiguration_Update
      (and (>= ControllerConfigurationSensitivity 0.90) (<= ControllerConfigurationSensitivity 0.95))
      (ite ControllerConfiguration_Write
        (and (>= ControllerConfigurationSensitivity 0.85) (<= ControllerConfigurationSensitivity 0.90))
        (and (>= ControllerConfigurationSensitivity 0.75) (<= ControllerConfigurationSensitivity 0.85))
      )
    )
  )
)

;; ------------------------------------------------------------
;; ControlParameters (High – Runtime Behaviour)
;; ------------------------------------------------------------
(declare-fun ControlParameters_Read () Bool)
(declare-fun ControlParameters_Write () Bool)
(declare-fun ControlParameters_Update () Bool)
(declare-fun ControlParameters_Delete () Bool)
(declare-fun ControlParametersSensitivity () Real)

(assert
  (ite ControlParameters_Delete
    (and (>= ControlParametersSensitivity 0.85) (<= ControlParametersSensitivity 0.90))
    (ite ControlParameters_Update
      (and (>= ControlParametersSensitivity 0.80) (<= ControlParametersSensitivity 0.85))
      (ite ControlParameters_Write
        (and (>= ControlParametersSensitivity 0.75) (<= ControlParametersSensitivity 0.80))
        (and (>= ControlParametersSensitivity 0.65) (<= ControlParametersSensitivity 0.75))
      )
    )
  )
)

;; ------------------------------------------------------------
;; ActuatorCommands (Critical – Direct Physical Impact)
;; ------------------------------------------------------------
(declare-fun ActuatorCommands_Read () Bool)
(declare-fun ActuatorCommands_Write () Bool)
(declare-fun ActuatorCommands_Update () Bool)
(declare-fun ActuatorCommands_Delete () Bool)
(declare-fun ActuatorCommandsSensitivity () Real)

(assert
  (ite ActuatorCommands_Delete
    (and (>= ActuatorCommandsSensitivity 0.92) (<= ActuatorCommandsSensitivity 0.97))
    (ite ActuatorCommands_Update
      (and (>= ActuatorCommandsSensitivity 0.88) (<= ActuatorCommandsSensitivity 0.92))
      (ite ActuatorCommands_Write
        (and (>= ActuatorCommandsSensitivity 0.83) (<= ActuatorCommandsSensitivity 0.88))
        (and (>= ActuatorCommandsSensitivity 0.75) (<= ActuatorCommandsSensitivity 0.83))
      )
    )
  )
)

;; ------------------------------------------------------------
;; CalibrationProfiles (Medium – Indirect Process Influence)
;; ------------------------------------------------------------
(declare-fun CalibrationProfiles_Read () Bool)
(declare-fun CalibrationProfiles_Write () Bool)
(declare-fun CalibrationProfiles_Update () Bool)
(declare-fun CalibrationProfiles_Delete () Bool)
(declare-fun CalibrationProfilesSensitivity () Real)

(assert
  (ite CalibrationProfiles_Delete
    (and (>= CalibrationProfilesSensitivity 0.75) (<= CalibrationProfilesSensitivity 0.80))
    (ite CalibrationProfiles_Update
      (and (>= CalibrationProfilesSensitivity 0.70) (<= CalibrationProfilesSensitivity 0.75))
      (ite CalibrationProfiles_Write
        (and (>= CalibrationProfilesSensitivity 0.65) (<= CalibrationProfilesSensitivity 0.70))
        (and (>= CalibrationProfilesSensitivity 0.55) (<= CalibrationProfilesSensitivity 0.65))
      )
    )
  )
)

;; ------------------------------------------------------------
;; MaintenanceRecords (Low–Medium – Administrative)
;; ------------------------------------------------------------
(declare-fun MaintenanceRecords_Read () Bool)
(declare-fun MaintenanceRecords_Write () Bool)
(declare-fun MaintenanceRecords_Update () Bool)
(declare-fun MaintenanceRecords_Delete () Bool)
(declare-fun MaintenanceRecordsSensitivity () Real)

(assert
  (ite MaintenanceRecords_Delete
    (and (>= MaintenanceRecordsSensitivity 0.85) (<= MaintenanceRecordsSensitivity 0.90))
    (ite MaintenanceRecords_Update
      (and (>= MaintenanceRecordsSensitivity 0.80) (<= MaintenanceRecordsSensitivity 0.85))
      (ite MaintenanceRecords_Write
        (and (>= MaintenanceRecordsSensitivity 0.75) (<= MaintenanceRecordsSensitivity 0.80))
        (and (>= MaintenanceRecordsSensitivity 0.65) (<= MaintenanceRecordsSensitivity 0.75))
      )
    )
  )
)

;; ------------------------------------------------------------
;; FirmwareImages (Very High – Persistent Compromise Risk)
;; ------------------------------------------------------------
(declare-fun FirmwareImages_Read () Bool)
(declare-fun FirmwareImages_Write () Bool)
(declare-fun FirmwareImages_Update () Bool)
(declare-fun FirmwareImages_Delete () Bool)
(declare-fun FirmwareImagesSensitivity () Real)

(assert
  (ite FirmwareImages_Delete
    (and (>= FirmwareImagesSensitivity 0.93) (<= FirmwareImagesSensitivity 0.98))
    (ite FirmwareImages_Update
      (and (>= FirmwareImagesSensitivity 0.90) (<= FirmwareImagesSensitivity 0.93))
      (ite FirmwareImages_Write
        (and (>= FirmwareImagesSensitivity 0.85) (<= FirmwareImagesSensitivity 0.90))
        (and (>= FirmwareImagesSensitivity 0.78) (<= FirmwareImagesSensitivity 0.85))
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

;; =========================
;; AssetValue for ICS Scenario S4 (Remote Maintenance)
;; =========================
(assert (= AssetValue
  (+ (* SafetyLimits SafetyLimitsSensitivity 0.16)
     (* ActuatorCommands ActuatorCommandsSensitivity 0.15)
     (* ControllerConfiguration ControllerConfigurationSensitivity 0.15)
     (* ControlParameters ControlParametersSensitivity 0.10)
     (* FirmwareImages FirmwareImagesSensitivity 0.15)
     (* AlarmRules AlarmRulesSensitivity 0.08)
     (* DiagnosticData DiagnosticDataSensitivity 0.02)
     (* CalibrationProfiles CalibrationProfilesSensitivity 0.08)
     (* SystemLogs SystemLogsSensitivity 0.03)
     (* MaintenanceRecords MaintenanceRecordsSensitivity 0.08))
))

;;---------------------------------
;;;;The contextual factors impact on the requirements priority

;; Impact of Emergency 
(assert
  (ite (> Emergency 0)
       (and (>= ConfPriority 0.55)
            (>= AuthentPriority 0.55)
            (>= IntegPriority 0.55)
            (= EffectPriority 0.75)
            (= EfficPriority 0.7)
            (= PerformancePriority 0.8))
       true))


;; Impact of unfamiliar device
(assert
  (ite (> SharedDevice 0)
       (and (<= ConfPriority 0.7)
            (<= AuthentPriority 0.7)
            (<= IntegPriority 0.65)
            (> EffectPriority 0.5)
            (> EfficPriority 0.5)
            (> PerformancePriority 0.5))
       true))


;; Impact of out of the site access
(assert
  (ite (> OffSite 0)
       (and (<= ConfPriority 0.7)
            (<= AuthentPriority 0.7)
            (<= IntegPriority 0.65)
            (>= EffectPriority 0.5)
            (>= EfficPriority 0.55)
            (>= PerformancePriority 0.5))
       true))






;;  If (> PoorLighting 0) ( (= Iris 0)& (= Face  0) )                   
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


; =========================================================
; Sensitivity analysis knobs (comment/uncomment ONE per knob)
; =========================================================

; --- Declare parameter knobs ---
(declare-const PImpers Real)        ; value used when SharedDevice > 0
(declare-const PSession Real)    ; lower-bound used when SharedDevice > 0
(declare-const PReplay Real)               ; value used when VpnAccess > 0

; Keep them in [0,1]
(assert (and (<= 0 PImpers)      (<= PImpers 1)))
(assert (and (<= 0 PSession)  (<= PSession 1)))
(assert (and (<= 0 PSession)            (<= PSession 1)))
(assert (and (<= 0 PReplay)             (<= PReplay 1)))

; ---------------------------------------------------------
; Choose ONE value for each knob (uncomment ONE line only)
; ---------------------------------------------------------

; ===== Knob 1: PImpers (base 0.5) =====
(assert (= PImpers 0.5)) ; baseline


; ===== Knob 3: PSession (base 0.6) =====
(assert (= PSession 0.65)) ; baseline


; ===== Knob 4: PReplay (base 0.52) =====
(assert (= PReplay 0.52)) ; baseline




; Unfamiliar device increases impersonation and session hijacking
(assert
  (ite (> SharedDevice 0)
       (and (= PImpersAttack PImpers) (= PSessionAttack PSession) (= PReplayAttack PReplay) )
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


(assert (= Emergency 1))

(assert (= SharedDevice 1))

(assert (= OffSite 0))
(assert (= PoorLighting 0))

(assert (= UseSumAgg true))




;; =========================
;; S4 Operations Enabled 
;; =========================
(assert (= ViewSafetyStatusAndAlarms 1))
(assert (= ViewDiagnostics 1))
(assert (= AcknowledgeAlarms 1))
(assert (= EmergencyShutdown 1))

(assert (= SwitchControlMode 1))
(assert (= AdjustControlSetpoints 1))
(assert (= RestartSubsystemController 1))

(assert (= ExportDownloadLogs 1))
(assert (= UploadFirmware 1))

;; =========================
;; S4 Assets Present
;; =========================
(assert (= SafetyLimits 1))
(assert (= AlarmRules 1))
(assert (= DiagnosticData 1))
(assert (= SystemLogs 1))
(assert (= ControllerConfiguration 1))
(assert (= ControlParameters 1))
(assert (= ActuatorCommands 1))
(assert (= CalibrationProfiles 1))
(assert (= MaintenanceRecords 1))
(assert (= FirmwareImages 1))

;; =========================
;; Phase-1 FULL CRUD Access
;; =========================

;; SafetyLimits
(assert (and SafetyLimits_Read SafetyLimits_Write
             SafetyLimits_Update SafetyLimits_Delete))

;; AlarmRules
(assert (and AlarmRules_Read AlarmRules_Write
             AlarmRules_Update AlarmRules_Delete))

;; DiagnosticData
(assert (and DiagnosticData_Read DiagnosticData_Write
             DiagnosticData_Update DiagnosticData_Delete))

;; SystemLogs
(assert (and SystemLogs_Read SystemLogs_Write
             SystemLogs_Update SystemLogs_Delete))

;; ControllerConfiguration
(assert (and ControllerConfiguration_Read ControllerConfiguration_Write
             ControllerConfiguration_Update ControllerConfiguration_Delete))

;; ControlParameters
(assert (and ControlParameters_Read ControlParameters_Write
             ControlParameters_Update ControlParameters_Delete))

;; ActuatorCommands
(assert (and ActuatorCommands_Read ActuatorCommands_Write
             ActuatorCommands_Update ActuatorCommands_Delete))

;; CalibrationProfiles
(assert (and CalibrationProfiles_Read CalibrationProfiles_Write
             CalibrationProfiles_Update CalibrationProfiles_Delete))

;; MaintenanceRecords
(assert (and MaintenanceRecords_Read MaintenanceRecords_Write
             MaintenanceRecords_Update MaintenanceRecords_Delete))

;; FirmwareImages
(assert (and FirmwareImages_Read FirmwareImages_Write
             FirmwareImages_Update FirmwareImages_Delete))