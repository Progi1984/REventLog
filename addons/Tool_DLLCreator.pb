XIncludeFile "Tool_DLLCreator_Inc.pb"

;- Constantes
Enumeration
  #Button_0
  #Button_1
  #Editor_0
  #Text_0
  #String_0
  #Main_Button_2
  #Main_ListIcon_0
  #Main_Text_1
  #Main_String_1
  #Main_Tree_0
  #Main_Window_0
  
  
  #Main_Menu_000
  #Main_Menu_001
  #Main_Menu_002
  #Main_Menu_003
  #Main_Menu_004
  #Main_Menu_005
  #Main_Menu_006
  #Main_Menu_007
  
  #LngRequester_Button_0
  #LngRequester_Button_1
  #LngRequester_Combo_0
  #LngRequester_Combo_1
  #LngRequester_Text_0
  #LngRequester_Text_1
  #LngRequester_Text_2
  #LngRequester_Window_0
  
  #EntryRequester_Button_0
  #EntryRequester_Button_1
  #EntryRequester_String_0
  #EntryRequester_String_1
  #EntryRequester_String_2
  #EntryRequester_String_3
  #EntryRequester_Text_0
  #EntryRequester_Text_1
  #EntryRequester_Text_2
  #EntryRequester_Text_3
  #EntryRequester_Window_0
EndEnumeration
Enumeration
  #TYPE_ADD
  #TYPE_EDIT
  #TYPE_DEL
  #TYPE_COPY
EndEnumeration
#DblQuote = Chr(34)

;- Structures
Structure S_Entry
  ID.l
  Content.s
EndStructure
Structure S_EntryLng
  Lng.s
  Entry.S_Entry
