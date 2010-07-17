;================================
; Project   REventLog
; Title     Read System EventLog
; Author    Progi1984
; Date      11/10/2007
; Notes     
;================================

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
  #Combo_0
  #Button_0
  #Button_1
  #Button_2
EndEnumeration
Global REventItem.l = -1

  Declare ShowREventItem()
  
  If OpenWindow(#Window_0, 341, 258, 300, 350, "REventLog - Read System EventLog",  #PB_Window_SystemMenu | #PB_Window_TitleBar )
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
    
    TextGadget(#Text_9, 10, 5, 120, 20, "System EventLog :", #PB_Text_Right | #PB_Text_Border)
    ComboBoxGadget(#Combo_0, 140, 5, 150, 25)
      AddGadgetItem(#Combo_0, -1, "Application")
      AddGadgetItem(#Combo_0, -1, "Security")
      AddGadgetItem(#Combo_0, -1, "System")
    ButtonGadget(#Button_0, 205, 35, 90, 25, "Choose")
    ButtonGadget(#Button_1, 10, 35, 90, 25, "<<")
    ButtonGadget(#Button_2, 108, 35, 90, 25, ">>")
    Repeat
      Event = WaitWindowEvent()
      Gadget = EventGadget()
      Select Event
        Case #PB_Event_Gadget
          Select Gadget
            Case #Button_0
            ;{ Choose
              If GetGadgetState(#Combo_0) >= 0 And GetGadgetState(#Combo_0) < CountGadgetItems(#Combo_0)
                If REventLog_IsEventLog(0) : REventLog_Free(0) : EndIf
                REventLog_Create(0)
                REventLog_Open(0, GetGadgetText(#Combo_0))
                REventItem = 1
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
              If REventItem > -1
                If REventItem > 1
                  REventItem - 1
                  If REventItem = 1
                    SetGadgetText(#Button_1, "None")
                    SetGadgetText(#Button_2, "2")
                  Else
                    SetGadgetText(#Button_1, Str(REventItem-1))
                    SetGadgetText(#Button_2, Str(REventItem+1))
                  EndIf
                  ShowREventItem()
                EndIf
              EndIf
            ;}
            Case #Button_2
            ;{ >>
              If REventItem > -1
                If REventItem < REventLog_CountEvents(0)
                  REventItem + 1
                  If REventItem = REventLog_CountEvents(0)
                    SetGadgetText(#Button_1, Str(REventItem-1))
                    SetGadgetText(#Button_2, "None")
                  Else
                    SetGadgetText(#Button_1, Str(REventItem-1))
                    SetGadgetText(#Button_2, Str(REventItem+1))
                  EndIf
                  ShowREventItem()
                EndIf
              EndIf
            ;}
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
  Procedure ShowREventItem()
    SetGadgetText(#String_0, Str(REventLog_GetType(0, REventItem)))
    SetGadgetText(#String_1, Str(REventLog_GetEventID(0, REventItem)))
    SetGadgetText(#String_2, FormatDate("%YYYY/%mm/%dd %hh:%ii:%ss ",REventLog_GetTimeSubmitted(0, REventItem)))
    SetGadgetText(#String_3, FormatDate("%YYYY/%mm/%dd %hh:%ii:%ss ",REventLog_GetTimeWritten(0, REventItem)))
    SetGadgetText(#String_4, REventLog_GetSourceName(0, REventItem))
    SetGadgetText(#String_5, REventLog_GetComputerName(0, REventItem))
    SetGadgetText(#String_6, REventLog_GetCategory(0, REventItem))
    SetGadgetText(#String_7, REventLog_GetUserName(0, REventItem))
    SetGadgetText(#String_8, REventLog_GetDescription(0,REventItem))
  EndProcedure
