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
  sLogName.s
EndStructure

;- Macros
Macro REVENTLOG_ID(object)
  Object_GetObject(REventLogObjects, object)
EndMacro
Macro REVENTLOG_IS(object)
  Object_IsObject(REventLogObjects, object)
EndMacro
Macro REVENTLOG_NEW(object)
  Object_GetOrAllocateID(REventLogObjects, object)
EndMacro
Macro REVENTLOG_FREEID(object)
  If object <> #PB_Any And REVENTLOG_IS(object) = #True
    Object_FreeID(REventLogObjects, object)
  EndIf
EndMacro
Macro REVENTLOG_INITIALIZE(PtrCloseFn)
  Object_Init(SizeOf(S_REventLog), 1, PtrCloseFn)
EndMacro




