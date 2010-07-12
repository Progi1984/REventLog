Import "C:\Program Files\PureBasic\Compilers\ObjectManager.lib"
  Object_GetOrAllocateID (Objects, Object.l) As "_PB_Object_GetOrAllocateID@8"
  Object_GetObject       (Objects, Object.l) As "_PB_Object_GetObject@8"
  Object_IsObject        (Objects, Object.l) As "_PB_Object_IsObject@8"
  Object_EnumerateAll    (Objects, ObjectEnumerateAllCallback, *VoidData) As "_PB_Object_EnumerateAll@12"
  Object_EnumerateStart  (Objects) As "_PB_Object_EnumerateStart@4"
  Object_EnumerateNext   (Objects, *object.Long) As "_PB_Object_EnumerateNext@8"
  Object_EnumerateAbort  (Objects) As "_PB_Object_EnumerateAbort@4"
  Object_FreeID          (Objects, Object.l) As "_PB_Object_FreeID@8"
  Object_Init            (StructureSize.l, IncrementStep.l, ObjectFreeFunction) As "_PB_Object_Init@12"
  Object_GetThreadMemory (MemoryID.l) As "_PB_Object_GetThreadMemory@4"
  Object_InitThreadMemory(Size.l, InitFunction, EndFunction) As "_PB_Object_InitThreadMemory@12"
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
  Protected Result.l, hKey.l, Error.l, dwDisposition.l, Mem.l, i.L, NumLF.L, LFPos.L
  ;Reg_ResetError()

  If Right(KeyName, 1) = "\" : KeyName = Left(KeyName, Len(KeyName) - 1) : EndIf
  Error = RegCreateKeyEx_(topKey, KeyName, 0, 0, #REG_OPTION_NON_VOLATILE, #KEY_ALL_ACCESS, 0, @hKey, @dwDisposition)
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

ProcedureDLL REventLog_Free(ID.l)
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
Procedure REventLogFree(ID.l)
  ProcedureReturn REventLog_Free(ID.l)
EndProcedure
ProcedureDLL REventLog_Init()
  Global REventLogObjects
  REventLogObjects = REVENTLOG_INITIALIZE(@REventLogFree()) 
EndProcedure
ProcedureDLL REventLog_End()
EndProcedure
ProcedureDLL REventLog_IsEventLog(ID.l)
  ProcedureReturn REVENTLOG_IS(ID)
EndProcedure

ProcedureDLL REventLog_Create(ID.l)
  Protected *RObject.S_REventLog = REVENTLOG_NEW(ID)
  With *RObject
    \hEventLog = -1
  EndWith
  ProcedureReturn *RObject
EndProcedure
ProcedureDLL REventLog_Load(ID.l, Filename.s, Name.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      \hEventLog = OpenBackupEventLog_(@"", @Filename)
      \LogName   = Name
      ProcedureReturn \hEventLog
    EndWith
  EndIf
  ProcedureReturn #False
EndProcedure
ProcedureDLL REventLog_Open(ID.l, Name.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      \hEventLog  = OpenEventLog_(0, Name)
      \LogName    = Name
      ProcedureReturn \hEventLog
    EndWith
  EndIf
  ProcedureReturn #False
EndProcedure
ProcedureDLL REventLog_Save(ID.l, Filename.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      ProcedureReturn BackupEventLog_(\hEventLog, Filename)
    EndWith
  EndIf
EndProcedure
ProcedureDLL REventLog_Clear(ID.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      ClearEventLog_(\hEventLog, #Null)
    EndWith
  EndIf
EndProcedure

ProcedureDLL.l REventLog_CountEvents(ID.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected EventLogReadFlags.l, BufferLength.l, NbOfRecords.l
  If *RObject
    With *RObject
      NbOfRecords       = 0
      If \hEventLog
        If GetNumberOfEventLogRecords_(\hEventLog, @NbOfRecords)
          ProcedureReturn NbOfRecords
        Else
          ProcedureReturn -1
        EndIf
      Else
        ProcedureReturn -1
    EndIf
    EndWith
  EndIf
EndProcedure
Procedure.l REventLog_ReadEvent(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected pcbBytesNeeded.l, BytesWritten.l = 0, NeededBytes.l = 0
  Protected Buffer
  If *RObject
    With *RObject
      If \hEventLog
        pcbBytesNeeded = 5000 ; SizeOf(EVENTLOGRECORD)
        If Buffer
          FreeMemory(Buffer)
        EndIf
        If \CurItemLog
          FreeMemory(\CurItemLog)
        EndIf
        Buffer = AllocateMemory(pcbBytesNeeded)
        ReadEventLog_(\hEventLog,#EVENTLOG_FORWARDS_READ|#EVENTLOG_SEEK_READ, Num, Buffer, pcbBytesNeeded, @BytesWritten, @NeededBytes)
        \CurItemLog = Buffer
        ProcedureReturn Buffer
      Else
        ProcedureReturn -1
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_GetType(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected EventRecord.EVENTLOGRECORD
  If *RObject
    With *RObject
      REventLog_ReadEvent(ID, Num)
      CopyMemory(\CurItemLog, EventRecord, SizeOf(EVENTLOGRECORD))
      ProcedureReturn EventRecord\EventType
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_GetEventID(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected EventRecord.EVENTLOGRECORD
  If *RObject
    With *RObject
      REventLog_ReadEvent(ID, Num)
      CopyMemory(\CurItemLog, EventRecord, SizeOf(EVENTLOGRECORD))
      ProcedureReturn EventRecord\EventID
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_GetTimeSubmitted(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected EventRecord.EVENTLOGRECORD
  Protected SystemTime.SYSTEMTIME
  Protected LocalTime.SYSTEMTIME
  Protected TimeBias.l
  If *RObject
    With *RObject
      REventLog_ReadEvent(ID, Num)
      GetSystemTime_(SystemTime)
      GetLocalTime_(LocalTime)
      TimeBias = Date(SystemTime\wYear, SystemTime\wMonth, SystemTime\wDay, SystemTime\wHour, SystemTime\wMinute, SystemTime\wSecond) - Date(LocalTime\wYear, LocalTime\wMonth, LocalTime\wDay, LocalTime\wHour, LocalTime\wMinute, LocalTime\wSecond)
      CopyMemory(\CurItemLog, EventRecord, SizeOf(EVENTLOGRECORD))
      ProcedureReturn EventRecord\TimeGenerated - TimeBias
    EndWith
  EndIf
EndProcedure
ProcedureDLL.l REventLog_GetTimeWritten(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected EventRecord.EVENTLOGRECORD
  Protected SystemTime.SYSTEMTIME
  Protected LocalTime.SYSTEMTIME
  Protected TimeBias.l
  If *RObject
    With *RObject
      REventLog_ReadEvent(ID, Num)
      GetSystemTime_(SystemTime)
      GetLocalTime_(LocalTime)
      TimeBias = Date(SystemTime\wYear, SystemTime\wMonth, SystemTime\wDay, SystemTime\wHour, SystemTime\wMinute, SystemTime\wSecond) - Date(LocalTime\wYear, LocalTime\wMonth, LocalTime\wDay, LocalTime\wHour, LocalTime\wMinute, LocalTime\wSecond)
      CopyMemory(\CurItemLog, EventRecord, SizeOf(EVENTLOGRECORD))
      ProcedureReturn EventRecord\TimeWritten - TimeBias
    EndWith
  EndIf
EndProcedure

ProcedureDLL.s REventLog_GetSourceName(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected EventRecord.EVENTLOGRECORD
  If *RObject
    With *RObject
      REventLog_ReadEvent(ID, Num)
      CopyMemory(\CurItemLog, EventRecord, SizeOf(EVENTLOGRECORD))
      ProcedureReturn PeekS(\CurItemLog+SizeOf(EVENTLOGRECORD))
    EndWith
  EndIf
EndProcedure
ProcedureDLL.s REventLog_GetComputerName(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected EventRecord.EVENTLOGRECORD
  If *RObject
    With *RObject
      REventLog_ReadEvent(ID, Num)
      CopyMemory(\CurItemLog, EventRecord, SizeOf(EVENTLOGRECORD))
      If #PB_Compiler_Unicode = #True
        ProcedureReturn PeekS(\CurItemLog+SizeOf(EVENTLOGRECORD)+(1+Len(REventLog_GetSourceName(ID, Num)))*2,15)
      Else
        ProcedureReturn PeekS(\CurItemLog+SizeOf(EVENTLOGRECORD)+(1+Len(REventLog_GetSourceName(ID, Num))),15)
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.s REventLog_GetCategory(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected EventRecord.EVENTLOGRECORD
  Protected Exec.s, Key.s
  If *RObject
    With *RObject
      REventLog_ReadEvent(ID, Num)
      CopyMemory(\CurItemLog, EventRecord, SizeOf(EVENTLOGRECORD))
      If EventRecord\EventCategory
        Exec = PeekS(\CurItemLog + 56)
        If Exec
          Key = RMisc_ReadRegKey(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\LogName+"\"+Exec, "CategoryMessageFile")
          If Key
            Key = ReplaceString(Key, "%SystemRoot%", GetEnvironmentVariable("systemroot"))
            ProcedureReturn RMisc_ReadMessageTable(Key, EventRecord\EventCategory)
          EndIf
        EndIf
      Else
        ProcedureReturn "None"
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL.s REventLog_GetUserName(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected EventRecord.EVENTLOGRECORD
  Protected lUserNameSize   = 256
  Protected lDomainSize     = 256
  Protected strUserName.s   = Space(lUserNameSize)
  Protected strDomainName.s = Space(lDomainSize)
  Protected lAccountType = 0

  With *RObject
    If *RObject
      REventLog_ReadEvent(ID, Num)
      CopyMemory(\CurItemLog, EventRecord, SizeOf(EVENTLOGRECORD))
      If EventRecord\UserSidLength > 0
        pSID = \CurItemLog + EventRecord\UserSidOffset
        If LookupAccountSid_(#Null, pSID, strUsername, @lUsernameSize, strDomainName, @lDomainSize, @lAccountType)
          LocalFree_(pSID)
          ProcedureReturn strDomainname+"\"+strUsername
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
EndProcedure
ProcedureDLL.s REventLog_GetDescription(ID.l, Num.l)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected EventRecord.EVENTLOGRECORD
  Protected P_EventMessageFile.s, P_SourceName.s, Description.s, StrLine.s
  Protected P_hDLL.l, P_DescBuffer.l, Inc.l, P_EventID.l, P_LenDescBuffer.l
  Protected NbStr.w
  Protected BufStr.l
  If *RObject
    With *RObject
      REventLog_ReadEvent(ID, Num)
      CopyMemory(\CurItemLog, EventRecord, SizeOf(EVENTLOGRECORD))

      P_SourceName        = REventLog_GetSourceName(ID, Num)
      P_EventID           = REventLog_GetEventID(ID, Num)
      P_EventMessageFile  = RMisc_ReadMultiLineString(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\LogName+"\"+P_SourceName, "EventMessageFile")
      If FindString(LCase(P_EventMessageFile),"%systemroot%",1)>0
        P_EventMessageFile = ReplaceString(LCase(P_EventMessageFile), "%systemroot%", GetEnvironmentVariable("systemroot"))
      EndIf
      P_hDLL              = LoadLibrary_(P_EventMessageFile)
      NbStr               = PeekW(\CurItemLog + 26)
      BufStr              = \CurItemLog + PeekL(\CurItemLog + 36)
      
      ; Arrays of values for replacing %1, %2, %3, %etc...
      Protected Dim DimStr.s(NbStr)
      For Inc = 1 To NbStr
        DimStr(Inc-1) = PeekS(BufStr)
        BufStr        = BufStr + Len(DimStr(Inc-1)) * SizeOf(Character) + SizeOf(Character)
      Next
      
      ; Description of Item 
      If P_hDLL
        FormatMessage_(#FORMAT_MESSAGE_ARGUMENT_ARRAY|#FORMAT_MESSAGE_ALLOCATE_BUFFER|#FORMAT_MESSAGE_FROM_SYSTEM|#FORMAT_MESSAGE_FROM_HMODULE,P_hDLL,P_EventID,#Null,@P_DescBuffer,P_LenDescBuffer,@DimStr())
        FreeLibrary_(P_hDLL)
        If P_DescBuffer
          Description = PeekS(P_DescBuffer)
          LocalFree_(P_DescBuffer)
        EndIf
      EndIf
      ProcedureReturn Description
    EndWith
  EndIf
EndProcedure

ProcedureDLL REventLog_CreateLog(ID.l, LogName.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      If LogName <> "" And RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+LogName, "") <> #True
        RMisc_WriteRegKey(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+LogName)
        REventLog_Open(ID, LogName)
        \LogName = LogName
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL REventLog_CreateSource(ID.l, SourceName.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  Protected ReadSources.s
  If *RObject
    With *RObject
      If \LogName <> "" And RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\LogName+"\"+SourceName) <> #True
        ReadSources = RMisc_ReadMultiLineString(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\LogName,"Sources")
        If Readsources = ""
          ReadSources = \LogName
        EndIf
        If FindString(ReadSources, SourceName, 1) = 0
          RMisc_WriteMultiLineString(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\LogName, "Sources", SourceName+#LF$+ReadSources)
        EndIf
        ProcedureReturn RMisc_WriteRegKey(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\LogName+"\"+SourceName)
      Else
        ProcedureReturn #False
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL REventLog_SetDLLCategory(ID.l, SourceName.s, NbCat.l, DLLCategory.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      If \LogName <> "" And RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\LogName+"\"+SourceName, "") = #True
        RMisc_SetValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\LogName+"\"+SourceName, "CategoryCount", Str(NbCat), #REG_DWORD, "")
        ProcedureReturn RMisc_SetValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\LogName+"\"+SourceName, "CategoryMessageFile", DLLCategory, #REG_SZ, "")
      Else
        ProcedureReturn #False
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL REventLog_SetDLLEventMessage(ID.l, SourceName.s, DLLEventMessage.s)
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      If \LogName <> "" And RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\LogName+"\"+SourceName, "") = #True
        ProcedureReturn RMisc_SetValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+\LogName+"\"+SourceName, "EventMessageFile", DLLEventMessage, #REG_SZ, "")
      Else
        ProcedureReturn #False
      EndIf
    EndWith
  EndIf
EndProcedure
ProcedureDLL REventLog_Report(ID.l, Source.s, Category.w, Type.l, MessageID.l, MessageParam.s="")
  Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
  If *RObject
    With *RObject
      Protected hHandle.l
      Protected NbStrings.l
      ; Get a handle To the event log.
      hHandle = RegisterEventSource_(#Null, Source)
      If hHandle = #Null
        ProcedureReturn #REVENTLOG_ERROR_BADLOGNAME
      Else
        NbStrings = CountString(MessageParam, ";")+1
        Protected Dim Strings.s(NbStrings-1)
        Protected Inc.b
        Protected hSid.l
        For Inc = 0 To NbStrings - 1
          Strings(Inc) = StringField(MessageParam, Inc, ";")
        Next
        ; Report the event
        If ReportEvent_(hHandle, Type, Category, MessageID, hSid, NbStrings, 0, @Strings(),0) <> 0
          DeregisterEventSource_(hHandle)
          ProcedureReturn #REVENTLOG_SUCCESS
        Else
          ProcedureReturn #REVENTLOG_ERROR_LAST
        EndIf
      EndIf
    EndWith
  EndIf
EndProcedure

ProcedureDLL.l REventLog_ExistsSource(LogName.s, SourceName.s)
  ProcedureReturn RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+LogName+"\"+SourceName)
EndProcedure
ProcedureDLL.l REventLog_ExistsLog(LogName.s)
  ProcedureReturn RMisc_KeyExists(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+LogName, "")
EndProcedure
ProcedureDLL.l REventLog_ExistsDLLCategory(LogName.s, SourceName.s)
  If RMisc_ReadMultiLineString(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+LogName+"\"+SourceName, "CategoryMessageFile") = ""
    ProcedureReturn #False
  Else
    ProcedureReturn #True
  EndIf
EndProcedure
ProcedureDLL.l REventLog_ExistsDLLEventMessage(LogName.s, SourceName.s)
  If RMisc_ReadMultiLineString(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Eventlog\"+LogName+"\"+SourceName, "EventMessageFile") = ""
    ProcedureReturn #False
  Else
    ProcedureReturn #True
  EndIf
EndProcedure

; ProcedureDLL REventLog_(ID.l)
;   Protected *RObject.S_REventLog = REVENTLOG_ID(ID)
;   If *RObject
;     With *RObject
;     EndWith
;   EndIf
; EndProcedure


; IDE Options = PureBasic 4.10 (Windows - x86)
; CursorPosition = 361
; FirstLine = 8
; Folding = AAAAAAAAAAAAAY4HAAAAAA5