EndStructure
;- Listes chainées
Global NewList N_EntryLng.S_EntryLng()
Global NewList N_EntryLngTmp.S_EntryLng()
Global NewList N_EntryTmp.S_Entry()
;- Globals
Global G_CurrentLng.s
Global G_SDKPath.s; = "D:\Microsoft SDK\"
Global G_DLLPath.s; = "D:\Mes projets\PB_Userlibs_WIP\REventLog\SRC\REventLogTest.dll"
;- Macros
Macro M_AddAllLng(Gadget)
  AddGadgetItem(Gadget, -1, "0000 Language Neutral")
  AddGadgetItem(Gadget, -1, "007f Invariant locale")
  AddGadgetItem(Gadget, -1, "0400 Process Or User Default Language")
  AddGadgetItem(Gadget, -1, "0800 System Default Language")
  AddGadgetItem(Gadget, -1, "0436 Afrikaans")
  AddGadgetItem(Gadget, -1, "041c Albanian")
  AddGadgetItem(Gadget, -1, "0401 Arabic (Saudi Arabia)")
  AddGadgetItem(Gadget, -1, "0801 Arabic (Iraq)")
  AddGadgetItem(Gadget, -1, "0c01 Arabic (Egypt)")
  AddGadgetItem(Gadget, -1, "1001 Arabic (Libya)")
  AddGadgetItem(Gadget, -1, "1401 Arabic (Algeria)")
  AddGadgetItem(Gadget, -1, "1801 Arabic (Morocco)")
  AddGadgetItem(Gadget, -1, "1c01 Arabic (Tunisia)")
  AddGadgetItem(Gadget, -1, "2001 Arabic (Oman)")
  AddGadgetItem(Gadget, -1, "2401 Arabic (Yemen)")
  AddGadgetItem(Gadget, -1, "2801 Arabic (Syria)")
  AddGadgetItem(Gadget, -1, "2c01 Arabic (Jordan)")
  AddGadgetItem(Gadget, -1, "3001 Arabic (Lebanon)")
  AddGadgetItem(Gadget, -1, "3401 Arabic (Kuwait)")
  AddGadgetItem(Gadget, -1, "3801 Arabic (U.A.E.)")
  AddGadgetItem(Gadget, -1, "3c01 Arabic (Bahrain)")
  AddGadgetItem(Gadget, -1, "4001 Arabic (Qatar)")
  AddGadgetItem(Gadget, -1, "042b Armenian")
  AddGadgetItem(Gadget, -1, "042c Azeri (Latin)")
  AddGadgetItem(Gadget, -1, "082c Azeri (Cyrillic)")
  AddGadgetItem(Gadget, -1, "042d Basque")
  AddGadgetItem(Gadget, -1, "0423 Belarussian")
  AddGadgetItem(Gadget, -1, "0445 Bengali (India)")
  AddGadgetItem(Gadget, -1, "141a Bosnian (Bosnia And Herzegovin)")
  AddGadgetItem(Gadget, -1, "0402 Bulgarian")
  AddGadgetItem(Gadget, -1, "0455 Burmese")
  AddGadgetItem(Gadget, -1, "0403 Catalan")
  AddGadgetItem(Gadget, -1, "0404 Chinese (Taiwan)")
  AddGadgetItem(Gadget, -1, "0804 Chinese (PRC)")
  AddGadgetItem(Gadget, -1, "0c04 Chinese (Hong Kong SAR, PRC)")
  AddGadgetItem(Gadget, -1, "1004 Chinese (Singapore)")
  AddGadgetItem(Gadget, -1, "1404 Chinese (Macao SAR)")
  AddGadgetItem(Gadget, -1, "041a Croatian")
  AddGadgetItem(Gadget, -1, "101a Croatian (Bosnia And Herzegovin)")
  AddGadgetItem(Gadget, -1, "0405 Czech")
  AddGadgetItem(Gadget, -1, "0465 Divehi")
  AddGadgetItem(Gadget, -1, "0413 Dutch (Netherlands)")
  AddGadgetItem(Gadget, -1, "0813 Dutch (Belgium)")
  AddGadgetItem(Gadget, -1, "0409 English (United States)")
  AddGadgetItem(Gadget, -1, "0809 English (United Kingdom)")
  AddGadgetItem(Gadget, -1, "0c09 English (Australian)")
  AddGadgetItem(Gadget, -1, "1009 English (Canadian)")
  AddGadgetItem(Gadget, -1, "1409 English (New Zealand)")
  AddGadgetItem(Gadget, -1, "1809 English (Ireland)")
  AddGadgetItem(Gadget, -1, "1c09 English (South Africa)")
  AddGadgetItem(Gadget, -1, "2009 English (Jamaica)")
  AddGadgetItem(Gadget, -1, "2409 English (Caribbean)")
  AddGadgetItem(Gadget, -1, "2809 English (Belize)")
  AddGadgetItem(Gadget, -1, "2c09 English (Trinidad)")
  AddGadgetItem(Gadget, -1, "3009 English (Zimbabwe)")
  AddGadgetItem(Gadget, -1, "3409 English (Philippines)")
  AddGadgetItem(Gadget, -1, "0425 Estonian")
  AddGadgetItem(Gadget, -1, "0438 Faeroese")
  AddGadgetItem(Gadget, -1, "0429 Farsi")
  AddGadgetItem(Gadget, -1, "040b Finnish")
  AddGadgetItem(Gadget, -1, "040c French (Standard)")
  AddGadgetItem(Gadget, -1, "080c French (Belgian)")
  AddGadgetItem(Gadget, -1, "0c0c French (Canadian)")
  AddGadgetItem(Gadget, -1, "100c French (Switzerland)")
  AddGadgetItem(Gadget, -1, "140c French (Luxembourg)")
  AddGadgetItem(Gadget, -1, "180c French (Monaco)")
  AddGadgetItem(Gadget, -1, "0456 Galician")
  AddGadgetItem(Gadget, -1, "0437 Georgian")
  AddGadgetItem(Gadget, -1, "0407 German (Standard)")
  AddGadgetItem(Gadget, -1, "0807 German (Switzerland)")
  AddGadgetItem(Gadget, -1, "0c07 German (Austria)")
  AddGadgetItem(Gadget, -1, "1007 German (Luxembourg)")
  AddGadgetItem(Gadget, -1, "1407 German (Liechtenstein)")
  AddGadgetItem(Gadget, -1, "0408 Greek")
  AddGadgetItem(Gadget, -1, "0447 Gujarati")
  AddGadgetItem(Gadget, -1, "040d Hebrew")
  AddGadgetItem(Gadget, -1, "0439 Hindi")
  AddGadgetItem(Gadget, -1, "040e Hungarian")
  AddGadgetItem(Gadget, -1, "040f Icelandic")
  AddGadgetItem(Gadget, -1, "0421 Indonesian")
  AddGadgetItem(Gadget, -1, "0434 isiXhosa/Xhosa (South Africa)")
  AddGadgetItem(Gadget, -1, "0435 isiZulu/Zulu (South Africa)")
  AddGadgetItem(Gadget, -1, "0410 Italian (Standard)")
  AddGadgetItem(Gadget, -1, "0810 Italian (Switzerland)")
  AddGadgetItem(Gadget, -1, "0411 Japanese")
  AddGadgetItem(Gadget, -1, "044b Kannada")
  AddGadgetItem(Gadget, -1, "0457 Konkani")
  AddGadgetItem(Gadget, -1, "0412 Korean")
  AddGadgetItem(Gadget, -1, "0812 Korean (Johab)")
  AddGadgetItem(Gadget, -1, "0440 Kyrgyz")
  AddGadgetItem(Gadget, -1, "0426 Latvian")
  AddGadgetItem(Gadget, -1, "0427 Lithuanian")
  AddGadgetItem(Gadget, -1, "0827 Lithuanian (Classic)")
  AddGadgetItem(Gadget, -1, "042f Macedonian (FYROM)")
  AddGadgetItem(Gadget, -1, "043e Malay (Malaysian)")
  AddGadgetItem(Gadget, -1, "083e Malay (Brunei Darussalam)")
  AddGadgetItem(Gadget, -1, "044c Malayalam (India)")
  AddGadgetItem(Gadget, -1, "0481 Maori (New Zealand)")
  AddGadgetItem(Gadget, -1, "043a Maltese (Malta)")
  AddGadgetItem(Gadget, -1, "044e Marathi")
  AddGadgetItem(Gadget, -1, "0450 Mongolian")
  AddGadgetItem(Gadget, -1, "0414 Norwegian (Bokmal)")
  AddGadgetItem(Gadget, -1, "0814 Norwegian (Nynorsk)")
  AddGadgetItem(Gadget, -1, "0415 Polish")
  AddGadgetItem(Gadget, -1, "0416 Portuguese (Brazil)")
  AddGadgetItem(Gadget, -1, "0816 Portuguese (Portugal)")
  AddGadgetItem(Gadget, -1, "0446 Punjabi")
  AddGadgetItem(Gadget, -1, "046b Quechua (Bolivia)")
  AddGadgetItem(Gadget, -1, "086b Quechua (Ecuador)")
  AddGadgetItem(Gadget, -1, "0c6b Quechua (Peru)")
  AddGadgetItem(Gadget, -1, "0418 Romanian")
  AddGadgetItem(Gadget, -1, "0419 Russian")
  AddGadgetItem(Gadget, -1, "044f Sanskrit")
  AddGadgetItem(Gadget, -1, "043b Sami, Northern (Norway)")
  AddGadgetItem(Gadget, -1, "083b Sami, Northern (Sweden)")
  AddGadgetItem(Gadget, -1, "0c3b Sami, Northern (Finland)")
  AddGadgetItem(Gadget, -1, "103b Sami, Lule (Norway)")
  AddGadgetItem(Gadget, -1, "143b Sami, Lule (Sweden)")
  AddGadgetItem(Gadget, -1, "183b Sami, Southern (Norway)")
  AddGadgetItem(Gadget, -1, "1c3b Sami, Southern (Sweden)")
  AddGadgetItem(Gadget, -1, "203b Sami, Skolt (Finland)")
  AddGadgetItem(Gadget, -1, "243b Sami, Inari (Finland)")
  AddGadgetItem(Gadget, -1, "0c1a Serbian (Cyrillic)")
  AddGadgetItem(Gadget, -1, "1c1a Serbian (Cyrillic, Bosnia and Herzegovin)")
  AddGadgetItem(Gadget, -1, "081a Serbian (Latin)")
  AddGadgetItem(Gadget, -1, "181a Serbian (Latin, Bosnia and Herzegovin)")
  AddGadgetItem(Gadget, -1, "046c Sesotho sa Leboa/Northern sort")
  AddGadgetItem(Gadget, -1, "0432 Setswana/Tswana (South Africa)")
  AddGadgetItem(Gadget, -1, "041b Slovak")
  AddGadgetItem(Gadget, -1, "0424 Slovenian")
  AddGadgetItem(Gadget, -1, "040a Spanish (Spain, Traditional Sort)")
  AddGadgetItem(Gadget, -1, "080a Spanish (Mexican)")
  AddGadgetItem(Gadget, -1, "0c0a Spanish (Spain, Modern Sort)")
  AddGadgetItem(Gadget, -1, "100a Spanish (Guatemala)")
  AddGadgetItem(Gadget, -1, "140a Spanish (Costa Rica)")
  AddGadgetItem(Gadget, -1, "180a Spanish (Panama)")
  AddGadgetItem(Gadget, -1, "1c0a Spanish (Dominican Republic)")
  AddGadgetItem(Gadget, -1, "200a Spanish (Venezuela)")
  AddGadgetItem(Gadget, -1, "240a Spanish (Colombia)")
  AddGadgetItem(Gadget, -1, "280a Spanish (Peru)")
  AddGadgetItem(Gadget, -1, "2c0a Spanish (Argentina)")
  AddGadgetItem(Gadget, -1, "300a Spanish (Ecuador)")
  AddGadgetItem(Gadget, -1, "340a Spanish (Chile)")
  AddGadgetItem(Gadget, -1, "380a Spanish (Uruguay)")
  AddGadgetItem(Gadget, -1, "3c0a Spanish (Paraguay)")
  AddGadgetItem(Gadget, -1, "400a Spanish (Bolivia)")
  AddGadgetItem(Gadget, -1, "440a Spanish (El Salvador)")
  AddGadgetItem(Gadget, -1, "480a Spanish (Honduras)")
  AddGadgetItem(Gadget, -1, "4c0a Spanish (Nicaragua)")
  AddGadgetItem(Gadget, -1, "500a Spanish (Puerto Rico)")
  AddGadgetItem(Gadget, -1, "0430 Sutu")
  AddGadgetItem(Gadget, -1, "0441 Swahili (Kenya)")
  AddGadgetItem(Gadget, -1, "041d Swedish")
  AddGadgetItem(Gadget, -1, "081d Swedish (Finland)")
  AddGadgetItem(Gadget, -1, "045a Syriac")
  AddGadgetItem(Gadget, -1, "0449 Tamil")
  AddGadgetItem(Gadget, -1, "0444 Tatar (Tararstan)")
  AddGadgetItem(Gadget, -1, "044a Telugu")
  AddGadgetItem(Gadget, -1, "041e Thai")
  AddGadgetItem(Gadget, -1, "041f Turkish")
  AddGadgetItem(Gadget, -1, "0422 Ukrainian")
  AddGadgetItem(Gadget, -1, "0420 Urdu (Pakistan)")
  AddGadgetItem(Gadget, -1, "0820 Urdu (India)")
  AddGadgetItem(Gadget, -1, "0443 Uzbek (Latin)")
  AddGadgetItem(Gadget, -1, "0843 Uzbek (Cyrillic)")
  AddGadgetItem(Gadget, -1, "042a Vietnamese")
  AddGadgetItem(Gadget, -1, "0452 Welsh (United Kingdom)")
