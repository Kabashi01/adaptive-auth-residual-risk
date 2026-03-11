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
(declare-fun Location() Real)
(declare-fun OffMainWindow() Real)
(declare-fun UnfamiliarDevice() Real)
(declare-fun VpnAccess() Real)
(declare-fun NightTime () Real)

;; 0 positive and 1 negative
(assert (or (=  Location 0) (= Location 1)))
(assert (or (=  OffMainWindow 0) (= OffMainWindow 1)))
(assert (or (=  UnfamiliarDevice 0) (= UnfamiliarDevice 1)))
(assert (or (=  VpnAccess 0) (= VpnAccess 1)))
(assert (or (=  NightTime 0) (= NightTime 1)))

;; Optional (leave unconstrained or set in Python if you use them later)
(declare-fun SessionTime () Real)
(declare-fun BehaviorDeviation () Real)
(assert (and (>= SessionTime 0) (<= SessionTime 1)))
(assert (and (>= BehaviorDeviation 0) (<= BehaviorDeviation 1)))

;; -------------------------
;;Operations 
;; ----------------------------
(declare-fun ViewSafetyStatusAndAlarms () Real) ; M
(declare-fun ViewDiagnostics () Real)           ; M
(declare-fun AcknowledgeAlarms () Real)         ; M

(declare-fun SwitchControlMode () Real)           ; N
(declare-fun AdjustControlSetpoints () Real)      ; N
(declare-fun RestartSubsystemController () Real)  ; N
(declare-fun CalibrateSensorsRebaseline () Real)  ; N
(declare-fun RunSystemSelfTests () Real)    ; O
(declare-fun ExportDownloadLogs () Real)    ; O
(declare-fun UploadFirmware () Real)        ; O


;; ----------------------------
(assert (and (<= 0 ViewSafetyStatusAndAlarms) (<= ViewSafetyStatusAndAlarms 1)))
(assert (and (<= 0 ViewDiagnostics) (<= ViewDiagnostics 1)))
(assert (and (<= 0 AcknowledgeAlarms) (<= AcknowledgeAlarms 1)))

(assert (and (<= 0 SwitchControlMode) (<= SwitchControlMode 1)))
(assert (and (<= 0 AdjustControlSetpoints) (<= AdjustControlSetpoints 1)))
(assert (and (<= 0 RestartSubsystemController) (<= RestartSubsystemController 1)))
(assert (and (<= 0 CalibrateSensorsRebaseline) (<= CalibrateSensorsRebaseline 1)))

(assert (and (<= 0 RunSystemSelfTests) (<= RunSystemSelfTests 1)))
(assert (and (<= 0 ExportDownloadLogs) (<= ExportDownloadLogs 1)))
(assert (and (<= 0 UploadFirmware) (<= UploadFirmware 1)))

;; Must/Nice/Optional category flags (derived)
(declare-fun Must () Real)
(declare-fun Nice () Real)
(declare-fun Optional () Real)
(assert (or (= Must 0) (= Must 1)))
(assert (or (= Nice 0) (= Nice 1)))
(assert (or (= Optional 0) (= Optional 1)))

;; --------------------------------------------------
;; MUST / NICE / OPTIONAL — ICS hierarchy 
;; --------------------------------------------------

;; Must-have operations are always enabled
(assert (and (> Must 0)
             (> ViewSafetyStatusAndAlarms 0)
             (> ViewDiagnostics 0)
             (> AcknowledgeAlarms 0)))

;; Nice is active iff any Nice operation is active
(assert
  (= (> Nice 0)
     (or (> SwitchControlMode 0)
         (> AdjustControlSetpoints 0)
         (> RestartSubsystemController 0)
         (> CalibrateSensorsRebaseline 0))))

;; Optional is active iff any Optional operation is active
(assert
  (= (> Optional 0)
     (> (+ RunSystemSelfTests
           ExportDownloadLogs
           UploadFirmware) 0)))

;; Optional requires Nice
(assert (=> (> Optional 0) (> Nice 0)))

;; -------------------------
;; Assets (0/1) + permissions (Bool) + sensitivities
;; -------------------------
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

;; Asset ON/OFF depends on operations (mirrors your mapping)
;; ============================================================
;; ICS S4 — Asset ON/OFF depends on Operations
;; (Mirrors Healthcare Asset–Operation Mapping Pattern)
;; ============================================================

;; ------------------------------------------------------------
;; Safety & Monitoring Assets (Must-level)
;; ------------------------------------------------------------

;; SafetyLimits required for safety status and emergency actions
(assert
  (ite (or (> ViewSafetyStatusAndAlarms 0)
           (> AdjustControlSetpoints 0))
       (= SafetyLimits 1)
       (= SafetyLimits 0)))

;; AlarmRules needed for alarms and acknowledgements
(assert
  (ite (or (> ViewSafetyStatusAndAlarms 0)
           (> AcknowledgeAlarms 0))
       (= AlarmRules 1)
       (= AlarmRules 0)))

;; DiagnosticData required for diagnostics and testing
(assert
  (ite (or (> ViewDiagnostics 0)
           (> ViewSafetyStatusAndAlarms 0)
           (> RunSystemSelfTests 0)
           (> ExportDownloadLogs 0)
           (> CalibrateSensorsRebaseline 0))
       (= DiagnosticData 1)
       (= DiagnosticData 0)))

;; SystemLogs required for alarms, restarts, and exports
(assert
  (ite (or (> AcknowledgeAlarms 0)
           (> RestartSubsystemController 0)
           (> ViewDiagnostics 0)
           (> RunSystemSelfTests 0)
           (> UploadFirmware 0)
           (> ExportDownloadLogs 0))
       (= SystemLogs 1)
       (= SystemLogs 0)))

;; ------------------------------------------------------------
;; Control & Configuration Assets (Nice-level)
;; ------------------------------------------------------------

;; ControlParameters required for runtime control
(assert
  (ite (or (> SwitchControlMode 0)
           (> CalibrateSensorsRebaseline 0)
           (> AdjustControlSetpoints 0))
       (= ControlParameters 1)
       (= ControlParameters 0)))

;; ControllerConfiguration required for mode switching & firmware
(assert
  (ite (or (> RestartSubsystemController 0)
           (> RunSystemSelfTests 0)
           (> UploadFirmware 0))
       (= ControllerConfiguration 1)
       (= ControllerConfiguration 0)))

;; ActuatorCommands required for physical actuation
(assert
  (ite (or (> RestartSubsystemController 0)
           (> SwitchControlMode 0))
       (= ActuatorCommands 1)
       (= ActuatorCommands 0)))

;; ------------------------------------------------------------
;; Calibration & Maintenance Assets (Optional-level)
;; ------------------------------------------------------------

