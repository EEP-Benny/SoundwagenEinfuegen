#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Icon.ico
#AutoIt3Wrapper_Outfile=..\build\Soundwagen.exe
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Tidy_Parameters=/keepnversions=0
#NoTrayIcon

#include <Array.au3>
#include <ButtonConstants.au3>
#include <ColorConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListBoxConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Global $ResBase = RegRead("HKEY_CLASSES_ROOT\Software\Software Untergrund\EEXP", "ResBase")
Global $ArrayNamen[0]
Global $ArrayPfade[0]

Global $ZugverbandData[0]
Global $MODEL = 0
Global $NAME = 1
Global $DIRECTION = 2

#Region ### START Koda GUI section ### Form=.\gui.kxf
$GUI = GUICreate("Soundwagen in Zugverbände einfügen", 500, 330, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME))
$LabelZVLoad = GUICtrlCreateLabel("Zugverband laden:", 10, 12, 94, 17, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$InputZVLoad = GUICtrlCreateInput("", 110, 10, 345, 21, $GUI_SS_DEFAULT_INPUT)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$ButtonZVLoad = GUICtrlCreateButton("...", 465, 8, 25, 25, 0)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$LabelMessage = GUICtrlCreateLabel("Kein Zugverband geladen.", 10, 40, 480, 17, $SS_LEFTNOWORDWRAP)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$CheckboxRemove = GUICtrlCreateCheckbox("Vorhandene Soundwagen entfernen", 10, 63, 480, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input1 = GUICtrlCreateInput("1", 88, 85, 37, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Updown1 = GUICtrlCreateUpdown($Input1)
GUICtrlSetLimit(-1, 100, 1)
$CheckboxAdd = GUICtrlCreateCheckbox("Nach jedem              . Fahrzeug einen Soundwagen einfügen", 10, 87, 480, 17, BitOR($GUI_SS_DEFAULT_CHECKBOX, $WS_CLIPSIBLINGS))
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$List1 = GUICtrlCreateList("", 10, 110, 480, 130, BitOR($LBS_NOTIFY, $LBS_SORT, $LBS_NOINTEGRALHEIGHT, $LBS_MULTICOLUMN, $WS_BORDER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
GUICtrlSetTip(-1, "Einen Soundwagen auswählen und Rechtsklicken, um die Sounds anzuhören")
$List1context = GUICtrlCreateContextMenu($List1)
$MenuItemRoll = GUICtrlCreateMenuItem("Rollsound abspielen", $List1context)
$MenuItemBrems = GUICtrlCreateMenuItem("Bremssound abspielen", $List1context)
$MenuItemKurve = GUICtrlCreateMenuItem("Kurvensound abspielen", $List1context)
$MenuItemAnfahr = GUICtrlCreateMenuItem("Anfahrsound abspielen", $List1context)
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
Load()
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
		Case $InputZVLoad
			Load()
		Case $CheckboxAdd
			ToggleCheckbox()
		Case $ButtonZVSave
			BrowseZVSave()
		Case $ButtonSave
			Save()
	EndSwitch
WEnd

Func Key($i)
	Return StringFormat("%04i", $i)
EndFunc   ;==>Key

Func BoolToState($bool)
	Return $bool ? $GUI_ENABLE : $GUI_DISABLE
EndFunc   ;==>BoolToState

Func ReadSoundList()
	Local $IniFile = @ScriptDir & "\Soundwagen.ini"
	Local $IniSection = "Soundwagen"
	Local $Anzahl = IniRead($IniFile, $IniSection, "Anzahl", 0)
	ReDim $ArrayNamen[$Anzahl]
	ReDim $ArrayPfade[$Anzahl]
	For $i = 1 To $Anzahl
		$ArrayNamen[$i - 1] = IniRead($IniFile, $IniSection, "Name" & $i, "Fehler")
		$ArrayPfade[$i - 1] = IniRead($IniFile, $IniSection, "Pfad" & $i, "Fehler")
	Next
	GUICtrlSetData($List1, _ArrayToString($ArrayNamen))
EndFunc   ;==>ReadSoundList

Func IsSoundwagen($Modellpfad)
	Return _ArraySearch($ArrayPfade, $Modellpfad) > -1
EndFunc   ;==>IsSoundwagen

Func PlaySound($Type)
	Local $Selected = GUICtrlRead($List1)
	Local $Index = _ArraySearch($ArrayNamen, $Selected)
	If $Index = -1 Then
		MsgBox(48, "Soundwagen einfügen", "Bitte wähle einen Soundwagen aus.")
		Return
	EndIf
	Local $TxtFile = $ResBase & "\Rollmaterial\" & StringReplace($ArrayPfade[$Index], ".gsb", ".txt")
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
	If @error Then Return
	GUICtrlSetData($InputZVLoad, $File)
	GUICtrlSetData($InputZVSave, $File)
	Load()
EndFunc   ;==>BrowseZVLoad

Func Load()
	Local $RSSLoad = GUICtrlRead($InputZVLoad)
	Local $Text = ""
	Local $SoundwagenCount = 0
	Local $Success = False
	If $RSSLoad = "" Then
		$Text = "Bitte einen Zugverband auswählen."
	ElseIf Not FileExists($RSSLoad) Then
		$Text = "Die angegebene Datei exisitiert nicht."
	Else
		Local $TrainLength = 0
		While IniRead($RSSLoad, "MODELS", Key($TrainLength + 1), "") <> ""
			$TrainLength += 1
		WEnd
		If $TrainLength = 0 Then
			$Text = "Die Datei konnte nicht gelesen werden."
		Else
			ReDim $ZugverbandData[$TrainLength + 1]
			For $i = 0 To $TrainLength
				Local $Entry[3]
				$Entry[$MODEL] = IniRead($RSSLoad, "MODELS", Key($i), "")
				$Entry[$MODEL] = StringRegExpReplace($Entry[$MODEL], "^\\", "") ; Remove leading slash that was wrongly inserted by a previous version
				$Entry[$NAME] = IniRead($RSSLoad, "NAMES", Key($i), "")
				$Entry[$DIRECTION] = IniRead($RSSLoad, "DIRECTIONS", Key($i), "")
				$ZugverbandData[$i] = $Entry
				If IsSoundwagen($Entry[$MODEL]) Then $SoundwagenCount += 1
			Next
			Local $ZugverbandName = ($ZugverbandData[0])[$NAME]
			Local $Anhang
			Switch $SoundwagenCount
				Case 0
					$Anhang = " und enthält noch keine Soundwagen."
				Case 1
					$Anhang = ", davon ist einer ein Soundwagen."
				Case Else
					$Anhang = ", davon sind " & $SoundwagenCount & " Soundwagen."
			EndSwitch
			$Text = StringFormat('"%s" besteht aus %i Fahrzeugen', $ZugverbandName, $TrainLength) & $Anhang
			$Success = True
		EndIf
	EndIf
	GUICtrlSetState($CheckboxRemove, BoolToState($SoundwagenCount > 0))
	GUICtrlSetState($ButtonSave, BoolToState($Success))
	GUICtrlSetData($LabelMessage, $Text)
	GUICtrlSetColor($LabelMessage, $Success ? $CLR_DEFAULT : $COLOR_RED)
EndFunc   ;==>Load

Func ToggleCheckbox()
	Local $State = BoolToState(GUICtrlRead($CheckboxAdd) = $GUI_CHECKED)
	GUICtrlSetState($Input1, $State)
	GUICtrlSetState($List1, $State)
EndFunc   ;==>ToggleCheckbox

Func BrowseZVSave()
	Local $File = FileSaveDialog("Zugverband speichern", GUICtrlRead($InputZVSave), "Zugverbände (*.rss)")
	If @error Then Return
	GUICtrlSetData($InputZVSave, $File)
EndFunc   ;==>BrowseZVSave

Func Save()
	Local $RSSSave = GUICtrlRead($InputZVSave)
	Local $ShouldRemove = GUICtrlRead($CheckboxRemove) = $GUI_CHECKED
	Local $ShouldAdd = GUICtrlRead($CheckboxAdd) = $GUI_CHECKED
	Local $JederXteWagen = GUICtrlRead($Input1)
	Local $Selected = GUICtrlRead($List1)
	Local $Index = _ArraySearch($ArrayNamen, $Selected)
	Local $ModelPath = $Index > -1 ? $ArrayPfade[$Index] : ""
	Local $ModelIni = $ResBase & "\Rollmaterial\" & StringReplace($ModelPath, ".gsb", ".ini")
	Local $ModelName = IniRead($ModelIni, "FileInfo", "Name_GER", "Soundwagen")
	Local $EntfernteSoundwagen = 0
	Local $EingefuegteSoundwagen = 0

	Local $Fehlermeldung = ""
	If $RSSSave = "" Then $Fehlermeldung &= "Bitte auswählen, unter welchem (Datei-)Namen der neue Zugverband gespeichert werden soll." & @CRLF
	If Not $ShouldRemove And Not $ShouldAdd Then $Fehlermeldung &= "Bitte auswählen, ob Soundwagen entfernt oder hinzugefügt werden sollen." & @CRLF
	If $ShouldAdd And $Selected = "" Then $Fehlermeldung &= "Bitte einen Soundwagen auswählen." & @CRLF

	If $Fehlermeldung <> "" Then
		MsgBox(16, "Soundwagen einfügen", $Fehlermeldung)
		Return
	EndIf

	If FileExists($RSSSave) Then
		If MsgBox(36, "Soundwagen einfügen", "Soll der Zugverband überschrieben werden?") = 6 Then
			FileDelete($RSSSave)
		Else
			Return
		EndIf
	EndIf

	; Kopie anlegen
	Local $LocalZugverbandData = $ZugverbandData

	; Vorhandene Soundwagen entfernen
	If $ShouldRemove Then
		Local $PositionsToDelete[1]
		For $i = 0 To UBound($LocalZugverbandData) - 1
			If IsSoundwagen(($LocalZugverbandData[$i])[$MODEL]) Then
				_ArrayAdd($PositionsToDelete, $i)
				$EntfernteSoundwagen += 1
			EndIf
		Next
		$PositionsToDelete[0] = $EntfernteSoundwagen
		_ArrayDelete($LocalZugverbandData, $PositionsToDelete)
	EndIf

	; Neue Soundwagen hinzufügen
	If $ShouldAdd Then
		Local $Entry[3] = [$ModelPath, $ModelName, 0]
		Local $PositionsToAdd[1]
		For $i = 1 + $JederXteWagen To UBound($LocalZugverbandData) - 1 Step $JederXteWagen
			_ArrayAdd($PositionsToAdd, $i)
			$EingefuegteSoundwagen += 1
		Next
		$PositionsToAdd[0] = $EingefuegteSoundwagen
		_ArrayInsert($LocalZugverbandData, $PositionsToAdd, $Entry, Default, Default, Default, $ARRAYFILL_FORCE_SINGLEITEM)
	EndIf

	;Speichern des Zugverbands
	For $i = 0 To UBound($LocalZugverbandData) - 1
		Local $Entry = $LocalZugverbandData[$i]
		IniWrite($RSSSave, "MODELS", Key($i), '"' & $Entry[$MODEL] & '"')
		IniWrite($RSSSave, "NAMES", Key($i), '"' & $Entry[$NAME] & '"')
		IniWrite($RSSSave, "DIRECTIONS", Key($i), $Entry[$DIRECTION])
	Next
	IniDelete($RSSSave, "MODELS", Key(0)) ; Es gibt kein allgemeingültiges Modell (Position 0)
	MsgBox(64, "Soundwagen einfügen", "Es wurden " & $EntfernteSoundwagen & " Soundwagen entfernt und " & $EingefuegteSoundwagen & " Soundwagen eingefügt.")

EndFunc   ;==>Save
