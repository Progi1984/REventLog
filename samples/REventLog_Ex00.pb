;================================
; Project   REventLog
; Title     Read EventLog File
; Author    Progi1984
; Date      11/10/2007
; Notes     
;================================

; XIncludeFile "../../trunk/src/REventLog_Res.pb"
; XIncludeFile "../../trunk/src/REventLog.pb"
; REventLog_Init()
Enumeration
  #Window_0
  #Text_0
  #Text_1
  #Text_2
  #Text_3
  #Text_4
  #Text_5
  #Text_6
  #Text_7
  #Text_8
  #Text_9
  #String_0
  #String_1
  #String_2
  #String_3
  #String_4
  #String_5
  #String_6
  #String_7
  #String_8
  #String_9
  #Button_0
  #Button_1
  #Button_2
EndEnumeration
Global glREventItem.l = -1
  
  Declare ShowREventItem()
  
  If OpenWindow(#Window_0, 341, 258, 300, 350, "REventLog - Read EventLog File",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
    TextGadget(#Text_0, 10, 65, 120, 20, "Type :", #PB_Text_Border)
    TextGadget(#Text_1, 10, 90, 120, 20, "EventID :", #PB_Text_Border)
    TextGadget(#Text_2, 10, 115, 120, 20, "Time Submitted", #PB_Text_Border)
    TextGadget(#Text_3, 10, 140, 120, 20, "Time Written :", #PB_Text_Border)
    TextGadget(#Text_4, 10, 165, 120, 20, "Source Name :", #PB_Text_Border)
    TextGadget(#Text_5, 10, 190, 120, 20, "Computer Name :", #PB_Text_Border)
    TextGadget(#Text_6, 10, 215, 120, 20, "Category :", #PB_Text_Border)
    TextGadget(#Text_7, 10, 240, 120, 20, "User Name :", #PB_Text_Border)
    TextGadget(#Text_8, 10, 265, 120, 20, "Message :", #PB_Text_Border)
    StringGadget(#String_0, 140, 65, 150, 25, "")
    StringGadget(#String_1, 140, 90, 150, 25, "")
    StringGadget(#String_2, 140, 115, 150, 25, "")
    StringGadget(#String_3, 140, 140, 150, 25, "")
    StringGadget(#String_4, 140, 165, 150, 25, "")
    StringGadget(#String_5, 140, 190, 150, 25, "")
    StringGadget(#String_6, 140, 215, 150, 25, "")
    StringGadget(#String_7, 140, 240, 150, 25, "")
    EditorGadget(#String_8, 140, 265, 150, 80)
    
    TextGadget(#Text_9, 10, 5, 120, 20, "EventLog File :", #PB_Text_Right | #PB_Text_Border)
    StringGadget(#String_9, 140, 5, 150, 25, "", #PB_String_ReadOnly)
    ButtonGadget(#Button_0, 205, 35, 90, 25, "Browse")
    ButtonGadget(#Button_1, 10, 35, 90, 25, "<<")
    ButtonGadget(#Button_2, 108, 35, 90, 25, ">>")
  EndIf
  Repeat
    Event = WaitWindowEvent()
    Gadget = EventGadget()
    Select Event
      Case #PB_Event_Gadget
        Select Gadget
          Case #Button_0
          ;{ Browse
            File.s = OpenFileRequester("EventLog File", "", "EventLogFiles (*.evt)|*.evt",0)
            If File
              If REventLog_IsEventLog(0) : REventLog_Free(0) : EndIf
              REventLog_Create(0)
              REventLog_Load(0, File, "System")
              glREventItem = 1
              SetGadgetText(#String_9, GetFilePart(File))
              If REventLog_CountEvents(0) <= 1
                SetGadgetText(#Button_1, "None")
                SetGadgetText(#Button_2, "None")
              Else
                SetGadgetText(#Button_1, "None")
                SetGadgetText(#Button_2, "2")
              EndIf
              ShowREventItem()
            EndIf
          ;}
          Case #Button_1
          ;{ <<
            If glREventItem > -1
              If glREventItem > 1
                glREventItem - 1
                If glREventItem = 1
                  SetGadgetText(#Button_1, "None")
                  SetGadgetText(#Button_2, "2")
                Else
                  SetGadgetText(#Button_1, Str(glREventItem-1))
                  SetGadgetText(#Button_2, Str(glREventItem+1))
                EndIf
                ShowREventItem()
              EndIf
            EndIf
          ;}
          Case #Button_2
          ;{ >>
            If glREventItem > -1
              If glREventItem < REventLog_CountEvents(0)
                glREventItem + 1
                If glREventItem = REventLog_CountEvents(0)
                  SetGadgetText(#Button_1, Str(glREventItem-1))
                  SetGadgetText(#Button_2, "None")
                Else
                  SetGadgetText(#Button_1, Str(glREventItem-1))
                  SetGadgetText(#Button_2, Str(glREventItem+1))
                EndIf
                ShowREventItem()
              EndIf
            EndIf
          ;}
        EndSelect
    EndSelect
  Until Event = #PB_Event_CloseWindow
  
  Procedure ShowREventItem()
    SetGadgetText(#String_0, Str(REventLog_GetType(0, glREventItem)))
    SetGadgetText(#String_1, Str(REventLog_GetEventID(0, glREventItem)))
    SetGadgetText(#String_2, FormatDate("%YYYY/%mm/%dd %hh:%ii:%ss ",REventLog_GetTimeSubmitted(0, glREventItem)))
    SetGadgetText(#String_3, FormatDate("%YYYY/%mm/%dd %hh:%ii:%ss ",REventLog_GetTimeWritten(0, glREventItem)))
    SetGadgetText(#String_4, REventLog_GetSourceName(0, glREventItem))
    SetGadgetText(#String_5, REventLog_GetComputerName(0, glREventItem))
    SetGadgetText(#String_6, REventLog_GetCategory(0, glREventItem))
    SetGadgetText(#String_7, REventLog_GetUserName(0, glREventItem))
    SetGadgetText(#String_8, REventLog_GetDescription(0, glREventItem))
  EndProcedure