;; CalibrationProfiles required only if calibration is enabled
(assert
  (ite (> CalibrateSensorsRebaseline 0)
       (= CalibrationProfiles 1)
       (= CalibrationProfiles 0)))

;; MaintenanceRecords required for system testing
(assert
  (ite (> ExportDownloadLogs 0)
       (= MaintenanceRecords 1)
       (= MaintenanceRecords 0)))

;; FirmwareImages required only for firmware upload
(assert
  (ite (> UploadFirmware 0)
       (= FirmwareImages 1)
       (= FirmwareImages 0)))

;; Permissions
;; =========================
;; ICS Scenario S4 Permissions (CRUD per asset)
;; =========================
(declare-fun SafetyLimits_Read () Bool)
(declare-fun SafetyLimits_Write () Bool)
(declare-fun SafetyLimits_Update () Bool)
(declare-fun SafetyLimits_Delete () Bool)

(declare-fun AlarmRules_Read () Bool)
(declare-fun AlarmRules_Write () Bool)
(declare-fun AlarmRules_Update () Bool)
(declare-fun AlarmRules_Delete () Bool)

(declare-fun DiagnosticData_Read () Bool)
(declare-fun DiagnosticData_Write () Bool)
(declare-fun DiagnosticData_Update () Bool)
(declare-fun DiagnosticData_Delete () Bool)

(declare-fun SystemLogs_Read () Bool)
(declare-fun SystemLogs_Write () Bool)
(declare-fun SystemLogs_Update () Bool)
(declare-fun SystemLogs_Delete () Bool)

(declare-fun ControllerConfiguration_Read () Bool)
(declare-fun ControllerConfiguration_Write () Bool)
(declare-fun ControllerConfiguration_Update () Bool)
(declare-fun ControllerConfiguration_Delete () Bool)

(declare-fun ControlParameters_Read () Bool)
(declare-fun ControlParameters_Write () Bool)
(declare-fun ControlParameters_Update () Bool)
(declare-fun ControlParameters_Delete () Bool)

(declare-fun ActuatorCommands_Read () Bool)
(declare-fun ActuatorCommands_Write () Bool)
(declare-fun ActuatorCommands_Update () Bool)
(declare-fun ActuatorCommands_Delete () Bool)

(declare-fun CalibrationProfiles_Read () Bool)
(declare-fun CalibrationProfiles_Write () Bool)
(declare-fun CalibrationProfiles_Update () Bool)
(declare-fun CalibrationProfiles_Delete () Bool)

(declare-fun MaintenanceRecords_Read () Bool)
(declare-fun MaintenanceRecords_Write () Bool)
(declare-fun MaintenanceRecords_Update () Bool)
(declare-fun MaintenanceRecords_Delete () Bool)

(declare-fun FirmwareImages_Read () Bool)
(declare-fun FirmwareImages_Write () Bool)
(declare-fun FirmwareImages_Update () Bool)
(declare-fun FirmwareImages_Delete () Bool)

;; ============================================================
;; ICS S4 — Hierarchical Permission Semantics
;; ============================================================

;; Delete ⇒ Update ⇒ Write ⇒ Read
(define-fun HierarchicalPermissions ((D Bool) (U Bool) (W Bool) (R Bool)) Bool
  (and (=> D U) (=> D W) (=> D R)
       (=> U W) (=> U R)
       (=> W R)))

;; Down-close: if Read is false, all higher permissions must be false
(define-fun Downclose ((D Bool) (U Bool) (W Bool) (R Bool)) Bool
  (and (=> (not R) (and (not W) (not U) (not D)))
       (=> (not W) (and (not U) (not D)))
       (=> (not U) (not D))))

;; Asset permission gate: asset ON ⇒ Read ON, asset OFF ⇒ all OFF
(define-fun AssetPermGate ((a Real) (R Bool) (W Bool) (U Bool) (D Bool)) Bool
  (ite (> a 0)
       (= R true)
       (and (= R false) (= W false) (= U false) (= D false))))

;; ============================================================
;; Apply Permission Gate to ICS S4 Assets
;; ============================================================

(assert (AssetPermGate SafetyLimits SafetyLimits_Read SafetyLimits_Write SafetyLimits_Update SafetyLimits_Delete))
(assert (AssetPermGate AlarmRules AlarmRules_Read AlarmRules_Write AlarmRules_Update AlarmRules_Delete))
(assert (AssetPermGate DiagnosticData DiagnosticData_Read DiagnosticData_Write DiagnosticData_Update DiagnosticData_Delete))
(assert (AssetPermGate SystemLogs SystemLogs_Read SystemLogs_Write SystemLogs_Update SystemLogs_Delete))
(assert (AssetPermGate ControllerConfiguration ControllerConfiguration_Read ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete))
(assert (AssetPermGate ControlParameters ControlParameters_Read ControlParameters_Write ControlParameters_Update ControlParameters_Delete))
(assert (AssetPermGate ActuatorCommands ActuatorCommands_Read ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete))
(assert (AssetPermGate CalibrationProfiles CalibrationProfiles_Read CalibrationProfiles_Write CalibrationProfiles_Update CalibrationProfiles_Delete))
(assert (AssetPermGate MaintenanceRecords MaintenanceRecords_Read MaintenanceRecords_Write MaintenanceRecords_Update MaintenanceRecords_Delete))
(assert (AssetPermGate FirmwareImages FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))

;; ============================================================
;; Enforce Hierarchy + Downclose for Each Asset
;; ============================================================

(assert (HierarchicalPermissions SafetyLimits_Delete SafetyLimits_Update SafetyLimits_Write SafetyLimits_Read))
(assert (HierarchicalPermissions AlarmRules_Delete AlarmRules_Update AlarmRules_Write AlarmRules_Read))
(assert (HierarchicalPermissions DiagnosticData_Delete DiagnosticData_Update DiagnosticData_Write DiagnosticData_Read))
(assert (HierarchicalPermissions SystemLogs_Delete SystemLogs_Update SystemLogs_Write SystemLogs_Read))
(assert (HierarchicalPermissions ControllerConfiguration_Delete ControllerConfiguration_Update ControllerConfiguration_Write ControllerConfiguration_Read))
(assert (HierarchicalPermissions ControlParameters_Delete ControlParameters_Update ControlParameters_Write ControlParameters_Read))
(assert (HierarchicalPermissions ActuatorCommands_Delete ActuatorCommands_Update ActuatorCommands_Write ActuatorCommands_Read))
(assert (HierarchicalPermissions CalibrationProfiles_Delete CalibrationProfiles_Update CalibrationProfiles_Write CalibrationProfiles_Read))
(assert (HierarchicalPermissions MaintenanceRecords_Delete MaintenanceRecords_Update MaintenanceRecords_Write MaintenanceRecords_Read))
(assert (HierarchicalPermissions FirmwareImages_Delete FirmwareImages_Update FirmwareImages_Write FirmwareImages_Read))

