#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>

HotKeySet("{Esc}","Quit")
HotKeySet("{Tab}", "Debug")

WinActivate("Dofus")
WinMove("Dofus", "", 0, 0, 800, 600)
Opt ("SendKeyDelay", 50)

$should_check = True
$pret_button_color = "FF6600"
$chk_sell = 3141953244
$chk_bank = 2820408540

; Ensure settings are good
;Call("ensureSettings")
; Everything's good launch searchBattle
Call("searchBattle")

Func goToStart()
	MouseClick("left", 249, 582)
	Sleep(100)
	Send(".start{Enter}")

	While True
		; Check astrub loaded
		If Hex(PixelGetColor(525, 72), 6) = "8D1A15" Then
			Sleep(500)
			MouseClick("left", 165, 320)
			; Click buy
			Sleep(200)
			MouseClick("left", 175, 330)
			; Click on items only
			Sleep(1000)
			MouseClick("left", 700, 210)
			; Click on first item
			sell()
			ExitLoop
		ElseIf Hex(PixelGetColor(525, 72), 6) = "92271B" Then
			Sleep(500)
			MouseClick("left", 165, 320)
			; Click buy
			Sleep(200)
			MouseClick("left", 175, 330)
			; Click on items only
			Sleep(1000)
			MouseClick("left", 700, 210)
			; Click on first item
			sell()
			ExitLoop
		EndIf
	WEnd
EndFunc

Func goToMap()
	; Close pane
	MouseClick("left", 743, 191)
	; Go zaap
	MouseClick("left", 402, 245)
	; Use button
	MouseClick("left", 431, 272)
	Sleep(2000)
	; Scroll
	MouseWheel($MOUSE_WHEEL_DOWN, 3)
	MouseClick("left", 326, 346)
	Sleep(1000)
	MouseClick("left", 344, 300)
	Sleep(3000)
	MouseClick("left", 65, 221)
	Sleep(10000)
	MouseClick("left", 65, 353)
	Sleep(10000)
	MouseClick("left", 65, 380)
	Sleep(10000)
	MouseClick("left", 65, 274)
	Sleep(10000)
	MouseClick("left", 65, 194)
	Sleep(10000)
	MouseClick("left", 529, 64)
	Sleep(10000)
	MouseClick("left", 530, 64)
	Sleep(5000)

	Call("searchBattle")
EndFunc

Func sell()
	If Hex(PixelGetColor(416, 286), 6) = "FF6100" Then
		MouseClick("left", 416, 286)
		Sleep(200)
	Endif

	MouseClick("left", 571, 397, 1, 5)
	MouseClick("left", 502, 392, 1, 5)
	; let ui display button to get the color
	Sleep(200)
	$px = PixelGetColor(400, 383)

	If (Hex($px, 6) = "FF6100") Then
		MouseClick("left", 390, 378, 1, 5)
		MouseClick("left", 488, 378, 1, 5)
	EndIf

	If PixelChecksum(583, 410, 611, 423) = $chk_sell Then
		MouseClick("left", 743, 192, 1, 5)
		Call("putInBank")
		Call("goToMap")
	Else
		sell()
	EndIf
EndFunc

Func putInBank()
	MouseClick("left", 131, 581)
	Sleep(100)
    Send(".banque{Enter}")
	Sleep(2000)
	MouseClick("left", 711, 169)

	While Not (PixelChecksum(579, 210, 602, 235) = $chk_bank)
		Sleep(200)
		Send("{CTRLDOWN}")
		MouseClick("left", 588, 222, 2)
		Send("{CTRLUP}")
	WEnd

	MouseClick("left", 739, 142)
EndFunc

Func searchBattle()
	While True
		If $should_check = True Then
			Local $pos_white = PixelSearch(0, 0, 800, 600, 0xF48702, 3)
			If Not @error Then
				MouseClick("left", $pos_white[0], $pos_white[1], 1, 0)
				Call("detectBattle")
			EndIf

			Local $pos_whitea = PixelSearch(0, 0, 800, 600, 0xF3E3BF, 3)
			If Not @error Then
				MouseClick("left", $pos_whitea[0], $pos_whitea[1], 1, 0)
				Call("detectBattle")
			EndIf

			Local $pos_whiteb = PixelSearch(0, 0, 800, 600, 0xC3AB13, 3)
			If Not @error Then
				MouseClick("left", $pos_whiteb[0], $pos_whiteb[1], 1, 0)
				Call("detectBattle")
			EndIf

			Local $pos_whitec = PixelSearch(0, 0, 800, 600, 0x9F7F0D, 3)
			If Not @error Then
				MouseClick("left", $pos_whitec[0], $pos_whitec[1], 1, 0)
				Call("detectBattle")
			EndIf
		Endif
	WEnd
