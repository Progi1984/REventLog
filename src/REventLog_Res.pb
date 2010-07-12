;- Constantes
#EVENTLOG_SUCCESS               = 0
#EVENTLOG_ERROR_TYPE            = 1
#EVENTLOG_WARNING_TYPE          = 2
#EVENTLOG_INFORMATION_TYPE      = 4
#EVENTLOG_AUDIT_SUCCESS         = 8
#EVENTLOG_AUDIT_FAILURE         = $10
#EVENTLOG_SEQUENTIAL_READ       = $1
#EVENTLOG_SEEK_READ             = $2
#EVENTLOG_FORWARDS_READ         = $4
#EVENTLOG_BACKWARDS_READ        = $8

Enumeration 1
  #REVENTLOG_SUCCESS
  #REVENTLOG_ERROR_BADLOGNAME
  
  #REVENTLOG_ERROR_LAST
EndEnumeration

;- Structures
Structure S_REventLog
  hEventLog.l
  CurItemLog.l
  LogName.s
EndStructure

;- Macros
Macro REVENTLOG_ID(EventLog)
  Object_GetObject(REventLogObjects, EventLog)
EndMacro
Macro REVENTLOG_IS(EventLog)
  Object_IsObject(REventLogObjects, EventLog) 
EndMacro
Macro REVENTLOG_NEW(EventLog)
  Object_GetOrAllocateID(REventLogObjects, EventLog)
EndMacro
Macro REVENTLOG_FREEID(EventLog)
  If EventLog <> #PB_Any And REVENTLOG_IS(EventLog) = #True
    Object_FreeID(REventLogObjects, EventLog)
  EndIf
EndMacro
Macro REVENTLOG_INITIALIZE(hCloseFunction)
  Object_Init(SizeOf(S_REventLog), 1, hCloseFunction)
EndMacro



; IDE Options = PureBasic 4.10 (Windows - x86)
; CursorPosition = 16
; Folding = D+