(assert (Downclose SafetyLimits_Delete SafetyLimits_Update SafetyLimits_Write SafetyLimits_Read))
(assert (Downclose AlarmRules_Delete AlarmRules_Update AlarmRules_Write AlarmRules_Read))
(assert (Downclose DiagnosticData_Delete DiagnosticData_Update DiagnosticData_Write DiagnosticData_Read))
(assert (Downclose SystemLogs_Delete SystemLogs_Update SystemLogs_Write SystemLogs_Read))
(assert (Downclose ControllerConfiguration_Delete ControllerConfiguration_Update ControllerConfiguration_Write ControllerConfiguration_Read))
(assert (Downclose ControlParameters_Delete ControlParameters_Update ControlParameters_Write ControlParameters_Read))
(assert (Downclose ActuatorCommands_Delete ActuatorCommands_Update ActuatorCommands_Write ActuatorCommands_Read))
(assert (Downclose CalibrationProfiles_Delete CalibrationProfiles_Update CalibrationProfiles_Write CalibrationProfiles_Read))
(assert (Downclose MaintenanceRecords_Delete MaintenanceRecords_Update MaintenanceRecords_Write MaintenanceRecords_Read))
(assert (Downclose FirmwareImages_Delete FirmwareImages_Update FirmwareImages_Write FirmwareImages_Read))

;; ============================================================
;; Minimum Permission Requirements for Operations
;; ============================================================

(define-fun NeedsRead  ((op Real) (p Bool)) Bool (=> (> op 0) p))
(define-fun NeedsWrite ((op Real) (p Bool)) Bool (=> (> op 0) p))

;; ------------------------------------------------------------
;; MUST Operations (Always Available)
;; ------------------------------------------------------------

(assert (NeedsRead ViewSafetyStatusAndAlarms SafetyLimits_Read))
(assert (NeedsRead ViewSafetyStatusAndAlarms AlarmRules_Read))

(assert (NeedsRead ViewDiagnostics DiagnosticData_Read))
(assert (NeedsRead ViewDiagnostics SystemLogs_Read))

(assert (NeedsWrite AcknowledgeAlarms SystemLogs_Write))

;; ------------------------------------------------------------
;; NICE Operations (Conditional)
;; ------------------------------------------------------------

(assert (NeedsWrite SwitchControlMode ControlParameters_Write))
(assert (NeedsWrite SwitchControlMode ControllerConfiguration_Write))

(assert (NeedsWrite AdjustControlSetpoints ControlParameters_Write))
(assert (NeedsRead  AdjustControlSetpoints SafetyLimits_Read))

(assert (NeedsWrite RestartSubsystemController ActuatorCommands_Write))
(assert (NeedsWrite RestartSubsystemController SystemLogs_Write))

(assert (NeedsWrite CalibrateSensorsRebaseline CalibrationProfiles_Write))
(assert (NeedsWrite CalibrateSensorsRebaseline DiagnosticData_Write))

;; ------------------------------------------------------------
;; OPTIONAL Operations (High Risk / Degradable)
;; ------------------------------------------------------------

(assert (NeedsRead  RunSystemSelfTests DiagnosticData_Read))
(assert (NeedsWrite RunSystemSelfTests MaintenanceRecords_Write))

(assert (NeedsRead  ExportDownloadLogs SystemLogs_Read))
(assert (NeedsWrite ExportDownloadLogs SystemLogs_Write))

(assert (NeedsWrite UploadFirmware FirmwareImages_Write))
(assert (NeedsWrite UploadFirmware ControllerConfiguration_Write))
(assert (NeedsWrite UploadFirmware ActuatorCommands_Write))

;; ============================================================
;; ICS S4 — Asset Permission Declarations and Sensitivity Ranges
;; ============================================================

;; ------------------------------------------------------------
;; SafetyLimits (Very High Criticality – Physical Safety)
;; ------------------------------------------------------------
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

;; -------------------------
;; AssetValue aggregation
;; -------------------------
(declare-fun AssetValue () Real)
(assert (and (>= AssetValue 0) (<= AssetValue 1)))