EndFunc

Func checkFull()
	MouseClick("left", 570, 489)
	Sleep(1500)

	If Hex(PixelGetColor(525, 273), 6) = "FF6600" Then
		MouseClick("left", 570, 489)
		Call("goToStart")
	Else
		MouseClick("left", 570, 489)
		Call("searchBattle")
	EndIf
EndFunc

Func checkForLevelUp()
	If Hex(PixelGetColor(382, 309), 6) = "FF6100" Then
		MouseClick("left", 382, 309)
		Sleep(2000)
	EndIf
EndFunc

Func detectBattle()
	$init = TimerInit()

	While True
 		If TimerDiff($init) > 6000 Then
		 	If $should_check = True Then
				Call("searchBattle")
				ExitLoop
			EndIf
		EndIf

		; Ready button is available
		If Hex(PixelGetColor(691, 445), 6) = $pret_button_color Then
			Call("battle")
			ExitLoop
		EndIf

		If Hex(PixelGetColor(691, 445), 6) = "000000" Then
			Call("didChangedMap")
			ExitLoop
		EndIf
	WEnd

	; Recursive detection
	detectBattle()
EndFunc

Func didChangedMap()
	$should_check = False
	Sleep(3000)
	If Hex(PixelGetColor(640, 149), 6) = "E12D2E" Or Hex(PixelGetColor(638, 150), 6) = "DC2C25" Then
		$should_check = True
		Call("searchBattle")
	EndIf

	; Sortie bas
	If Hex(PixelGetColor(330, 281), 6) = "E6302D" Or Hex(PixelGetColor(456, 330), 6) = "C22F22" Then
		MouseClick("left", 530, 52)
	EndIf

	; Sortie haut
	If Hex(PixelGetColor(330, 237), 6) = "CF302A" Or Hex(PixelGetColor(148, 320), 6) = "E52D29" Then
		MouseClick("left", 375, 458)
	EndIf
EndFunc

Func checkForEC()
    Sleep(100)
    While True
        ; Relaunch attack until not EC
        If Hex(PixelGetColor(563, 527), 6) = "518D9D" Then
            Send("&")
            ; Click la première case
    		MouseMove(529, 408)
			Sleep(500)
			MouseClick("left")
            ; On recheck au cas ou pour un EC
			Sleep(1900)
            Call("checkForEC")
        Else
            ExitLoop
        Endif
    WEnd
EndFunc

Func battle()
	; Click sur la case du combat
	MouseClick("left", 322, 359, 1, 5)
	Sleep(10)
	MouseClick("left")
	Sleep(10)
	MouseClick("left")
	Sleep(10)
	MouseClick("left")
	Sleep(10)
	MouseClick("left")
	; On attend que le groupe join
	Sleep(4000)
	; Click sur pret
	MouseClick("left", 691, 445)
    ; Attente que le combat charge
	Sleep(4500)
    ; Utilise le premier sort de la taskbar
	Send("&")
    ; Click la première case
    MouseMove(529, 408)
	Sleep(500)
	MouseClick("left")
    ; Check for EC
    Call("checkForEC")

	; Combat terminé
	While True
		; Check si combat terminé
		If Hex(PixelGetColor(337, 216), 6) = "D5CFAA" Then
			; Attente de l'UI
			Sleep(2000)
			; Check level up every time combat ends
			Call("checkForLevelUp")
			; Recup la position du bouton
			Local $button_px = PixelSearch(565, 326, 689, 564, 0xFF6100, 1)
			If Not @error Then
				; Close le recap
				MouseClick("left", $button_px[0]+20, $button_px[1]+15)
				; Recherche un combat
				Call("checkFull")
				Call("searchBattle")
			EndIf
			ExitLoop
		EndIf
	WEnd
EndFunc

Func ensureSettings()
    ; Set .joindelay 1.25
    MouseClick("left", 131, 581)
	Sleep(200)
    Send(".joindelay 2.5{Enter}")
    MouseClick("left", 401, 286)
EndFunc

Func Quit()
	Exit
EndFunc

Func Debug()
	Local $aPos = MouseGetPos()
	Local $isdark = Hex(PixelGetColor($aPos[0], $aPos[1]), 6)
	MsgBox($MB_SYSTEMMODAL, "Mouse x, y:", $aPos[0] & ", " & $aPos[1] & ", " & $isdark)
EndFunc