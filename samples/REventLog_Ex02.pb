;================================
; Project   REventLog
; Title     Write EventLog
; Author    Progi1984
; Date      11/10/2007
; Notes     
;================================

Global EventLogName.s = "REventLog"
Global DLLPath.s      = GetCurrentDirectory() + "REventLogTest.dll"

  REventLog_Create(2)
  Debug "===== Log ====="
  Debug REventLog_CreateLog(2, EventLogName)

  Debug "===== Source <Application0> ====="
  Debug REventLog_CreateSource(2, "Application0")
  Debug REventLog_SetDLLCategory(2, "Application0", 5, DLLPath)
  Debug REventLog_SetDLLEventMessage(2, "Application0", DLLPath)

  Debug "===== Source <Application1> ====="
  Debug REventLog_CreateSource(2, "Application1")
  Debug REventLog_SetDLLCategory(2, "Application1", 3, DLLPath)
  Debug REventLog_SetDLLEventMessage(2, "Application1", DLLPath)

  Debug "===== Source <Application2> ====="
  Debug REventLog_CreateSource(2, "Application2")
  Debug REventLog_SetDLLCategory(2, "Application2", 1, DLLPath)
  Debug REventLog_SetDLLEventMessage(2, "Application2", DLLPath)

  Debug "===== Reports ====="
  Debug REventLog_Report(2, "Application0",  1,  #EVENTLOG_SUCCESS,          1000,  "")
  Debug REventLog_Report(2, "Application0",  2,  #EVENTLOG_ERROR_TYPE,       1000,  "")
  Debug REventLog_Report(2, "Application0",  3,  #EVENTLOG_WARNING_TYPE,     1000,  "")
  Debug REventLog_Report(2, "Application0",  4,  #EVENTLOG_INFORMATION_TYPE, 1000,  "")
  Debug REventLog_Report(2, "Application0",  5,  #EVENTLOG_SUCCESS,          1000,  "")
  Debug REventLog_Report(2, "Application1",  1,  #EVENTLOG_ERROR_TYPE,       1001,  "AZERTY&ι")
  Debug REventLog_Report(2, "Application1",  2,  #EVENTLOG_WARNING_TYPE,     1001,  "ωτ")
  Debug REventLog_Report(2, "Application1",  3,  #EVENTLOG_INFORMATION_TYPE, 1001,  "Yop")
  Debug REventLog_Report(2, "Application2",  1,  #EVENTLOG_INFORMATION_TYPE, 1002,  "Test Message"+Chr(13)+Chr(10)+" Following by what you want=>")






; REvent
; Source : Core
; Category : Cat100
; Category : Cat020
; Category : Cat003
; Source : Plugins
; Source : Others