;; =========================
;; AssetValue for ICS Scenario S4 (Remote Maintenance)
;; =========================
(assert (= AssetValue
  (+ (* SafetyLimits SafetyLimitsSensitivity 0.20)
     (* ActuatorCommands ActuatorCommandsSensitivity 0.18)
     (* ControllerConfiguration ControllerConfigurationSensitivity 0.14)
     (* ControlParameters ControlParametersSensitivity 0.12)
     (* FirmwareImages FirmwareImagesSensitivity 0.10)
     (* AlarmRules AlarmRulesSensitivity 0.08)
     (* DiagnosticData DiagnosticDataSensitivity 0.07)
     (* CalibrationProfiles CalibrationProfilesSensitivity 0.05)
     (* SystemLogs SystemLogsSensitivity 0.04)
     (* MaintenanceRecords MaintenanceRecordsSensitivity 0.02))
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
(assert (ite (> NightTime 0) (and (= Iris 0) (= Face 0)) true))

;; -------------------------
;; Attacks: base likelihood + mitigation + residual risk
;; -------------------------
(declare-fun PImpersAttack () Real)
(declare-fun PReplayAttack () Real)
(declare-fun PSessionAttack () Real)

(assert (and (>= PImpersAttack 0) (<= PImpersAttack 1)))
(assert (and (>= PReplayAttack 0) (<= PReplayAttack 1)))
(assert (and (>= PSessionAttack 0) (<= PSessionAttack 1)))

; =========================================================
; Sensitivity analysis knobs (comment/uncomment ONE per knob)
; =========================================================

; --- Declare parameter knobs ---
(declare-const PImpers_Unfamiliar Real)        ; value used when UnfamiliarDevice > 0
(declare-const PSession_Unfamiliar_LB Real)    ; lower-bound used when UnfamiliarDevice > 0
(declare-const PSession_Vpn Real)              ; value used when VpnAccess > 0
(declare-const PReplay_Vpn Real)               ; value used when VpnAccess > 0

; Keep them in [0,1]
(assert (and (<= 0 PImpers_Unfamiliar)      (<= PImpers_Unfamiliar 1)))
(assert (and (<= 0 PSession_Unfamiliar_LB)  (<= PSession_Unfamiliar_LB 1)))
(assert (and (<= 0 PSession_Vpn)            (<= PSession_Vpn 1)))
(assert (and (<= 0 PReplay_Vpn)             (<= PReplay_Vpn 1)))

; ---------------------------------------------------------
; Choose ONE value for each knob (uncomment ONE line only)
; ---------------------------------------------------------

; ===== Knob 1: PImpers_Unfamiliar (base 0.7) =====
(assert (= PImpers_Unfamiliar 0.70)) ; baseline
; (assert (= PImpers_Unfamiliar 0.49)) ; -0.3
; (assert (= PImpers_Unfamiliar 0.56)) ; -0.2
; (assert (= PImpers_Unfamiliar 0.63)) ; -0.1
; (assert (= PImpers_Unfamiliar 0.77)) ; +0.1
; (assert (= PImpers_Unfamiliar 0.84)) ; +0.2
; (assert (= PImpers_Unfamiliar 0.91)) ; +0.3

; ===== Knob 3: PSession_Vpn (base 0.7) =====
(assert (= PSession_Vpn 0.70)) ; baseline
; (assert (= PSession_Vpn 0.49)) ; -0.3
; (assert (= PSession_Vpn 0.56)) ; -0.2
; (assert (= PSession_Vpn 0.63)) ; -0.1
; (assert (= PSession_Vpn 0.77)) ; +0.1
; (assert (= PSession_Vpn 0.84)) ; +0.2
; (assert (= PSession_Vpn 0.91)) ; +0.3

; ===== Knob 4: PReplay_Vpn (base 0.6) =====
(assert (= PReplay_Vpn 0.60)) ; baseline
; (assert (= PReplay_Vpn 0.42)) ; -0.3
; (assert (= PReplay_Vpn 0.48)) ; -0.2
; (assert (= PReplay_Vpn 0.54)) ; -0.1
; (assert (= PReplay_Vpn 0.66)) ; +0.1
; (assert (= PReplay_Vpn 0.72)) ; +0.2
; (assert (= PReplay_Vpn 0.78)) ; +0.3



; Unfamiliar device increases impersonation and session hijacking
(assert
  (ite (> UnfamiliarDevice 0)
       (and (= PImpersAttack PImpers_Unfamiliar) )
       true))

; VPN / external network increases hijacking and replay feasibility
(assert
  (ite (> VpnAccess 0)
       (and (= PSessionAttack PSession_Vpn)
            (= PReplayAttack PReplay_Vpn))
       true))


(declare-fun ImpersAttackImpact () Real)
(declare-fun ReplayAttackImpact () Real)
(declare-fun SessionAttackImpact () Real)

(assert (and (>= ImpersAttackImpact 0) (<= ImpersAttackImpact 1)))
(assert (and (>= ReplayAttackImpact 0) (<= ReplayAttackImpact 1)))
(assert (and (>= SessionAttackImpact 0) (<= SessionAttackImpact 1)))


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

(assert (= UseSumAgg true))

;; -------------------------
;; -------------------------
;; Authorization penalty
;; -------------------------
;; Permission level (cumulative): Read=0, Write=1, Update=2, Delete=3
(define-fun _lvlcost ((D Bool) (U Bool) (W Bool) (R Bool)) Real
  (ite D 3.0 (ite U 2.0 (ite W 1.0 (ite R 0.0 0.0)))))

;; ------------------------------------------------------------;; Reduction tightness (higher when permissions are reduced)
(define-fun _tight ((D Bool) (U Bool) (W Bool) (R Bool)) Real
  (- 1.0 (/ (_lvlcost D U W R) 3.0)))
;; ------------------------------------------------------------

(declare-fun PermPenaltyN () Real)

(assert (= PermPenaltyN
  (+ (* (_tight SafetyLimits_Delete SafetyLimits_Update SafetyLimits_Write SafetyLimits_Read)
        SafetyLimitsSensitivity SafetyLimits)
     (* (_tight ActuatorCommands_Delete ActuatorCommands_Update ActuatorCommands_Write ActuatorCommands_Read)
        ActuatorCommandsSensitivity ActuatorCommands)
     (* (_tight ControlParameters_Delete ControlParameters_Update ControlParameters_Write ControlParameters_Read)
        ControlParametersSensitivity ControlParameters)
     (* (_tight ControllerConfiguration_Delete ControllerConfiguration_Update ControllerConfiguration_Write ControllerConfiguration_Read)
        ControllerConfigurationSensitivity ControllerConfiguration)
     (* (_tight AlarmRules_Delete AlarmRules_Update AlarmRules_Write AlarmRules_Read)
        AlarmRulesSensitivity AlarmRules)
     (* (_tight FirmwareImages_Delete FirmwareImages_Update FirmwareImages_Write FirmwareImages_Read)
        FirmwareImagesSensitivity FirmwareImages)
     (* (_tight DiagnosticData_Delete DiagnosticData_Update DiagnosticData_Write DiagnosticData_Read)
        DiagnosticDataSensitivity DiagnosticData)
     (* (_tight SystemLogs_Delete SystemLogs_Update SystemLogs_Write SystemLogs_Read)
        SystemLogsSensitivity SystemLogs)
     (* (_tight CalibrationProfiles_Delete CalibrationProfiles_Update CalibrationProfiles_Write CalibrationProfiles_Read)
        CalibrationProfilesSensitivity CalibrationProfiles)
     (* (_tight MaintenanceRecords_Delete MaintenanceRecords_Update MaintenanceRecords_Write MaintenanceRecords_Read)
        MaintenanceRecordsSensitivity MaintenanceRecords)
)))

;; Normalize (ICS: only few assets dominate)
(declare-fun PermPenalty () Real)
(assert (= PermPenalty (_clamp01 (/ PermPenaltyN 10))))

;; ------------------------------------------------------------
;; Operation disable penalty (Must > Nice > Optional)
;; ------------------------------------------------------------

(declare-fun OpPenaltyRaw () Real)

(assert (= OpPenaltyRaw
  (+ ;; MUST (high penalty if disabled)
     (* 1.0 (- 1.0 ViewSafetyStatusAndAlarms))
     (* 1.0 (- 1.0 ViewDiagnostics))
     (* 1.0 (- 1.0 AcknowledgeAlarms))

     ;; NICE (moderate penalty)
     (* 0.7 (- 1.0 SwitchControlMode))
     (* 0.7 (- 1.0 AdjustControlSetpoints))
     (* 0.7 (- 1.0 RestartSubsystemController))
     (* 0.7 (- 1.0 CalibrateSensorsRebaseline))

     ;; OPTIONAL (cheap to disable)
     (* 0.4 (- 1.0 RunSystemSelfTests))
     (* 0.4 (- 1.0 ExportDownloadLogs))
     (* 0.4 (- 1.0 UploadFirmware))
)))

(declare-fun OpDisabledPenalty () Real)
(assert (= OpDisabledPenalty (_clamp01 (/ OpPenaltyRaw 7))))

;; ------------------------------------------------------------
;; Final authorization penalty (balanced)
;; ------------------------------------------------------------

(declare-fun AuthorizationPenalty () Real)
(assert (= AuthorizationPenalty
  (_clamp01 (+ (* 0.2 PermPenalty)
               (* 0.8 OpDisabledPenalty)))))

(assert (and (>= AuthorizationPenalty 0.0)
             (<= AuthorizationPenalty 1.0)))

;; ------------------------------------------------------------
;; Phase-2 utility (risk + asset + authorization)
;; ------------------------------------------------------------

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
(assert (= SmartCard 0))
(assert (= Token 1))
(assert (= SignCryp 0))
(assert (= GroupSign 0))
(assert (= RingSign 0))
(assert (= Iris 0))
(assert (= Face 0))
(assert (= Fingerprint 1))
(assert (= TwoFactor 1))
(assert (= Location 1))
(assert (= UnfamiliarDevice 1))
(assert (= VpnAccess 1))
(assert (= OffMainWindow 1))
(assert (= NightTime 0))

; --- Progressive RR upper bound  ---
(assert (< ResRisk 0.003066666667))
(assert (> ResRisk 0.0))
; --- BLOCKING CLAUSES (global enumeration) ---
(assert (or (not (= ViewSafetyStatusAndAlarms 1.0)) (not (= ViewDiagnostics 1.0)) (not (= AcknowledgeAlarms 1.0)) (not (= SwitchControlMode 1.0)) (not (= AdjustControlSetpoints 1.0)) (not (= RestartSubsystemController 1.0)) (not (= CalibrateSensorsRebaseline 1.0)) (not (= RunSystemSelfTests 0.0)) (not (= ExportDownloadLogs 1.0)) (not (= UploadFirmware 1.0)) (not SafetyLimits_Read) (not SafetyLimits_Write) (not SafetyLimits_Update) (not SafetyLimits_Delete) (not AlarmRules_Read) (not AlarmRules_Write) (not AlarmRules_Update) (not AlarmRules_Delete) (not DiagnosticData_Read) (not DiagnosticData_Write) (not DiagnosticData_Update) (not DiagnosticData_Delete) (not SystemLogs_Read) (not SystemLogs_Write) (not SystemLogs_Update) (not SystemLogs_Delete) (not ControllerConfiguration_Read) (not ControllerConfiguration_Write) (not ControllerConfiguration_Update) (not ControllerConfiguration_Delete) (not ControlParameters_Read) (not ControlParameters_Write) (not ControlParameters_Update) (not ControlParameters_Delete) (not ActuatorCommands_Read) (not ActuatorCommands_Write) (not ActuatorCommands_Update) (not ActuatorCommands_Delete) (not CalibrationProfiles_Read) (not CalibrationProfiles_Write) (not CalibrationProfiles_Update) (not CalibrationProfiles_Delete) (not MaintenanceRecords_Read) (not MaintenanceRecords_Write) (not MaintenanceRecords_Update) (not MaintenanceRecords_Delete) (not FirmwareImages_Read) (not FirmwareImages_Write) (not FirmwareImages_Update) (not FirmwareImages_Delete)))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.000600000001)) (not (= ViewDiagnostics 0.000600000001)) (not (= AcknowledgeAlarms 0.000600000001)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.000600000001)) (not (= RestartSubsystemController 0.000600000001)) (not (= CalibrateSensorsRebaseline 0.000600000001)) (not (= RunSystemSelfTests 0.000600000001)) (not (= ExportDownloadLogs 0.000600000001)) (not (= UploadFirmware 0.000600000001)) (not SafetyLimits_Read) (not SafetyLimits_Write) (not SafetyLimits_Update) (not SafetyLimits_Delete) (not AlarmRules_Read) (not AlarmRules_Write) (not AlarmRules_Update) (not AlarmRules_Delete) (not DiagnosticData_Read) (not DiagnosticData_Write) (not DiagnosticData_Update) (not DiagnosticData_Delete) (not SystemLogs_Read) (not SystemLogs_Write) SystemLogs_Update SystemLogs_Delete (not ControllerConfiguration_Read) (not ControllerConfiguration_Write) ControllerConfiguration_Update ControllerConfiguration_Delete (not ControlParameters_Read) (not ControlParameters_Write) (not ControlParameters_Update) (not ControlParameters_Delete) (not ActuatorCommands_Read) (not ActuatorCommands_Write) (not ActuatorCommands_Update) (not ActuatorCommands_Delete) (not CalibrationProfiles_Read) (not CalibrationProfiles_Write) CalibrationProfiles_Update CalibrationProfiles_Delete (not MaintenanceRecords_Read) (not MaintenanceRecords_Write) MaintenanceRecords_Update MaintenanceRecords_Delete (not FirmwareImages_Read) (not FirmwareImages_Write) FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.000324958125)) (not (= ViewDiagnostics 0.000324958125)) (not (= AcknowledgeAlarms 0.000324958125)) (not (= SwitchControlMode 0.000324958125)) (not (= AdjustControlSetpoints 0.0)) (not (= RestartSubsystemController 0.000924958126)) (not (= CalibrateSensorsRebaseline 0.0)) (not (= RunSystemSelfTests 0.0)) (not (= ExportDownloadLogs 0.000324958125)) (not (= UploadFirmware 0.000324958125)) (not SafetyLimits_Read) (not SafetyLimits_Write) (not SafetyLimits_Update) (not SafetyLimits_Delete) (not AlarmRules_Read) (not AlarmRules_Write) (not AlarmRules_Update) (not AlarmRules_Delete) (not DiagnosticData_Read) DiagnosticData_Write DiagnosticData_Update DiagnosticData_Delete (not SystemLogs_Read) (not SystemLogs_Write) (not SystemLogs_Update) (not SystemLogs_Delete) (not ControllerConfiguration_Read) (not ControllerConfiguration_Write) ControllerConfiguration_Update ControllerConfiguration_Delete (not ControlParameters_Read) (not ControlParameters_Write) (not ControlParameters_Update) (not ControlParameters_Delete) (not ActuatorCommands_Read) (not ActuatorCommands_Write) (not ActuatorCommands_Update) (not ActuatorCommands_Delete) CalibrationProfiles_Read CalibrationProfiles_Write CalibrationProfiles_Update CalibrationProfiles_Delete (not MaintenanceRecords_Read) MaintenanceRecords_Write MaintenanceRecords_Update MaintenanceRecords_Delete (not FirmwareImages_Read) (not FirmwareImages_Write) (not FirmwareImages_Update) (not FirmwareImages_Delete)))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.002266666667)) (not (= ViewDiagnostics 0.002266666667)) (not (= AcknowledgeAlarms 0.002266666667)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.002266666667)) (not (= RestartSubsystemController 0.002266666667)) (not (= CalibrateSensorsRebaseline 0.002266666667)) (not (= RunSystemSelfTests 0.002266666667)) (not (= ExportDownloadLogs 0.002266666667)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) (not SafetyLimits_Write) (not SafetyLimits_Update) (not SafetyLimits_Delete) (not AlarmRules_Read) AlarmRules_Write AlarmRules_Update AlarmRules_Delete (not DiagnosticData_Read) (not DiagnosticData_Write) (not DiagnosticData_Update) (not DiagnosticData_Delete) (not SystemLogs_Read) (not SystemLogs_Write) (not SystemLogs_Update) (not SystemLogs_Delete) (not ControllerConfiguration_Read) ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete (not ControlParameters_Read) (not ControlParameters_Write) (not ControlParameters_Update) (not ControlParameters_Delete) (not ActuatorCommands_Read) (not ActuatorCommands_Write) (not ActuatorCommands_Update) (not ActuatorCommands_Delete) (not CalibrationProfiles_Read) (not CalibrationProfiles_Write) (not CalibrationProfiles_Update) (not CalibrationProfiles_Delete) (not MaintenanceRecords_Read) (not MaintenanceRecords_Write) (not MaintenanceRecords_Update) (not MaintenanceRecords_Delete) FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.000266666667)) (not (= ViewDiagnostics 0.000266666667)) (not (= AcknowledgeAlarms 0.000266666667)) (not (= SwitchControlMode 0.000266666667)) (not (= AdjustControlSetpoints 0.000266666667)) (not (= RestartSubsystemController 0.002533333335)) (not (= CalibrateSensorsRebaseline 0.000266666667)) (not (= RunSystemSelfTests 0.000266666667)) (not (= ExportDownloadLogs 0.000266666667)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) SafetyLimits_Write SafetyLimits_Update SafetyLimits_Delete (not AlarmRules_Read) (not AlarmRules_Write) (not AlarmRules_Update) (not AlarmRules_Delete) (not DiagnosticData_Read) (not DiagnosticData_Write) (not DiagnosticData_Update) (not DiagnosticData_Delete) (not SystemLogs_Read) (not SystemLogs_Write) (not SystemLogs_Update) (not SystemLogs_Delete) (not ControllerConfiguration_Read) (not ControllerConfiguration_Write) (not ControllerConfiguration_Update) (not ControllerConfiguration_Delete) (not ControlParameters_Read) (not ControlParameters_Write) ControlParameters_Update ControlParameters_Delete (not ActuatorCommands_Read) (not ActuatorCommands_Write) (not ActuatorCommands_Update) (not ActuatorCommands_Delete) (not CalibrationProfiles_Read) (not CalibrationProfiles_Write) (not CalibrationProfiles_Update) CalibrationProfiles_Delete (not MaintenanceRecords_Read) (not MaintenanceRecords_Write) (not MaintenanceRecords_Update) (not MaintenanceRecords_Delete) FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.001372043011)) (not (= ViewDiagnostics 0.001372043011)) (not (= AcknowledgeAlarms 0.001372043011)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.001372043011)) (not (= RestartSubsystemController 0.001372043011)) (not (= CalibrateSensorsRebaseline 0.0)) (not (= RunSystemSelfTests 0.0)) (not (= ExportDownloadLogs 0.0)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) (not SafetyLimits_Write) (not SafetyLimits_Update) (not SafetyLimits_Delete) (not AlarmRules_Read) (not AlarmRules_Write) (not AlarmRules_Update) (not AlarmRules_Delete) (not DiagnosticData_Read) (not DiagnosticData_Write) (not DiagnosticData_Update) DiagnosticData_Delete (not SystemLogs_Read) (not SystemLogs_Write) SystemLogs_Update SystemLogs_Delete (not ControllerConfiguration_Read) ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete (not ControlParameters_Read) (not ControlParameters_Write) (not ControlParameters_Update) ControlParameters_Delete (not ActuatorCommands_Read) (not ActuatorCommands_Write) (not ActuatorCommands_Update) ActuatorCommands_Delete CalibrationProfiles_Read CalibrationProfiles_Write CalibrationProfiles_Update CalibrationProfiles_Delete MaintenanceRecords_Read MaintenanceRecords_Write MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.000066666668)) (not (= ViewDiagnostics 0.000066666668)) (not (= AcknowledgeAlarms 0.000066666668)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.000066666668)) (not (= RestartSubsystemController 0.000066666668)) (not (= CalibrateSensorsRebaseline 0.000066666668)) (not (= RunSystemSelfTests 0.0)) (not (= ExportDownloadLogs 0.000066666668)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) SafetyLimits_Write SafetyLimits_Update SafetyLimits_Delete (not AlarmRules_Read) AlarmRules_Write AlarmRules_Update AlarmRules_Delete (not DiagnosticData_Read) (not DiagnosticData_Write) DiagnosticData_Update DiagnosticData_Delete (not SystemLogs_Read) (not SystemLogs_Write) SystemLogs_Update SystemLogs_Delete (not ControllerConfiguration_Read) ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete (not ControlParameters_Read) (not ControlParameters_Write) (not ControlParameters_Update) (not ControlParameters_Delete) (not ActuatorCommands_Read) (not ActuatorCommands_Write) ActuatorCommands_Update ActuatorCommands_Delete (not CalibrationProfiles_Read) (not CalibrationProfiles_Write) CalibrationProfiles_Update CalibrationProfiles_Delete (not MaintenanceRecords_Read) MaintenanceRecords_Write MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.0125)) (not (= ViewDiagnostics 0.0125)) (not (= AcknowledgeAlarms 0.0125)) (not (= SwitchControlMode 0.001000000001)) (not (= AdjustControlSetpoints 0.0125)) (not (= RestartSubsystemController 0.0)) (not (= CalibrateSensorsRebaseline 0.0)) (not (= RunSystemSelfTests 0.001000000001)) (not (= ExportDownloadLogs 0.0125)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) SafetyLimits_Write SafetyLimits_Update SafetyLimits_Delete (not AlarmRules_Read) AlarmRules_Write AlarmRules_Update AlarmRules_Delete (not DiagnosticData_Read) (not DiagnosticData_Write) DiagnosticData_Update DiagnosticData_Delete (not SystemLogs_Read) (not SystemLogs_Write) (not SystemLogs_Update) (not SystemLogs_Delete) (not ControllerConfiguration_Read) (not ControllerConfiguration_Write) ControllerConfiguration_Update ControllerConfiguration_Delete (not ControlParameters_Read) (not ControlParameters_Write) ControlParameters_Update ControlParameters_Delete (not ActuatorCommands_Read) ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete CalibrationProfiles_Read CalibrationProfiles_Write CalibrationProfiles_Update CalibrationProfiles_Delete (not MaintenanceRecords_Read) (not MaintenanceRecords_Write) MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.0125)) (not (= ViewDiagnostics 0.0125)) (not (= AcknowledgeAlarms 0.0125)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.0125)) (not (= RestartSubsystemController 0.0)) (not (= CalibrateSensorsRebaseline 0.0125)) (not (= RunSystemSelfTests 0.007666666667)) (not (= ExportDownloadLogs 0.007666666667)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) SafetyLimits_Write SafetyLimits_Update SafetyLimits_Delete (not AlarmRules_Read) (not AlarmRules_Write) (not AlarmRules_Update) (not AlarmRules_Delete) (not DiagnosticData_Read) (not DiagnosticData_Write) (not DiagnosticData_Update) (not DiagnosticData_Delete) (not SystemLogs_Read) (not SystemLogs_Write) (not SystemLogs_Update) SystemLogs_Delete (not ControllerConfiguration_Read) (not ControllerConfiguration_Write) (not ControllerConfiguration_Update) (not ControllerConfiguration_Delete) (not ControlParameters_Read) (not ControlParameters_Write) (not ControlParameters_Update) (not ControlParameters_Delete) ActuatorCommands_Read ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete (not CalibrationProfiles_Read) (not CalibrationProfiles_Write) (not CalibrationProfiles_Update) (not CalibrationProfiles_Delete) (not MaintenanceRecords_Read) (not MaintenanceRecords_Write) MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.000333333334)) (not (= ViewDiagnostics 0.000333333334)) (not (= AcknowledgeAlarms 0.000333333334)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.000333333334)) (not (= RestartSubsystemController 0.0)) (not (= CalibrateSensorsRebaseline 0.0)) (not (= RunSystemSelfTests 0.000333333334)) (not (= ExportDownloadLogs 0.000333333334)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) (not SafetyLimits_Write) (not SafetyLimits_Update) (not SafetyLimits_Delete) (not AlarmRules_Read) AlarmRules_Write AlarmRules_Update AlarmRules_Delete (not DiagnosticData_Read) (not DiagnosticData_Write) (not DiagnosticData_Update) (not DiagnosticData_Delete) (not SystemLogs_Read) (not SystemLogs_Write) SystemLogs_Update SystemLogs_Delete (not ControllerConfiguration_Read) (not ControllerConfiguration_Write) ControllerConfiguration_Update ControllerConfiguration_Delete (not ControlParameters_Read) (not ControlParameters_Write) ControlParameters_Update ControlParameters_Delete ActuatorCommands_Read ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete CalibrationProfiles_Read CalibrationProfiles_Write CalibrationProfiles_Update CalibrationProfiles_Delete (not MaintenanceRecords_Read) (not MaintenanceRecords_Write) MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.0125)) (not (= ViewDiagnostics 0.02125)) (not (= AcknowledgeAlarms 0.0125)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.001333333334)) (not (= RestartSubsystemController 0.0)) (not (= CalibrateSensorsRebaseline 0.0)) (not (= RunSystemSelfTests 0.001333333334)) (not (= ExportDownloadLogs 0.001333333334)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) (not SafetyLimits_Write) (not SafetyLimits_Update) (not SafetyLimits_Delete) (not AlarmRules_Read) AlarmRules_Write AlarmRules_Update AlarmRules_Delete (not DiagnosticData_Read) (not DiagnosticData_Write) DiagnosticData_Update DiagnosticData_Delete (not SystemLogs_Read) (not SystemLogs_Write) SystemLogs_Update SystemLogs_Delete (not ControllerConfiguration_Read) ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete (not ControlParameters_Read) (not ControlParameters_Write) ControlParameters_Update ControlParameters_Delete ActuatorCommands_Read ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete CalibrationProfiles_Read CalibrationProfiles_Write CalibrationProfiles_Update CalibrationProfiles_Delete (not MaintenanceRecords_Read) (not MaintenanceRecords_Write) MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.998866666667)) (not (= ViewDiagnostics 0.998866666667)) (not (= AcknowledgeAlarms 0.998866666667)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.001133333334)) (not (= RestartSubsystemController 0.0)) (not (= CalibrateSensorsRebaseline 0.998866666667)) (not (= RunSystemSelfTests 0.0)) (not (= ExportDownloadLogs 0.0)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) SafetyLimits_Write SafetyLimits_Update SafetyLimits_Delete (not AlarmRules_Read) (not AlarmRules_Write) (not AlarmRules_Update) (not AlarmRules_Delete) (not DiagnosticData_Read) (not DiagnosticData_Write) (not DiagnosticData_Update) (not DiagnosticData_Delete) (not SystemLogs_Read) (not SystemLogs_Write) (not SystemLogs_Update) (not SystemLogs_Delete) ControllerConfiguration_Read ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete (not ControlParameters_Read) (not ControlParameters_Write) (not ControlParameters_Update) (not ControlParameters_Delete) ActuatorCommands_Read ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete (not CalibrationProfiles_Read) (not CalibrationProfiles_Write) (not CalibrationProfiles_Update) CalibrationProfiles_Delete MaintenanceRecords_Read MaintenanceRecords_Write MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.010666666667)) (not (= ViewDiagnostics 0.010666666667)) (not (= AcknowledgeAlarms 0.010666666667)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.0)) (not (= RestartSubsystemController 0.0)) (not (= CalibrateSensorsRebaseline 0.010666666667)) (not (= RunSystemSelfTests 0.0)) (not (= ExportDownloadLogs 0.010666666667)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) SafetyLimits_Write SafetyLimits_Update SafetyLimits_Delete (not AlarmRules_Read) AlarmRules_Write AlarmRules_Update AlarmRules_Delete (not DiagnosticData_Read) (not DiagnosticData_Write) DiagnosticData_Update DiagnosticData_Delete (not SystemLogs_Read) (not SystemLogs_Write) (not SystemLogs_Update) (not SystemLogs_Delete) ControllerConfiguration_Read ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete (not ControlParameters_Read) ControlParameters_Write ControlParameters_Update ControlParameters_Delete ActuatorCommands_Read ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete (not CalibrationProfiles_Read) (not CalibrationProfiles_Write) CalibrationProfiles_Update CalibrationProfiles_Delete (not MaintenanceRecords_Read) (not MaintenanceRecords_Write) MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.008333333334)) (not (= ViewDiagnostics 0.008333333334)) (not (= AcknowledgeAlarms 0.008333333334)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.008333333334)) (not (= RestartSubsystemController 0.0)) (not (= CalibrateSensorsRebaseline 0.0)) (not (= RunSystemSelfTests 0.0)) (not (= ExportDownloadLogs 0.0)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) SafetyLimits_Write SafetyLimits_Update SafetyLimits_Delete (not AlarmRules_Read) (not AlarmRules_Write) (not AlarmRules_Update) (not AlarmRules_Delete) (not DiagnosticData_Read) (not DiagnosticData_Write) (not DiagnosticData_Update) (not DiagnosticData_Delete) (not SystemLogs_Read) (not SystemLogs_Write) SystemLogs_Update SystemLogs_Delete ControllerConfiguration_Read ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete (not ControlParameters_Read) (not ControlParameters_Write) (not ControlParameters_Update) (not ControlParameters_Delete) ActuatorCommands_Read ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete CalibrationProfiles_Read CalibrationProfiles_Write CalibrationProfiles_Update CalibrationProfiles_Delete MaintenanceRecords_Read MaintenanceRecords_Write MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.005666666666)) (not (= ViewDiagnostics 0.005666666666)) (not (= AcknowledgeAlarms 0.005666666666)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.0)) (not (= RestartSubsystemController 0.0)) (not (= CalibrateSensorsRebaseline 0.0)) (not (= RunSystemSelfTests 0.0)) (not (= ExportDownloadLogs 0.0)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) (not SafetyLimits_Write) (not SafetyLimits_Update) (not SafetyLimits_Delete) (not AlarmRules_Read) (not AlarmRules_Write) (not AlarmRules_Update) AlarmRules_Delete (not DiagnosticData_Read) (not DiagnosticData_Write) (not DiagnosticData_Update) DiagnosticData_Delete (not SystemLogs_Read) (not SystemLogs_Write) SystemLogs_Update SystemLogs_Delete ControllerConfiguration_Read ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete ControlParameters_Read ControlParameters_Write ControlParameters_Update ControlParameters_Delete ActuatorCommands_Read ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete CalibrationProfiles_Read CalibrationProfiles_Write CalibrationProfiles_Update CalibrationProfiles_Delete MaintenanceRecords_Read MaintenanceRecords_Write MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.001999999999)) (not (= ViewDiagnostics 0.001999999999)) (not (= AcknowledgeAlarms 0.001999999999)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.0)) (not (= RestartSubsystemController 0.0)) (not (= CalibrateSensorsRebaseline 0.0)) (not (= RunSystemSelfTests 0.0)) (not (= ExportDownloadLogs 0.0)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) SafetyLimits_Write SafetyLimits_Update SafetyLimits_Delete (not AlarmRules_Read) AlarmRules_Write AlarmRules_Update AlarmRules_Delete (not DiagnosticData_Read) DiagnosticData_Write DiagnosticData_Update DiagnosticData_Delete (not SystemLogs_Read) (not SystemLogs_Write) SystemLogs_Update SystemLogs_Delete ControllerConfiguration_Read ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete ControlParameters_Read ControlParameters_Write ControlParameters_Update ControlParameters_Delete ActuatorCommands_Read ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete CalibrationProfiles_Read CalibrationProfiles_Write CalibrationProfiles_Update CalibrationProfiles_Delete MaintenanceRecords_Read MaintenanceRecords_Write MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))
(assert (or (not (= ViewSafetyStatusAndAlarms 0.013872043011)) (not (= ViewDiagnostics 0.0125)) (not (= AcknowledgeAlarms 0.0125)) (not (= SwitchControlMode 0.0)) (not (= AdjustControlSetpoints 0.0)) (not (= RestartSubsystemController 0.0)) (not (= CalibrateSensorsRebaseline 0.0)) (not (= RunSystemSelfTests 0.0)) (not (= ExportDownloadLogs 0.0)) (not (= UploadFirmware 0.0)) (not SafetyLimits_Read) SafetyLimits_Write SafetyLimits_Update SafetyLimits_Delete (not AlarmRules_Read) AlarmRules_Write AlarmRules_Update AlarmRules_Delete (not DiagnosticData_Read) (not DiagnosticData_Write) DiagnosticData_Update DiagnosticData_Delete (not SystemLogs_Read) (not SystemLogs_Write) SystemLogs_Update SystemLogs_Delete ControllerConfiguration_Read ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete ControlParameters_Read ControlParameters_Write ControlParameters_Update ControlParameters_Delete ActuatorCommands_Read ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete CalibrationProfiles_Read CalibrationProfiles_Write CalibrationProfiles_Update CalibrationProfiles_Delete MaintenanceRecords_Read MaintenanceRecords_Write MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete))

