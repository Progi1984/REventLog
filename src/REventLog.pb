  ; Macros for double quotes
  Macro DQuote
    "
  EndMacro
  ; Define the ImportLib
  CompilerSelect #PB_Compiler_Thread
    CompilerCase #False ;{ THREADSAFE : OFF
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux         : #Power_ObjectManagerLib = #PB_Compiler_Home + "compilers/objectmanager.a"
        CompilerCase #PB_OS_Windows   : #Power_ObjectManagerLib = #PB_Compiler_Home + "compilers\ObjectManager.lib"
      CompilerEndSelect
    ;}
    CompilerCase #True ;{ THREADSAFE : ON
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux         : #Power_ObjectManagerLib = #PB_Compiler_Home + "compilers/objectmanagerthread.a"
        CompilerCase #PB_OS_Windows   : #Power_ObjectManagerLib = #PB_Compiler_Home + "compilers\ObjectManagerThread.lib"
      CompilerEndSelect
    ;}
  CompilerEndSelect
  ; Macro ImportFunction
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux ;{
      Macro ImportFunction(Name, Param)
        DQuote#Name#DQuote
      EndMacro
    ;}
    CompilerCase #PB_OS_Windows ;{
      Macro ImportFunction(Name, Param)
        DQuote _#Name@Param#DQuote
      EndMacro
    ;}
  CompilerEndSelect
  ; Import the ObjectManager library
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux : ImportC #Power_ObjectManagerLib
    CompilerCase #PB_OS_Windows : Import #Power_ObjectManagerLib
  CompilerEndSelect
    Object_GetOrAllocateID(Objects, Object.l) As ImportFunction(PB_Object_GetOrAllocateID, 8)
    Object_GetObject(Objects, Object.l) As ImportFunction(PB_Object_GetObject,8)
    Object_IsObject(Objects, Object.l) As ImportFunction(PB_Object_IsObject,8)
    Object_EnumerateAll(Objects, ObjectEnumerateAllCallback, *VoidData) As ImportFunction(PB_Object_EnumerateAll,12)
    Object_EnumerateStart(Objects) As ImportFunction(PB_Object_EnumerateStart,4)
    Object_EnumerateNext(Objects, *object.Long) As ImportFunction(PB_Object_EnumerateNext,8)
    Object_EnumerateAbort(Objects) As ImportFunction(PB_Object_EnumerateAbort,4)
    Object_FreeID(Objects, Object.l) As ImportFunction(PB_Object_FreeID,8)
    Object_Init(StructureSize.l, IncrementStep.l, ObjectFreeFunction) As ImportFunction(PB_Object_Init,12)
    Object_GetThreadMemory(MemoryID.l) As ImportFunction(PB_Object_GetThreadMemory,4)
    Object_InitThreadMemory(Size.l, InitFunction, EndFunction) As ImportFunction(PB_Object_InitThreadMemory,12)
  EndImport

