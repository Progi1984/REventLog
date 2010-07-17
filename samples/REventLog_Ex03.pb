;================================
; Project   REventLog
; Title     Exists or not
; Author    Progi1984
; Date      11/10/2007
; Notes     
;================================

Global EventLogName.s = "REventLog"
Global DLLPath.s      = GetCurrentDirectory() + "REventLogTest.dll"

  Debug "===== ExistsLog ====="
  Debug REventLog_ExistsLog(EventLogName)
  Debug "===== ExistsSource ====="
  Debug REventLog_ExistsSource(EventLogName, "Application0")
  Debug "===== ExistsDLLCategory ====="
  Debug REventLog_ExistsDLLCategory(EventLogName, "Application0")
  Debug "===== ExistsDLLEventMessage ====="
  Debug REventLog_ExistsDLLEventMessage(EventLogName, "Application0")
