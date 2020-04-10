#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Icon.ico
#AutoIt3Wrapper_Outfile=..\build\Soundwagen.exe
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Tidy_Parameters=/keepnversions=0
#NoTrayIcon

#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListBoxConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Global $ResBase = RegRead("HKEY_CLASSES_ROOT\Software\Software Untergrund\EEXP", "ResBase")
Global $ArrayNamen[1]
Global $ArrayPfade[1]

#Region ### START Koda GUI section ### Form=.\gui.kxf
$GUI = GUICreate("Soundwagen in Zugverbände einfügen", 500, 330, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME))
$LabelZVLoad = GUICtrlCreateLabel("Zugverband laden:", 10, 12, 94, 17, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$InputZVLoad = GUICtrlCreateInput("", 110, 10, 345, 21, $GUI_SS_DEFAULT_INPUT)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$ButtonZVLoad = GUICtrlCreateButton("...", 465, 8, 25, 25, 0)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$List1 = GUICtrlCreateList("", 10, 40, 480, 175, BitOR($LBS_NOTIFY, $LBS_SORT, $LBS_NOINTEGRALHEIGHT, $LBS_MULTICOLUMN, $WS_BORDER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
GUICtrlSetTip(-1, "Einen Soundwagen auswählen und Rechtsklicken, um die Sounds anzuhören")
$List1context = GUICtrlCreateContextMenu($List1)
$MenuItemRoll = GUICtrlCreateMenuItem("Rollsound abspielen", $List1context)
$MenuItemBrems = GUICtrlCreateMenuItem("Bremssound abspielen", $List1context)
$MenuItemKurve = GUICtrlCreateMenuItem("Kurvensound abspielen", $List1context)
$MenuItemAnfahr = GUICtrlCreateMenuItem("Anfahrsound abspielen", $List1context)
$Label1 = GUICtrlCreateLabel("Nach jedem", 10, 227, 61, 17, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Input1 = GUICtrlCreateInput("1", 75, 225, 37, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Updown1 = GUICtrlCreateUpdown($Input1, 0)
GUICtrlSetLimit(-1, 10, 1)
$Label2 = GUICtrlCreateLabel(". Wagen einen Soundwagen einfügen", 115, 227, 184, 17, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$LabelZVSave = GUICtrlCreateLabel("Zugverband speichern:", 10, 257, 114, 17, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$InputZVSave = GUICtrlCreateInput("", 130, 255, 325, 21, $GUI_SS_DEFAULT_INPUT)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$ButtonZVSave = GUICtrlCreateButton("...", 465, 253, 25, 25, 0)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$ButtonSave = GUICtrlCreateButton("Speichern", 145, 290, 100, 30, 0)
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$ButtonExit = GUICtrlCreateButton("Beenden", 255, 290, 100, 30, 0)
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

ReadSoundList()
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ButtonExit
			Exit
		Case $MenuItemAnfahr
			PlaySound("Anfahr")
		Case $MenuItemBrems
			PlaySound("Bremse")
		Case $MenuItemKurve
			PlaySound("Kurven")
		Case $MenuItemRoll
			PlaySound("Rollen")
		Case $ButtonZVLoad
			BrowseZVLoad()
		Case $ButtonZVSave
			BrowseZVSave()
		Case $ButtonSave
			Save()
	EndSwitch
WEnd

Func ReadSoundList()
	Local $IniFile = @ScriptDir & "\Soundwagen.ini"
	Local $IniSection = "Soundwagen"
	Local $Anzahl = IniRead($IniFile, $IniSection, "Anzahl", 0)
	For $i = 1 To $Anzahl
		_ArrayAdd($ArrayNamen, IniRead($IniFile, $IniSection, "Name" & $i, "Fehler"))
		_ArrayAdd($ArrayPfade, IniRead($IniFile, $IniSection, "Pfad" & $i, "Fehler"))
	Next
	GUICtrlSetData($List1, _ArrayToString($ArrayNamen))
EndFunc   ;==>ReadSoundList

Func PlaySound($Type)
	Local $Selected = GUICtrlRead($List1)
	Local $Index = _ArraySearch($ArrayNamen, $Selected)
	Local $TxtFile = $ResBase & "\Rollmaterial" & StringReplace($ArrayPfade[$Index], ".gsb", ".txt")
	Local $TextFileContent = FileRead($TxtFile)
	Local $SoundFile = StringRegExp($TextFileContent, $Type & "\((.+?)\)", 1)
	If $SoundFile = "" Then
		MsgBox(48, "Soundwagen einfügen", "Der von dir gewählte Wagen scheint nicht installiert zu sein.")
		Return
	EndIf

	Local $SoundPath = $ResBase & "\Sounds\" & StringReplace($SoundFile[0], " ", "")
	SoundPlay($SoundPath)
EndFunc   ;==>PlaySound

Func BrowseZVLoad()
	Local $File = FileOpenDialog("Zugverband laden", $ResBase & "\Blocks\Rolling_Stock", "Zugverbände (*.rss)")
	GUICtrlSetData($InputZVLoad, $File)
	GUICtrlSetData($InputZVSave, $File)
EndFunc   ;==>BrowseZVLoad
Func BrowseZVSave()
	Local $File = FileSaveDialog("Zugverband speichern", GUICtrlRead($InputZVSave), "Zugverbände (*.rss)")
	GUICtrlSetData($InputZVSave, $File)
EndFunc   ;==>BrowseZVSave

Func Save()
	Local $RSSLoad = GUICtrlRead($InputZVLoad)
	Local $RSSSave = GUICtrlRead($InputZVSave)
	Local $JederXteWagen = GUICtrlRead($Input1)
	Local $Selected = GUICtrlRead($List1)
	Local $Index = _ArraySearch($ArrayNamen, $Selected)
	Local $ModelPath = $ArrayPfade[$Index]
	Local $ModelIni = $ResBase & "\" & StringReplace($ModelPath, ".gsb", ".ini")
	Local $ModelName = IniRead($ModelIni, "FileInfo", "Name_GER", "Soundwagen")
	Local $EingefuegteSoundwagen = 0

	Local $Fehlermeldung = ""
	If $RSSLoad = "" Then $Fehlermeldung &= "Bitte einen Zugverband auswählen, in den Soundwagen eingefügt werden sollen." & @CRLF
	If $RSSSave = "" Then $Fehlermeldung &= "Bitte auswählen, unter welchem (Datei-)Namen der neue Zugverband gespeichert werden soll." & @CRLF
	If $Selected = "" Then $Fehlermeldung &= "Bitte einen Soundwagen auswählen"

	If $Fehlermeldung <> "" Then
		MsgBox(16, "Soundwagen einfügen", $Fehlermeldung)
		Return
	EndIf

	;Einlesen des Zugverbands
	Local $Models[1]
	Local $Names[1]
	Local $Directions[1]
	Local $i = 1
	While 1
		Local $Model = IniRead($RSSLoad, "MODELS", StringFormat("%04i", $i), "Ende")
		If $Model = "Ende" Then ExitLoop
		_ArrayAdd($Models, $Model)
		$i = $i + 1
	WEnd
	$i = 0
	While 1
		Local $Name = IniRead($RSSLoad, "NAMES", StringFormat("%04i", $i), "Ende")
		If $Name = "Ende" Then ExitLoop
		_ArrayAdd($Names, $Name)
		$i = $i + 1
	WEnd
	_ArrayDelete($Names, 0)
	$i = 0
	While 1
		Local $Direction = IniRead($RSSLoad, "DIRECTIONS", StringFormat("%04i", $i), "Ende")
		If $Direction = "Ende" Then ExitLoop
		_ArrayAdd($Directions, $Direction)
		$i = $i + 1
	WEnd
	_ArrayDelete($Directions, 0)

	;Einfügen der Soundwagen
	$i = 1 + $JederXteWagen
	While $i < UBound($Models)
		_ArrayInsert($Models, $i, $ModelPath)
		$i += $JederXteWagen + 1
	WEnd
	$i = 1 + $JederXteWagen
	While $i < UBound($Names)
		$EingefuegteSoundwagen += 1
		_ArrayInsert($Names, $i, StringFormat("%s;%03i", $ModelName, $EingefuegteSoundwagen))
		$i += $JederXteWagen + 1
	WEnd
	$i = 1 + $JederXteWagen
	While $i < UBound($Directions)
		_ArrayInsert($Directions, $i, "0")
		$i += $JederXteWagen + 1
	WEnd


	Local $TrainLength = UBound($Models) - 1

	If FileExists($RSSSave) Then
		If MsgBox(36, "Soundwagen einfügen", "Soll der Zugverband überschrieben werden?") = 6 Then
			FileDelete($RSSSave)
		Else
			Return
		EndIf
	EndIf

	;Speichern des Zugverbands
	For $i = 1 To $TrainLength
		IniWrite($RSSSave, "MODELS", StringFormat("%04i", $i), '"' & $Models[$i] & '"')
	Next
	For $i = 0 To $TrainLength
		IniWrite($RSSSave, "NAMES", StringFormat("%04i", $i), '"' & $Names[$i] & '"')
	Next
	For $i = 0 To $TrainLength
		IniWrite($RSSSave, "DIRECTIONS", StringFormat("%04i", $i), $Directions[$i])
	Next

	MsgBox(64, "Soundwagen einfügen", "Es wurden " & $EingefuegteSoundwagen & " Soundwagen eingefügt.")

EndFunc   ;==>Save