;{ Registry
  Procedure.l RMisc_KeyExists(topKey, sKeyName.s, ComputerName.s="")
   Protected GetHandle.l, hKey.l, lReturnCode.l, lhRemoteRegistry.l, KeyExists.b
    If Left(sKeyName, 1) = "\"
      sKeyName = Right(sKeyName, Len(sKeyName) - 1)
    EndIf
   
    If ComputerName = ""
      GetHandle = RegOpenKeyEx_(topKey, sKeyName, 0, #KEY_ALL_ACCESS, @hKey)
    Else
      lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry)
      GetHandle = RegOpenKeyEx_(lhRemoteRegistry, sKeyName, 0, #KEY_ALL_ACCESS, @hKey)
    EndIf
   
    If GetHandle = #ERROR_SUCCESS
      KeyExists = #True
    Else
      KeyExists = #False
    EndIf
    ProcedureReturn KeyExists
  EndProcedure
  Procedure.s RMisc_ReadRegKey(OpenKey.l, SubKey.s, ValueName.s)
    Protected hKey.l = 0
    Protected KeyValue.s = Space(255)
    Protected Datasize.l = 255
    If RegOpenKeyEx_(OpenKey, SubKey, 0, #KEY_READ, @hKey)
      KeyValue = ""
    Else
      If RegQueryValueEx_(hKey, ValueName, 0, 0, @KeyValue, @Datasize)
        KeyValue = ""
      Else 
        KeyValue = Left(KeyValue, Datasize - SizeOf(Character))
      EndIf
      RegCloseKey_(hKey)
    EndIf
    ProcedureReturn KeyValue
  EndProcedure 
  Procedure.l RMisc_WriteRegKey(TopKey, sKeyName.s)
    Protected lpSecurityAttributes.SECURITY_ATTRIBUTES
    Protected GetHandle.l, hNewKey.l, lReturnCode.l, lhRemoteRegistry.l
    Protected CreateKey.b
    Protected ComputerName.s = ""
    If Left(sKeyName, 1) = "\"
      sKeyName = Right(sKeyName, Len(sKeyName) - 1)
    EndIf
    If ComputerName = ""
      GetHandle = RegCreateKeyEx_(topKey, sKeyName, 0, 0, #REG_OPTION_NON_VOLATILE, #KEY_ALL_ACCESS, @lpSecurityAttributes, @hNewKey, @GetHandle)
    Else
      lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry)
      GetHandle = RegCreateKeyEx_(lhRemoteRegistry, sKeyName, 0, 0, #REG_OPTION_NON_VOLATILE, #KEY_ALL_ACCESS, @lpSecurityAttributes, @hNewKey, @GetHandle)
    EndIf
   
    If GetHandle = #ERROR_SUCCESS
      GetHandle = RegCloseKey_(hNewKey)
      CreateKey = #True
    Else
      CreateKey = #False
    EndIf
    ProcedureReturn CreateKey
  EndProcedure
  Procedure.l RMisc_SetValue(topKey, sKeyName.s, sValueName.s, vValue.s, lType, ComputerName.s="")
    Protected lpData.s
    Protected GetHandle.l, hKey.l, lReturnCode.l, lhRemoteRegistry.l, lpcbData.l, lValue.l
    If Left(sKeyName, 1) = "\"
      sKeyName = Right(sKeyName, Len(sKeyName) - 1)
    EndIf
    If ComputerName = ""
      GetHandle = RegOpenKeyEx_(topKey, sKeyName, 0, #KEY_ALL_ACCESS, @hKey)
    Else
      lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry)
      GetHandle = RegOpenKeyEx_(lhRemoteRegistry, sKeyName, 0, #KEY_ALL_ACCESS, @hKey)
    EndIf
    If GetHandle = #ERROR_SUCCESS
      lpcbData = 255
      lpData = Space(255)
     
      Select lType
        Case #REG_SZ
          GetHandle = RegSetValueEx_(hKey, sValueName, 0, #REG_SZ, @vValue, (Len(vValue) + 1)* SizeOf(Character))
        Case #REG_DWORD
          lValue = Val(vValue)
          GetHandle = RegSetValueEx_(hKey, sValueName, 0, #REG_DWORD, @lValue, 4)
      EndSelect
     
      RegCloseKey_(hKey)
      ProcedureReturn #True
    Else
      RegCloseKey_(hKey)
      ProcedureReturn #False
    EndIf
  EndProcedure
  Procedure.l RMisc_WriteMultiLineString(TopKey.l, KeyName.s, ValueName.s, Value.s); write a StringField, separate with #LF$, to specified ValueName
  Protected Result.l, hKey.l, Error.l, plDisposition.l, Mem.l, i.L, NumLF.L, LFPos.L
  ;Reg_ResetError()

  If Right(KeyName, 1) = "\" : KeyName = Left(KeyName, Len(KeyName) - 1) : EndIf
  Error = RegCreateKeyEx_(topKey, KeyName, 0, 0, #REG_OPTION_NON_VOLATILE, #KEY_ALL_ACCESS, 0, @hKey, @plDisposition)
  If Error = #ERROR_SUCCESS
    Mem = AllocateMemory((MemoryStringLength(@Value) + 2) * SizeOf(Character))
    If Mem
      PokeS(Mem, Value)
      NumLF = CountString(Value, #LF$)
      If NumLF
        For i = 1 To NumLF
          LFPos = FindString(Value, #LF$, LFPos + 1)
          PokeB(Mem + LFPos * SizeOf(Character) - SizeOf(Character), 0)
        Next i
      EndIf
      Error = RegSetValueEx_(hKey, ValueName, 0, #REG_MULTI_SZ, Mem, MemorySize(Mem))
      If Error = #ERROR_SUCCESS
        Result = #True
      Else
        ;Reg_SetLastError(Error)
      EndIf
      FreeMemory(Mem)
    Else
      ;Reg_ErrorNr = -1
      ;Reg_ErrorMsg = "can't allocate memory"
    EndIf
  Else
    ;Reg_SetLastError(Error)
  EndIf
  If hKey : RegCloseKey_(hKey) : EndIf
  ProcedureReturn Result
EndProcedure 
  Procedure.s RMisc_ReadMultiLineString(TopKey.l, KeyName.s, ValueName.s); returns a StringField, separate with #LF$, from specified ValueName
    Protected Result.s, hKey.l, *lpData.l, lpcbData.l, Error.l, Pos.l
    
    If Right(KeyName, 1) = "\"
      KeyName = Left(KeyName, Len(KeyName) * SizeOf(Character) - SizeOf(Character))
    EndIf
    Error = RegOpenKeyEx_(topKey, @KeyName, 0, #KEY_ALL_ACCESS, @hKey)
    If Error = #ERROR_SUCCESS
      RegQueryValueEx_(hKey, @ValueName, 0, 0, @*lpData, @lpcbData)
      If lpcbData
        *lpData = AllocateMemory(lpcbData)
        If *lpData
          Error = RegQueryValueEx_(hKey, @ValueName, 0, 0, *lpData, @lpcbData)
          If Error = #ERROR_SUCCESS
            While Pos <> lpcbData
              Result + PeekS(*lpData + Pos) + #LF$
              Pos = Len(Result) * SizeOf(Character)
            Wend
            Result = Left(Result, (Len(Result) * SizeOf(Character) - SizeOf(Character))/SizeOf(Character))
            FreeMemory(*lpData)
          EndIf
        EndIf
      EndIf
    EndIf
    If hKey
      RegCloseKey_(hKey)
    EndIf
    ProcedureReturn Result
  EndProcedure
  Procedure.s RMisc_ReadMessageTable(DLLPath.s, MessageId.l, LanguageID.l = 0)
    Protected Message.s
    Protected hDLL.l, Buffer.l
    hDLL = LoadLibrary_(DLLPath)
    If hDLL
      FormatMessage_(#FORMAT_MESSAGE_ALLOCATE_BUFFER|#FORMAT_MESSAGE_FROM_SYSTEM|#FORMAT_MESSAGE_FROM_HMODULE,hDLL.l,MessageId,LanguageID,@Buffer.l,0,#Null)
      FreeLibrary_(hDLL)
      If Buffer
        Message = PeekS(Buffer)
        LocalFree_(Buffer)
        ProcedureReturn Message
      EndIf
    EndIf
  EndProcedure
;}

ProcedureDLL.l REventLog_Free(ID.l)
  Global REventLogObjects
  Protected *RObject.S_REventLog
  If ID <> #PB_Any And REVENTLOG_IS(ID)
    *RObject = REVENTLOG_ID(ID)
  EndIf
  If *RObject
    CloseEventLog_(*RObject\hEventLog)
    REVENTLOG_FREEID(ID)
  EndIf
  ProcedureReturn #True
EndProcedure
ProcedureDLL.l REventLog_Init()
  Global REventLogObjects
  REventLogObjects = REVENTLOG_INITIALIZE(@REventLog_Free())
EndProcedure
ProcedureDLL.l REventLog_End()
EndProcedure
ProcedureDLL.l REventLog_IsEventLog(ID.l)
  ProcedureReturn REVENTLOG_IS(ID)
EndProcedure
ProcedureDLL.l REventLog_Create(ID.l)
  Protected *RObject.S_REventLog = REVENTLOG_NEW(ID)
  With *RObject
    \hEventLog = -1
  EndWith
  ProcedureReturn *RObject
EndProcedure
ProcedureDLL.l REventLog_Load(ID.l, sFilename.s, sName.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      \hEventLog  = OpenBackupEventLog_(@"", @sFilename)
      \sLogName   = sName
      ProcedureReturn \hEventLog
    EndWith
  EndIf
  ProcedureReturn #False
EndProcedure
ProcedureDLL.l REventLog_Open(ID.l, sName.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      \hEventLog  = OpenEventLog_(0, sName)
      \sLogName   = sName
      ProcedureReturn \hEventLog
    EndWith
  EndIf
  ProcedureReturn #False
EndProcedure
ProcedureDLL.l REventLog_Save(ID.l, sFilename.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      ProcedureReturn BackupEventLog_(\hEventLog, sFilename)
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_Clear(ID.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      ClearEventLog_(\hEventLog, #Null)
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_CountEvents(ID.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected plNumRecords.l
  If *RObject
    With *RObject
      plNumRecords = 0
      If \hEventLog
        If GetNumberOfEventLogRecords_(\hEventLog, @plNumRecords)
          ProcedureReturn plNumRecords
        Else
          ProcedureReturn -1
        EndIf
      Else
        ProcedureReturn -1
    EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_GetType(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected pEventRecord.EVENTLOGRECORD
  Protected plBytesToRead.l, plBytesRead.l = 0, plMinBytesToRead.l = 0
  Protected *pMemBuffer
  If *RObject
    With *RObject
      If \hEventLog
        plBytesToRead = 5000 ; SizeOf(EVENTLOGRECORD)
        If *pMemBuffer
          FreeMemory(*pMemBuffer)
        EndIf
        *pMemBuffer = AllocateMemory(plBytesToRead)
        ReadEventLog_(\hEventLog,#EVENTLOG_FORWARDS_READ|#EVENTLOG_SEEK_READ, Num, *pMemBuffer, plBytesToRead, @plBytesRead, @plMinBytesToRead)
        CopyMemory(*pMemBuffer, pEventRecord, SizeOf(EVENTLOGRECORD))
        ProcedureReturn pEventRecord\EventType
      Else
        ProcedureReturn -1
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_GetEventID(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected pEventRecord.EVENTLOGRECORD
  Protected plBytesToRead.l, plBytesRead.l = 0, plMinBytesToRead.l = 0
  Protected *pMemBuffer
  If *RObject
    With *RObject
      If \hEventLog
        plBytesToRead = 5000 ; SizeOf(EVENTLOGRECORD)
        If *pMemBuffer
          FreeMemory(*pMemBuffer)
        EndIf
        *pMemBuffer = AllocateMemory(plBytesToRead)
        ReadEventLog_(\hEventLog,#EVENTLOG_FORWARDS_READ|#EVENTLOG_SEEK_READ, Num, *pMemBuffer, plBytesToRead, @plBytesRead, @plMinBytesToRead)
        CopyMemory(*pMemBuffer, pEventRecord, SizeOf(EVENTLOGRECORD))
        ProcedureReturn pEventRecord\EventID
      Else
        ProcedureReturn -1
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_GetTimeSubmitted(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected pEventRecord.EVENTLOGRECORD
  Protected plBytesToRead.l, plTimeBias.l, plBytesRead.l, plMinBytesToRead.l
  Protected *pMemBuffer
  Protected pSystemTime.SYSTEMTIME
  Protected pLocalTime.SYSTEMTIME
  If *RObject
    With *RObject
      If \hEventLog
        plBytesToRead     = 5000 ; SizeOf(EVENTLOGRECORD)
        plBytesRead       = 0
        plMinBytesToRead  = 0
        If *pMemBuffer
          FreeMemory(*pMemBuffer)
        EndIf
        *pMemBuffer = AllocateMemory(plBytesToRead)
        ReadEventLog_(\hEventLog,#EVENTLOG_FORWARDS_READ|#EVENTLOG_SEEK_READ, Num, *pMemBuffer, plBytesToRead, @plBytesRead, @plMinBytesToRead)
        CopyMemory(*pMemBuffer, pEventRecord, SizeOf(EVENTLOGRECORD))
        GetSystemTime_(pSystemTime)
        GetLocalTime_(pLocalTime)
        plTimeBias = Date(pSystemTime\wYear, pSystemTime\wMonth, pSystemTime\wDay, pSystemTime\wHour, pSystemTime\wMinute, pSystemTime\wSecond) - Date(pLocalTime\wYear, pLocalTime\wMonth, pLocalTime\wDay, pLocalTime\wHour, pLocalTime\wMinute, pLocalTime\wSecond)
        ProcedureReturn pEventRecord\TimeGenerated - plTimeBias
      Else
        ProcedureReturn -1
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_GetTimeWritten(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected pEventRecord.EVENTLOGRECORD
  Protected plBytesToRead.l, plBytesRead.l, plMinBytesToRead.l
  Protected *pMemBuffer
  Protected pSystemTime.SYSTEMTIME
  Protected pLocalTime.SYSTEMTIME
  Protected plTimeBias.l
  If *RObject
    With *RObject
      If \hEventLog
        plBytesToRead     = 5000 ; SizeOf(EVENTLOGRECORD)
        plBytesRead       = 0
        plMinBytesToRead  = 0
        If *pMemBuffer
          FreeMemory(*pMemBuffer)
        EndIf
        *pMemBuffer = AllocateMemory(plBytesToRead)
        ReadEventLog_(\hEventLog,#EVENTLOG_FORWARDS_READ|#EVENTLOG_SEEK_READ, Num, *pMemBuffer, plBytesToRead, @plBytesRead, @plMinBytesToRead)
        CopyMemory(*pMemBuffer, pEventRecord, SizeOf(EVENTLOGRECORD))
        GetSystemTime_(pSystemTime)
        GetLocalTime_(pLocalTime)
        plTimeBias = Date(pSystemTime\wYear, pSystemTime\wMonth, pSystemTime\wDay, pSystemTime\wHour, pSystemTime\wMinute, pSystemTime\wSecond) - Date(pLocalTime\wYear, pLocalTime\wMonth, pLocalTime\wDay, pLocalTime\wHour, pLocalTime\wMinute, pLocalTime\wSecond)
        ProcedureReturn pEventRecord\TimeWritten - plTimeBias
      Else
        ProcedureReturn -1
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.s REventLog_GetSourceName(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected pEventRecord.EVENTLOGRECORD
  Protected plBytesToRead.l, plBytesRead.l, plMinBytesToRead.l
  Protected *pMemBuffer
  If *RObject
    With *RObject
      If \hEventLog
        plBytesToRead     = 5000 ; SizeOf(EVENTLOGRECORD)
        plBytesRead       = 0
        plMinBytesToRead  = 0
        If *pMemBuffer
          FreeMemory(*pMemBuffer)
        EndIf
        *pMemBuffer = AllocateMemory(plBytesToRead)
        ReadEventLog_(\hEventLog,#EVENTLOG_FORWARDS_READ|#EVENTLOG_SEEK_READ, Num, *pMemBuffer, plBytesToRead, @plBytesRead, @plMinBytesToRead)
        CopyMemory(*pMemBuffer, pEventRecord, SizeOf(EVENTLOGRECORD))
        ProcedureReturn PeekS(*pMemBuffer + SizeOf(EVENTLOGRECORD))
      Else
        ProcedureReturn ""
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.s REventLog_GetComputerName(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected pEventRecord.EVENTLOGRECORD
  Protected plBytesToRead.l, plBytesRead.l, plMinBytesToRead.l, plResult.l
  Protected psSrcName.s
  Protected *pMemBuffer
  If *RObject
    With *RObject
      If \hEventLog
        plBytesToRead     = 5000 ; SizeOf(EVENTLOGRECORD)
        plBytesRead       = 0
        plMinBytesToRead  = 0
        If *pMemBuffer
          FreeMemory(*pMemBuffer)
        EndIf
        *pMemBuffer = AllocateMemory(plBytesToRead)
        ReadEventLog_(\hEventLog,#EVENTLOG_FORWARDS_READ|#EVENTLOG_SEEK_READ, Num, *pMemBuffer, plBytesToRead, @plBytesRead, @plMinBytesToRead)
        CopyMemory(*pMemBuffer, pEventRecord, SizeOf(EVENTLOGRECORD))
        psSrcName  = PeekS(*pMemBuffer + SizeOf(EVENTLOGRECORD))
        CompilerIf #PB_Compiler_Unicode = #True
          plResult   = *pMemBuffer + SizeOf(EVENTLOGRECORD) + 1 + Len(psSrcName) * 2
        CompilerElse
          plResult   = *pMemBuffer + SizeOf(EVENTLOGRECORD) + 1 + Len(psSrcName)
        CompilerEndIf
        ProcedureReturn PeekS(plResult, 15)
      Else
        ProcedureReturn ""
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.s REventLog_GetCategory(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected pEventRecord.EVENTLOGRECORD
  Protected plBytesToRead.l, plBytesRead.l, plMinBytesToRead.l
  Protected psExec.s, psKey.s
  Protected *pMemBuffer
  If *RObject
    With *RObject
      If \hEventLog
        plBytesToRead     = 5000 ; SizeOf(EVENTLOGRECORD)
        plBytesRead       = 0
        plMinBytesToRead  = 0
        If *pMemBuffer
          FreeMemory(*pMemBuffer)
        EndIf
        *pMemBuffer = AllocateMemory(plBytesToRead)
        ReadEventLog_(\hEventLog,#EVENTLOG_FORWARDS_READ|#EVENTLOG_SEEK_READ, Num, *pMemBuffer, plBytesToRead, @plBytesRead, @plMinBytesToRead)
        CopyMemory(*pMemBuffer, pEventRecord, SizeOf(EVENTLOGRECORD))
        If pEventRecord\EventCategory
          psExec = PeekS(*pMemBuffer + 56)
          If psExec
            psKey = RMisc_ReadRegKey(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\" + \sLogName + "\" + psExec, "CategoryMessageFile")
            If psKey
              psKey = ReplaceString(psKey, "%SystemRoot%", GetEnvironmentVariable("systemroot"))
              ProcedureReturn RMisc_ReadMessageTable(psKey, pEventRecord\EventCategory)
            EndIf
          EndIf
        Else
          ProcedureReturn "None"
        EndIf
      Else
        ProcedureReturn ""
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.s REventLog_GetUserName(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected pEventRecord.EVENTLOGRECORD
  Protected plBytesToRead.l, plBytesRead.l, plMinBytesToRead.l, plUserNameSize.l, plDomainSize.l, plAccountType.l, plSID.l
  Protected psUserName.s, psDomainName.s
  Protected *pMemBuffer
  If *RObject
    With *RObject
      If \hEventLog
        plBytesToRead     = 5000 ; SizeOf(EVENTLOGRECORD)
        plBytesRead       = 0
        plMinBytesToRead  = 0
        plAccountType     = 0
        plUserNameSize    = 256
        plDomainSize      = 256
        psUserName        = Space(plUserNameSize)
        psDomainName      = Space(plDomainSize)
        If *pMemBuffer
          FreeMemory(*pMemBuffer)
        EndIf
        *pMemBuffer = AllocateMemory(plBytesToRead)
        ReadEventLog_(\hEventLog,#EVENTLOG_FORWARDS_READ|#EVENTLOG_SEEK_READ, Num, *pMemBuffer, plBytesToRead, @plBytesRead, @plMinBytesToRead)
        CopyMemory(*pMemBuffer, pEventRecord, SizeOf(EVENTLOGRECORD))
        If pEventRecord\UserSidLength > 0
          plSID = *pMemBuffer + pEventRecord\UserSidOffset
          If LookupAccountSid_(#Null, plSID, psUsername, @plUsernameSize, psDomainName, @plDomainSize, @plAccountType)
            LocalFree_(plSID)
            ProcedureReturn psDomainname + "\" + psUsername
          Else
            ProcedureReturn ""
          EndIf
        Else
          ProcedureReturn ""
        EndIf
      Else
        ProcedureReturn ""
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.s REventLog_GetDescription(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected pEventRecord.EVENTLOGRECORD
  Protected plBytesToRead.l, plBytesRead.l, plMinBytesToRead.l, plDLL.l, plDescBuffer.l, plInc.l, plEventID.l, plLenDescBuffer.l, plBufStr.l
  Protected psEventMessageFile.s, psSourceName.s, psDescription.s
  Protected pwNbStr.w
  Protected *pMemBuffer

  If *RObject
    With *RObject
      If \hEventLog
        plBytesToRead     = 5000 ; SizeOf(EVENTLOGRECORD)
        plBytesRead       = 0
        plMinBytesToRead  = 0
        
        If *pMemBuffer
          FreeMemory(*pMemBuffer)
        EndIf
        *pMemBuffer = AllocateMemory(plBytesToRead)
        ReadEventLog_(\hEventLog,#EVENTLOG_FORWARDS_READ|#EVENTLOG_SEEK_READ, Num, *pMemBuffer, plBytesToRead, @plBytesRead, @plMinBytesToRead)
        CopyMemory(*pMemBuffer, pEventRecord, SizeOf(EVENTLOGRECORD))
        psSourceName        = PeekS(*pMemBuffer+SizeOf(EVENTLOGRECORD))
        plEventID           = pEventRecord\EventID
        psEventMessageFile  = RMisc_ReadMultiLineString(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\sLogName+"\"+psSourceName, "EventMessageFile")
        If FindString(LCase(psEventMessageFile),"%systemroot%",1)>0
          psEventMessageFile = ReplaceString(LCase(psEventMessageFile), "%systemroot%", GetEnvironmentVariable("systemroot"))
        EndIf
        plDLL               = LoadLibrary_(psEventMessageFile)
        pwNbStr             = PeekW(*pMemBuffer + 26)
        plBufStr            = *pMemBuffer + PeekL(*pMemBuffer + 36)
        
        ; Arrays of values for replacing %1, %2, %3, %etc...
        Protected Dim pDimStr.s(pwNbStr)
        For plInc = 1 To pwNbStr
          pDimStr(plInc - 1)  = PeekS(plBufStr)
          plBufStr            = plBufStr + Len(pDimStr(plInc-1)) * SizeOf(Character) + SizeOf(Character)
        Next
        
        ; Description of Item 
        If plDLL
          FormatMessage_(#FORMAT_MESSAGE_ARGUMENT_ARRAY|#FORMAT_MESSAGE_ALLOCATE_BUFFER|#FORMAT_MESSAGE_FROM_SYSTEM|#FORMAT_MESSAGE_FROM_HMODULE, plDLL, plEventID, #Null, @plDescBuffer, plLenDescBuffer, @pDimStr())
          FreeLibrary_(plDLL)
          If plDescBuffer
            psDescription = PeekS(plDescBuffer)
            LocalFree_(plDescBuffer)
          EndIf
        EndIf
        ProcedureReturn psDescription
      Else
        ProcedureReturn ""
      EndIf
    EndWith
  EndIf
EndProcedure

ProcedureDLL.l REventLog_CreateLog(ID.l, sLogName.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      If sLogName <> "" 
        If RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+sLogName, "") <> #True
          RMisc_WriteRegKey(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+sLogName)
          REventLog_Open(ID, sLogName)
          \sLogName = sLogName
          ProcedureReturn #True
        Else
          ProcedureReturn #False
        EndIf
      Else
        ProcedureReturn #False
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_CreateSource(ID.l, sSourceName.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected sReadSources.s
  If *RObject
    With *RObject
      If \sLogName <> "" 
        If RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\" + \sLogName + "\" + sSourceName) <> #True
          sReadSources = RMisc_ReadMultiLineString(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\" + \sLogName, "Sources")
          If sReadSources = ""
            sReadSources = \sLogName
          EndIf
          If FindString(sReadSources, sSourceName, 1) = 0
            RMisc_WriteMultiLineString(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\" + \sLogName, "Sources", sSourceName + #LF$ + sReadSources)
          EndIf
          ProcedureReturn RMisc_WriteRegKey(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\" + \sLogName + "\" + sSourceName)
        Else
          ProcedureReturn #False
        EndIf
      Else
        ProcedureReturn #False
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_SetDLLCategory(ID.l, sSourceName.s, lNbCat.l, sDLLCategory.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      If \sLogName <> "" 
        If RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\sLogName+"\"+sSourceName, "") = #True
          RMisc_SetValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\sLogName+"\"+sSourceName, "CategoryCount", Str(lNbCat), #REG_DWORD, "")
          ProcedureReturn RMisc_SetValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\sLogName+"\"+sSourceName, "CategoryMessageFile", sDLLCategory, #REG_SZ, "")
        Else
          ProcedureReturn #False
        EndIf
      Else
        ProcedureReturn #False
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_SetDLLEventMessage(ID.l, sSourceName.s, sDLLEventMessage.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      If \sLogName <> "" 
        If RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\sLogName+"\"+sSourceName, "") = #True
          ProcedureReturn RMisc_SetValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\sLogName+"\"+sSourceName, "EventMessageFile", sDLLEventMessage, #REG_SZ, "")
        Else
          ProcedureReturn #False
        EndIf
      Else
        ProcedureReturn #False
      EndIf
    EndWith
  EndIf
EndProcedure
;@todo : attendre que Moebius gère les param facultatifs pour ', MessageParam.s=""'
ProcedureDLL.l REventLog_Report(ID.l, sSource.s, wCategory.w, lType.l, lMessageID.l, sMessageParam.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected plhHandle.l, plNbStrings.l, plhSid.l
  Protected pbInc.b
  If *RObject
    With *RObject
      ; Get a handle To the event log.
      plhHandle = RegisterEventSource_(#Null, sSource)
      If plhHandle = #Null
        ProcedureReturn #REVENTLOG_ERROR_BADLOGNAME
      Else
        plNbStrings = CountString(sMessageParam, ";")+1
        Protected Dim pDimStrings.s(plNbStrings - 1)
        For pbInc = 0 To plNbStrings - 1
          pDimStrings(pbInc) = StringField(sMessageParam, pbInc, ";")
        Next
        ; Report the event
        If ReportEvent_(plhHandle, lType, wCategory, lMessageID, plhSid, plNbStrings, 0, @pDimStrings(),0) <> 0
          DeregisterEventSource_(plhHandle)
          ProcedureReturn #REVENTLOG_SUCCESS
        Else
          ProcedureReturn #REVENTLOG_ERROR_LAST
        EndIf
      EndIf
    EndWith
  EndIf
EndProcedure

ProcedureDLL.l REventLog_ExistsSource(sLogName.s, sSourceName.s)
  ProcedureReturn RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+sLogName+"\"+sSourceName)
EndProcedure
ProcedureDLL.l REventLog_ExistsLog(sLogName.s)
  ProcedureReturn RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+sLogName, "")
EndProcedure
ProcedureDLL.l REventLog_ExistsDLLCategory(sLogName.s, sSourceName.s)
  If RMisc_ReadMultiLineString(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+sLogName+"\"+sSourceName, "CategoryMessageFile") = ""
    ProcedureReturn #False
  Else
    ProcedureReturn #True
  EndIf
EndProcedure
ProcedureDLL.l REventLog_ExistsDLLEventMessage(sLogName.s, sSourceName.s)
  If RMisc_ReadMultiLineString(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+sLogName+"\"+sSourceName, "EventMessageFile") = ""
    ProcedureReturn #False
  Else
    ProcedureReturn #True
  EndIf
EndProcedure