(check-sat)
(get-value (ResRisk AssetValue AuthorizationPenalty PermPenalty ViewSafetyStatusAndAlarms ViewDiagnostics AcknowledgeAlarms SwitchControlMode AdjustControlSetpoints RestartSubsystemController CalibrateSensorsRebaseline RunSystemSelfTests ExportDownloadLogs UploadFirmware SafetyLimits_Read SafetyLimits_Write SafetyLimits_Update SafetyLimits_Delete AlarmRules_Read AlarmRules_Write AlarmRules_Update AlarmRules_Delete DiagnosticData_Read DiagnosticData_Write DiagnosticData_Update DiagnosticData_Delete SystemLogs_Read SystemLogs_Write SystemLogs_Update SystemLogs_Delete ControllerConfiguration_Read ControllerConfiguration_Write ControllerConfiguration_Update ControllerConfiguration_Delete ControlParameters_Read ControlParameters_Write ControlParameters_Update ControlParameters_Delete ActuatorCommands_Read ActuatorCommands_Write ActuatorCommands_Update ActuatorCommands_Delete CalibrationProfiles_Read CalibrationProfiles_Write CalibrationProfiles_Update CalibrationProfiles_Delete MaintenanceRecords_Read MaintenanceRecords_Write MaintenanceRecords_Update MaintenanceRecords_Delete FirmwareImages_Read FirmwareImages_Write FirmwareImages_Update FirmwareImages_Delete SafetyLimits AlarmRules DiagnosticData SystemLogs ControllerConfiguration ControlParameters ActuatorCommands CalibrationProfiles MaintenanceRecords FirmwareImages PRiskPImpersAttack PRiskReplayAttack PRiskSessionAttack TotalRisk PImpersAttack PReplayAttack PSessionAttack FPImpersAttack FPReplayAttack FPSessionAttack))