EndMacro       
Macro M_ClearLngName(Name)
  ; )     => Null
  ; (     => Null
  ; /     => _
  ; .     => Null
  ; Space => _
  ReplaceString(ReplaceString(ReplaceString(ReplaceString(ReplaceString(Name, ")", ""), "(", ""), "/", "_"), ".", ""), " ", "_")
EndMacro

Procedure Main_CB(Window, Message, wParam, lParam)
  Protected Tree_ContextMenu.TV_HITTESTINFO
  ReturnValue = #PB_ProcessPureBasicEvents
  Select Message
    Case #WM_NOTIFY
      *NotifyMsgInfos.NMHEADER = lParam
      If  *NotifyMsgInfos\hdr\code = #HDN_ITEMCHANGING  
      ; test if value of msg is HDN_ITEMCHANGING
        If *NotifyMsgInfos\iItem >= 0  And  *NotifyMsgInfos\iItem < 2 
        ; all columns index (2 columns, index 0 to 2 (2 is the empty last))
          ReturnValue = #True
        EndIf
      EndIf
  EndSelect
  ProcedureReturn ReturnValue
EndProcedure
Procedure Main_Open()
  If OpenWindow(#Main_Window_0, 229, 114, 700, 480, "REventLog - DLLCreator",  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered )
    If CreateGadgetList(WindowID(#Main_Window_0))
      TreeGadget(#Main_Tree_0, 10, 10, 150, 310, #PB_Tree_AlwaysShowSelection)
        AddGadgetItem(#Main_Tree_0, 0, "Language", 0, 0)
      ListIconGadget(#Main_ListIcon_0, 170, 10, 520, 310, "ID", 50)
        AddGadgetColumn(#Main_ListIcon_0, 1, "Content", 465)
      
      TextGadget(#Text_0, 10, 330, 150, 20, "Microsoft SDK's path :")
      StringGadget(#String_0, 170, 330, 450, 20, "", #PB_String_ReadOnly)
      ButtonGadget(#Button_1, 630, 330, 60, 20, "Browse")
      
      TextGadget(#Main_Text_1, 10, 360, 150, 20, "DLL Path :")
      StringGadget(#Main_String_1, 170, 360, 450, 20, "", #PB_String_ReadOnly)
      ButtonGadget(#Main_Button_2, 630, 360, 60, 20, "Browse")
      
      ButtonGadget(#Button_0, 10, 390, 100, 80, "Generate the DLL", #PB_Button_MultiLine)
      EditorGadget(#Editor_0, 120, 390, 570, 80, #PB_Editor_ReadOnly)
    EndIf
    If CreatePopupMenu(0)
        MenuItem(#Main_Menu_000, "Add a language...")
    EndIf
    If CreatePopupMenu(1)
        MenuItem(#Main_Menu_001, "Delete a language")
        MenuItem(#Main_Menu_002, "Edit a language")
        MenuItem(#Main_Menu_003, "Copy Language to...")
    EndIf
    If CreatePopupMenu(2)
        MenuItem(#Main_Menu_004, "Add an entry...")
    EndIf
    If CreatePopupMenu(3)
        MenuItem(#Main_Menu_005, "Delete an entry")
        MenuItem(#Main_Menu_006, "Edit an entry")
        MenuItem(#Main_Menu_007, "Copy entry to...")
    EndIf
    SetWindowCallback(@Main_CB())
  EndIf
EndProcedure

Procedure Lng_Change()
  ClearList(N_EntryTmp())
  HideGadget(#Main_ListIcon_0, #True)
  ClearGadgetItemList(#Main_ListIcon_0)
  If G_CurrentLng <> ""
    With N_EntryTmp()
      ForEach N_EntryLng()
        If N_EntryLng()\Lng = G_CurrentLng
          AddElement(N_EntryTmp())
          \ID     = N_EntryLng()\Entry\ID
          \Content= N_EntryLng()\Entry\Content
        EndIf
      Next
      SortStructuredList(N_EntryTmp(), 2, OffsetOf(S_Entry\ID), #PB_Sort_Long)
      ForEach N_EntryTmp()
        AddGadgetItem(#Main_ListIcon_0, -1, Str(\ID)+Chr(10)+\Content)
      Next
    EndWith
  EndIf
  HideGadget(#Main_ListIcon_0, #False)
EndProcedure
Procedure Lng_Main(Type.l)
  Protected P_Quit.l = #False, P_Found.l = #False
  Protected P_LngChosen.s, P_Title.s, P_Content.s, P_OldContent.s, P_Tmp.s
  Select Type
    Case #TYPE_ADD
      P_Title         = "Add a language..."
      P_Content.s     = ""
    Case #TYPE_EDIT
      P_Title         = "Edit a language..."
      P_Content.s     = GetGadgetItemText(#Main_Tree_0, GetGadgetState(#Main_Tree_0))
      P_OldContent.s  = GetGadgetItemText(#Main_Tree_0, GetGadgetState(#Main_Tree_0))
    Case #TYPE_COPY
      P_Title         = "Copy a language..."
      P_Content.s     = GetGadgetItemText(#Main_Tree_0, GetGadgetState(#Main_Tree_0))
      P_OldContent.s  = GetGadgetItemText(#Main_Tree_0, GetGadgetState(#Main_Tree_0))
  EndSelect

  If OpenWindow(#LngRequester_Window_0,0,0, 250,75,P_Title, #PB_Window_TitleBar|#PB_Window_ScreenCentered, WindowID(#Main_Window_0))
    HideWindow(#LngRequester_Window_0, #True)
    CreateGadgetList(WindowID(#LngRequester_Window_0))
    TextGadget(#LngRequester_Text_0, 5,15,60,20, "Language :", #PB_Text_Center)
    ComboBoxGadget(#LngRequester_Combo_0, 70, 10, 170, 200)
      M_AddAllLng(#LngRequester_Combo_0)
    ButtonGadget(#LngRequester_Button_0, 065, 45, 40, 22, "OK")
    ButtonGadget(#LngRequester_Button_1, 115, 45, 70, 22, "Cancel")
    ;{
      Select Type
        Case #TYPE_ADD
          SetGadgetState(#LngRequester_Combo_0, 0)
        Case #TYPE_EDIT
          For P_Inc = 0 To CountGadgetItems(#LngRequester_Combo_0) - 1
            If GetGadgetItemText(#LngRequester_Combo_0, P_Inc) = P_Content
              SetGadgetState(#LngRequester_Combo_0, P_Inc)
              Break
            EndIf
          Next
        Case #TYPE_COPY
          ResizeWindow(#LngRequester_Window_0,#PB_Ignore,#PB_Ignore, 250,95)
          SetGadgetText(#LngRequester_Text_0, "From")
          TextGadget(#LngRequester_Text_1, 05, 40, 060, 020, "To :", #PB_Text_Center)
          TextGadget(#LngRequester_Text_2, 70, 15, 170, 200, P_Content)
          ResizeGadget(#LngRequester_Combo_0, 70, 35, 170, 200)
          ResizeGadget(#LngRequester_Button_0, 065, 70, 40, 22)
          ResizeGadget(#LngRequester_Button_1, 115, 70, 70, 22)
      EndSelect
    ;}
    HideWindow(#LngRequester_Window_0, #False)
    Repeat
      LEvent  = WaitWindowEvent()
      LGadget = EventGadget()
      LWindow = EventWindow()
      If LWindow = #LngRequester_Window_0 And LEvent = #PB_Event_Gadget
        Select LGadget
          Case #LngRequester_Button_0 ; OK
          ;{
            P_Content = GetGadgetText(#LngRequester_Combo_0)
            P_Found = #False
            P_Quit  = #True
            For P_Inc = 1 To CountGadgetItems(#Main_Tree_0) - 1
              If GetGadgetItemText(#Main_Tree_0, P_Inc) = P_Content
                P_Found = #True
                P_Quit  = #False
                MessageRequester("REventLog - DLLCreator", "Language ever in the list.")
                Break
              Else
                P_Found = #False
                P_Quit  = #True
              EndIf
            Next
          ;}
          Case #LngRequester_Button_1 ; Cancel
          ;{
            P_Found = -1
            P_Quit = #True
          ;}
        EndSelect
      EndIf
    Until P_Quit = #True
    CloseWindow(#LngRequester_Window_0)
    SetActiveWindow(#Main_Window_0)
    If P_Found = #False
      Select Type
        Case #TYPE_ADD
        ;{
          AddGadgetItem(#Main_Tree_0, CountGadgetItems(#Main_Tree_0), P_Content, 0, 1)
          If CountGadgetItems(#Main_Tree_0) >= 2
            SetGadgetItemState(#Main_Tree_0, 0, #PB_Tree_Expanded)
          EndIf
          If CountGadgetItems(#Main_Tree_0) > 2
            ClearList(N_EntryLngTmp())
            ; Copie du 2nd item soit de la 1ere lng dans une liste
            P_Tmp = GetGadgetItemText(#Main_Tree_0, 1)
            ForEach N_EntryLng()
              With N_EntryLng()
                If \Lng = Left(P_Tmp, 4)
                  AddElement(N_EntryLngTmp())
                  N_EntryLngTmp()\Lng = Left(P_Content,4)
                  N_EntryLngTmp()\Entry\ID = \Entry\ID
                EndIf
              EndWith
            Next
            ; Copie le contenu de la liste dans la liste principale
            ForEach N_EntryLngTmp()
              With N_EntryLngTmp()
                AddElement(N_EntryLng())
                N_EntryLng()\Lng      = \Lng
                N_EntryLng()\Entry\ID = \Entry\ID
              EndWith
            Next
            ClearList(N_EntryLngTmp())
          EndIf
          
        ;}
        Case #TYPE_EDIT
        ;{
          SetGadgetItemText(#Main_Tree_0, GetGadgetState(#Main_Tree_0), P_Content)
          ForEach N_EntryLng()
            If N_EntryLng()\Lng = Left(P_OldContent, 4)
              N_EntryLng()\Lng = Left(P_Content, 4)
            EndIf
          Next
          Lng_Change()
        ;}
        Case #TYPE_COPY
        ;{
          AddGadgetItem(#Main_Tree_0, CountGadgetItems(#Main_Tree_0), P_Content, 0, 1)
          ForEach N_EntryLng()
            If N_EntryLng()\Lng = Left(P_OldContent, 4)
              P_OldID                     = N_EntryLng()\Entry\ID
              P_OldContent                = N_EntryLng()\Entry\Content
              InsertElement(N_EntryLng())
              N_EntryLng()\Lng            = Left(P_Content, 4)
              N_EntryLng()\Entry\ID       = P_OldID
              N_EntryLng()\Entry\Content  = P_OldContent
            EndIf
          Next
          Lng_Change()
        ;}
      EndSelect
    EndIf
  EndIf
EndProcedure

Procedure Lng_Add()
  Lng_Main(#TYPE_ADD)
EndProcedure
Procedure Lng_Edit()
  Lng_Main(#TYPE_EDIT)
EndProcedure
Procedure Lng_Del()
  Protected Res.l
  Protected P_State.l     = GetGadgetState(#Main_Tree_0)
  Protected P_Language.s  = GetGadgetItemText(#Main_Tree_0, P_State.l)
  Res = MessageRequester("Delete a language...", "Do you really want to delete the language '"+P_Language+"'?", #PB_MessageRequester_YesNo)
  If Res = #PB_MessageRequester_Yes
    RemoveGadgetItem(#Main_Tree_0, P_State)
    If CountGadgetItems(#Main_Tree_0) = 1
      G_CurrentLng = ""
    Else
      SetGadgetState(#Main_Tree_0, 1)
    EndIf
    With N_EntryLng()
      ForEach N_EntryLng()
        If \Lng = Left(P_Language, 4)
          DeleteElement(N_EntryLng(), #True)
        EndIf
      Next
    EndWith
    Lng_Change()
  EndIf
EndProcedure
Procedure Lng_Copy()
  Lng_Main(#TYPE_COPY)
EndProcedure

Procedure Entry_Main(Type.l)
  Protected P_Quit.l = #False, P_Found.l = #False, P_Inc.l
  Protected P_LngChosen.s, P_Title.s, P_ID.s, P_Content.s, P_OldID.s, P_OldContent.s
  Select Type
    Case #TYPE_ADD
      P_Title.s     = "Add an entry..."
      P_ID.s        = ""
      P_Content.s   = ""
    Case #TYPE_EDIT
      P_Title.s     = "Edit an entry..."
      P_OldID.s     = GetGadgetItemText(#Main_ListIcon_0, GetGadgetState(#Main_ListIcon_0), 0)
      P_ID.s        = GetGadgetItemText(#Main_ListIcon_0, GetGadgetState(#Main_ListIcon_0), 0)
      P_OldContent.s= GetGadgetItemText(#Main_ListIcon_0, GetGadgetState(#Main_ListIcon_0), 1)
      P_Content.s   = GetGadgetItemText(#Main_ListIcon_0, GetGadgetState(#Main_ListIcon_0), 1)
    Case #TYPE_DEL
      P_Title.s     = "Delete an entry..."
      P_ID.s        = GetGadgetItemText(#Main_ListIcon_0, GetGadgetState(#Main_ListIcon_0), 0)
      P_Content.s   = GetGadgetItemText(#Main_ListIcon_0, GetGadgetState(#Main_ListIcon_0), 1)
    Case #TYPE_COPY
      P_Title.s     = "Copy an entry..."
      P_OldID.s     = ""
      P_ID.s        = GetGadgetItemText(#Main_ListIcon_0, GetGadgetState(#Main_ListIcon_0), 0)
      P_OldContent.s= ""
      P_Content.s   = GetGadgetItemText(#Main_ListIcon_0, GetGadgetState(#Main_ListIcon_0), 1)
  EndSelect
  If OpenWindow(#EntryRequester_Window_0,0,0, 250,95,P_Title, #PB_Window_TitleBar|#PB_Window_ScreenCentered, WindowID(#Main_Window_0))
    HideWindow(#EntryRequester_Window_0, #True)
    CreateGadgetList(WindowID(#EntryRequester_Window_0))
    TextGadget(#EntryRequester_Text_0, 5,15,70,20, "ID :", #PB_Text_Right)
    TextGadget(#EntryRequester_Text_1, 5,40,70,20, "Content :", #PB_Text_Right)
    ButtonGadget(#EntryRequester_Button_0, 065, 70, 40, 22, "OK")
    ButtonGadget(#EntryRequester_Button_1, 115, 70, 70, 22, "Cancel")
    If Type = #TYPE_COPY
      StringGadget(#EntryRequester_String_0, 80, 10, 160, 20, P_ID, #PB_String_Numeric|#PB_String_ReadOnly)
      StringGadget(#EntryRequester_String_1, 80, 35, 160, 20, P_Content, #PB_String_ReadOnly)
      ResizeWindow(#EntryRequester_Window_0, #PB_Ignore, #PB_Ignore, #PB_Ignore, WindowHeight(#EntryRequester_Window_0)+50)
      TextGadget(#EntryRequester_Text_2, 5,65,70,20, "New ID :", #PB_Text_Right)
      StringGadget(#EntryRequester_String_2, 80, 60, 160, 20, "", #PB_String_Numeric)
      TextGadget(#EntryRequester_Text_3, 5,90,70,20, "New Content :", #PB_Text_Right)
      StringGadget(#EntryRequester_String_3, 80, 85, 160, 20, P_Content+"_")
      ResizeGadget(#EntryRequester_Button_0, #PB_Ignore, 120, #PB_Ignore, #PB_Ignore)
      ResizeGadget(#EntryRequester_Button_1, #PB_Ignore, 120, #PB_Ignore, #PB_Ignore)
    Else
      StringGadget(#EntryRequester_String_0, 80, 10, 160, 20, P_ID, #PB_String_Numeric)
      StringGadget(#EntryRequester_String_1, 80, 35, 160, 20, P_Content)
    EndIf
    HideWindow(#EntryRequester_Window_0, #False)
    Repeat
      LEvent  = WaitWindowEvent()
      LGadget = EventGadget()
      LWindow = EventWindow()
      If LWindow = #EntryRequester_Window_0 And LEvent = #PB_Event_Gadget
        Select LGadget
          Case #EntryRequester_Button_0 ; OK
          ;{
            Select Type
              Case #TYPE_ADD
              ;{
                ; recherche si ID existe déjà ou si content existe déjà
                For P_Inc = 0 To CountGadgetItems(#Main_ListIcon_0) - 1
                  P_ID      = GetGadgetItemText(#Main_ListIcon_0, P_Inc, 0)
                  P_Content = GetGadgetItemText(#Main_ListIcon_0, P_Inc, 1)
                  If P_ID = GetGadgetText(#EntryRequester_String_0)
                    MessageRequester("REventLog - DLLCreator", "ID ever in the list.")
                    P_Found = #True
                  ElseIf P_Content = GetGadgetText(#EntryRequester_String_1)
                    MessageRequester("REventLog - DLLCreator", "Content ever in the list.")
                    P_Found = #True
                  EndIf
                Next
                P_ID      = GetGadgetText(#EntryRequester_String_0)
                P_Content = GetGadgetText(#EntryRequester_String_1)
                If P_Found = #False
                  For P_Inc = 1 To CountGadgetItems(#Main_Tree_0)-1
                    AddElement(N_EntryLng())
                    With N_EntryLng()
                      \Lng      = Left(GetGadgetItemText(#Main_Tree_0, P_Inc), 4)
                      \Entry\ID = Val(P_ID)
                      If \Lng = G_CurrentLng
                        \Entry\Content= P_Content
                      EndIf
                    EndWith
                  Next
                  Lng_Change()
                  P_Quit  = #True
                EndIf
                P_Found = #False
              ;}
              Case #TYPE_EDIT
              ;{
                ; recherche si ID existe déjà ou si content existe déjà
                For P_Inc = 0 To CountGadgetItems(#Main_ListIcon_0) - 1
                  P_ID      = GetGadgetItemText(#Main_ListIcon_0, P_Inc, 0)
                  P_Content = GetGadgetItemText(#Main_ListIcon_0, P_Inc, 1)
                  If P_ID <> P_OldID
                    If P_ID = GetGadgetText(#EntryRequester_String_0)
                      MessageRequester("REventLog - DLLCreator", "ID ever in the list.")
                      P_Found = #True
                    EndIf
                  EndIf
                  If P_Content <> P_OldContent
                    If P_Content = GetGadgetText(#EntryRequester_String_1)
                      MessageRequester("REventLog - DLLCreator", "Content ever in the list.")
                      P_Found = #True
                    EndIf
                  EndIf
                Next
                P_ID      = GetGadgetText(#EntryRequester_String_0)
                P_Content = GetGadgetText(#EntryRequester_String_1)
                If P_Found = #False
                  ForEach N_EntryLng()
                    With N_EntryLng()
                      If \Lng = G_CurrentLng And \Entry\ID = Val(P_OldID) And \Entry\Content= P_OldContent
                        \Entry\ID     = Val(P_ID)
                        \Entry\Content= P_Content
                      EndIf
                    EndWith
                  Next
                  Lng_Change()
                  P_Quit  = #True
                EndIf
                P_Found = #False
              ;}
              Case #TYPE_DEL
              ;{
                ForEach N_EntryLng()
                  With N_EntryLng()
                    If \Entry\ID = Val(P_ID)
                      DeleteElement(N_EntryLng())
                    EndIf
                  EndWith
                Next
                Lng_Change()
                P_Quit  = #True
              ;}
              Case #TYPE_COPY
              ;{
                ; recherche si ID existe déjà ou si content existe déjà
                For P_Inc = 0 To CountGadgetItems(#Main_ListIcon_0) - 1
                  P_ID      = GetGadgetItemText(#Main_ListIcon_0, P_Inc, 0)
                  P_Content = GetGadgetItemText(#Main_ListIcon_0, P_Inc, 1)
                  If P_ID = GetGadgetText(#EntryRequester_String_2)
                    MessageRequester("REventLog - DLLCreator", "ID ever in the list.")
                    P_Found = #True
                  ElseIf P_Content = GetGadgetText(#EntryRequester_String_3)
                    MessageRequester("REventLog - DLLCreator", "Content ever in the list.")
                    P_Found = #True
                  EndIf
                Next
                P_ID      = GetGadgetText(#EntryRequester_String_2)
                P_Content = GetGadgetText(#EntryRequester_String_3)
                If P_Found = #False
                  For P_Inc = 1 To CountGadgetItems(#Main_Tree_0)
                    AddElement(N_EntryLng())
                    With N_EntryLng()
                      \Lng      = Left(GetGadgetItemText(#Main_Tree_0, P_Inc), 4)
                      \Entry\ID = Val(P_ID)
                      If \Lng = G_CurrentLng
                        \Entry\Content= P_Content
                      EndIf
                    EndWith
                  Next
                  Lng_Change()
                  P_Quit  = #True
                EndIf
                P_Found = #False
              ;}
            EndSelect
          ;}
          Case #EntryRequester_Button_1 ; Cancel
          ;{
            P_Found = -1
            P_Quit = #True
          ;}
        EndSelect
      EndIf
    Until P_Quit = #True
    CloseWindow(#EntryRequester_Window_0)
    SetActiveWindow(#Main_Window_0)
  EndIf
EndProcedure

Procedure Entry_Add()
  Entry_Main(#TYPE_ADD)
EndProcedure
Procedure Entry_Edit()
  Entry_Main(#TYPE_EDIT)
EndProcedure
Procedure Entry_Del()
  Entry_Main(#TYPE_DEL)
EndProcedure
Procedure Entry_Copy()
  Entry_Main(#TYPE_COPY)
EndProcedure

Procedure DLL_Generate()
  Protected CompilDLLPath.s, CompilDLLPathW.s
  Protected Lng_Item.s, Lng_Name.s, Lng_Hex.s
  Protected Compil_Name.s
  Protected Compil_MC.s, Compil_RC.s, Compil_Link.s
  Protected Inc.l, OldID.l = -1
  
  If G_SDKPath = ""
    AddGadgetItem(#Editor_0, -1, "Error : Bad Microsoft SDK's Path")
  ElseIf G_DLLPath = ""
    AddGadgetItem(#Editor_0, -1, "Error : Empty DLL's Name")
  ElseIf CountGadgetItems(#Main_Tree_0) = 1
    AddGadgetItem(#Editor_0, -1, "Error : Add at least a language")
  ElseIf CountList(N_EntryLng()) = 0
    AddGadgetItem(#Editor_0, -1, "Error : Add at least an entry")
  Else
    CompilDLLPath = GetPathPart(G_DLLPath)
    CompilDLLPathW= Left(CompilDLLPath, Len(CompilDLLPath) - 1)
    Compil_Name   = Mid(G_DLLPath, Len(CompilDLLPath)+1, Len(G_DLLPath) - Len(CompilDLLPath) - Len(GetExtensionPart(G_DLLPath)) - 1)
    ; Génération du fichier MC dans le dossier tmp
    AddGadgetItem(#Editor_0, -1, "> Generation of MC File")
    ;{
      If FileSize(CompilDLLPath + Compil_Name+".mc") > 0
        CreateFile(0, CompilDLLPath + Compil_Name + ".mc")
      Else
        OpenFile(0, CompilDLLPath + Compil_Name +".mc")
      EndIf
      For Inc = 1 To CountGadgetItems(#Main_Tree_0) -1
        Lng_Item  = GetGadgetItemText(#Main_Tree_0, Inc)
        Lng_Name  = Right(Lng_Item, Len(Lng_Item) -5)
        Lng_Name  = Left(M_ClearLngName(Lng_Name),20)
        Lng_Hex   = Left(Lng_Item,4)
        WriteStringN(0, "LanguageNames=("+Lng_Name+"=0x"+Lng_Hex+":MSG0"+UCase(RSet(Lng_Hex,4,"0")+")"))
      Next
      WriteStringN(0, "")
      WriteStringN(0, "")
      WriteStringN(0, ";//**************Definitions************")
      ForEach N_EntryLng()
        With N_EntryLng()
          ; MessageID
          If OldID <> \Entry\ID
            WriteStringN(0, "MessageId="+Str(\Entry\ID))
            OldID = \Entry\ID
          EndIf
          ; Langue
          For Inc = 1 To CountGadgetItems(#Main_Tree_0) -1
            Lng_Item  = GetGadgetItemText(#Main_Tree_0, Inc)
            If Left(Lng_Item,4) = \Lng
              Lng_Name  = Right(Lng_Item, Len(Lng_Item) -5)
              Lng_Name  = Left(M_ClearLngName(Lng_Name),20)
              WriteStringN(0, "Language="+Lng_Name)
              Break
            EndIf
          Next
          ; MessageContent
          WriteStringN(0, \Entry\Content)
          WriteStringN(0, ".")
        EndWith
      Next
      CloseFile(0)
    ;}
    ; MC
    AddGadgetItem(#Editor_0, -1, "> Compiling MC File to BIN")
    ;{
      Compil_MC = G_SDKPath+"bin\mc "
      Compil_MC + #DblQuote+CompilDLLPath+Compil_Name+".mc"+#DblQuote
      Compil_MC + " /V"
      Compil_MC + " /H "+#DblQuote+CompilDLLPathW+#DblQuote
      Compil_MC + " /R "+#DblQuote+CompilDLLPathW+#DblQuote
      AddGadgetItem(#Editor_0, -1, GetProgramResult(Compil_MC))
    ;}
    ; RC
    AddGadgetItem(#Editor_0, -1, "> Compiling RC File to RES")
    ;{
      Compil_RC = G_SDKPath+"bin\rc"
      Compil_RC + " -r"
      Compil_RC + " -fo "
      Compil_RC + #DblQuote+CompilDLLPath+Compil_Name+".res"+#DblQuote
      Compil_RC + " "
      Compil_RC + #DblQuote+CompilDLLPath+Compil_Name+".rc"+#DblQuote
      AddGadgetItem(#Editor_0, -1, GetProgramResult(Compil_RC))
    ;}
    ; LINK
    AddGadgetItem(#Editor_0, -1, "> Linking RES File to DLL")
    ;{
      Compil_Link = G_SDKPath+"bin\win64\link"
      Compil_Link + " -dll"
      Compil_Link + " -noentry"
      Compil_Link + " -out:"
      Compil_Link + #DblQuote+CompilDLLPath+Compil_Name+".dll"+#DblQuote
      Compil_Link + " "
      Compil_Link + #DblQuote+CompilDLLPath+Compil_Name+".res"+#DblQuote
      AddGadgetItem(#Editor_0, -1, GetProgramResult(Compil_Link))
    ;}
    ; Suppression de tout sf de la DLL
    AddGadgetItem(#Editor_0, -1, "> Removing DLL Temporary Files")
    ;{
      ; MC
      DeleteFile(CompilDLLPath + Compil_Name + ".mc")
      ; RC
      DeleteFile(CompilDLLPath + Compil_Name + ".rc")
      ; H
      DeleteFile(CompilDLLPath + Compil_Name + ".h")
      ; RES
      DeleteFile(CompilDLLPath + Compil_Name + ".res")
      ; BIN
      For Inc = 1 To CountGadgetItems(#Main_Tree_0) -1
        Lng_Item  = GetGadgetItemText(#Main_Tree_0, Inc)
        Lng_Hex   = Left(Lng_Item,4)
        DeleteFile(CompilDLLPath + "MSG0"+UCase(RSet(Lng_Hex,4,"0")+".bin"))
      Next
    ;}
  EndIf
EndProcedure

Main_Open()
        
Repeat
  Event   = WaitWindowEvent()
  Gadget  = EventGadget()
  Menu    = EventMenu()
  Select Event
    Case #PB_Event_Gadget
    ;{
      Select Gadget
        Case #Button_0 ; Generate the DLL
        ;{
          DLL_Generate()
        ;}
        Case #Button_1 ; Browse
        ;{
          G_SDKPath = PathRequester("Choose the Microsoft SDK's Path", "C:\")
          If G_SDKPath
            If FileSize(G_SDKPath+"bin\rc.exe") > 0 And FileSize(G_SDKPath+"bin\mc.exe") > 0 And FileSize(G_SDKPath+"bin\win64\link.exe") > 0
              SetGadgetText(#String_0, G_SDKPath)
            Else
              MessageRequester("REventLog DLL Creator", "Bad Microsoft SDK's Path")
            EndIf
          EndIf
        ;}
        Case #Main_Button_2 ; browse DLL path
        ;{
          G_DLLPath = SaveFileRequester("Choose DLL File to save", "", "DLL Files|*.dll",0)
          If G_DLLPath
            SetGadgetText(#Main_String_1, G_DLLPath)
          EndIf
        ;}
        Case #Main_ListIcon_0
        ;{
          Define.l P_ListIconState = GetGadgetState(#Main_ListIcon_0)
          Select EventType()
            Case #PB_EventType_RightClick
            ;{
              If G_CurrentLng <> ""
                If P_ListIconState >= 0 And P_ListIconState < CountGadgetItems(#Main_ListIcon_0)
                  SetGadgetItemState(#Main_ListIcon_0, P_ListIconState, #PB_ListIcon_Selected) 
                  DisplayPopupMenu(3, WindowID(#Main_Window_0))
                Else
                  DisplayPopupMenu(2, WindowID(#Main_Window_0))
                EndIf
              EndIf
            ;}
          EndSelect
        ;}
        Case #Main_Tree_0
        ;{
          Define.l P_State = GetGadgetState(#Main_Tree_0)
          Select EventType()
            Case #PB_EventType_RightClick
              If P_State = 0
                SetGadgetItemState(#Main_Tree_0, 0, #PB_Tree_Expanded|#PB_Tree_Selected) 
                DisplayPopupMenu(0, WindowID(#Main_Window_0))
              ElseIf P_State >= 1 And P_State < CountGadgetItems(#Main_Tree_0)
                SetGadgetItemState(#Main_Tree_0, P_State, #PB_Tree_Selected) 
                DisplayPopupMenu(1, WindowID(#Main_Window_0))
              EndIf
            Case #PB_EventType_Change
              If P_State > 0 And P_State < CountGadgetItems(#Main_Tree_0) 
                G_CurrentLng = Left(GetGadgetItemText(#Main_Tree_0, P_State), 4)
                Lng_Change()
              EndIf
          EndSelect
        ;}
      EndSelect
    ;}
    Case #PB_Event_Menu
    ;{
      Select Menu
        Case #Main_Menu_000 ; Add a language
        ;{
          Lng_Add()
        ;}
        Case #Main_Menu_001 ; Delete a language
        ;{
          Lng_Del()
        ;}
        Case #Main_Menu_002 ; Edit a language
        ;{
          Lng_Edit()
        ;}
        Case #Main_Menu_003 ; Copy Language to
        ;{
          Lng_Copy()
        ;}
        Case #Main_Menu_004 ; Add an entry
        ;{
          Entry_Add()
        ;}
        Case #Main_Menu_005 ; Delete an entry
        ;{
          Entry_Del()
        ;}
        Case #Main_Menu_006 ; Edit an entry
        ;{
          Entry_Edit()
        ;}
        Case #Main_Menu_007 ; Copy entry to
        ;{
          Entry_Copy()
        ;}
      EndSelect
    ;}
  EndSelect
Until Event = #PB_Event_CloseWindow


; TD : Quand on add un lng aprés les autres, il faut aussi rajouter ttes les entries dispos
; TD : Quand on add la première lng, auto dépliage du tree
; TD : Dans le tree, toujours always show selection
; TD : Avant la compilation, vérifier au moins une entry
; TD : Pas de resize pour la fenetre
; TD : Editor, readonly
; TD : Quand on supprime une entry, cela supprime pour tt les lng

;-TD : Shortcuts

; IDE Options = PureBasic 4.10 (Windows - x86)
; CursorPosition = 768
; FirstLine = 25
; Folding = AAAAAAAAAAAAAAAAAAAAAAAAw
; EnableUnicode
; EnableXP
; IncludeVersionInfo
; VersionField0 = 1.0.0.0
; VersionField1 = 1.0.0.0
; VersionField2 = RootsLabs
; VersionField3 = REventLog_DLLCreator
; VersionField4 = 1.0.0.0
; VersionField5 = 0.1.0.0
; VersionField6 = Generates Ressource-only DLL
; VersionField9 = RootsLabs
; VersionField13 = progi1984@gmail.com
; VersionField14 = http://progi1984.free.fr
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_APP
; VersionField17 = 0809 English (United Kingdom)