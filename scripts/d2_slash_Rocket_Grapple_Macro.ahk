Setbatchlines, -1
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
global sens := 6 ; Your in game sensitivity
global showPopup := true
global Y := Round(38 * (6/sens))
MsgBox, Activated, press / to rocket grapple. Press F3 to deactivate.
loop {
	if GetKeyState("/") { ; Activate the rocket grapple with "/"
		KeyWait, /
		SendInput {LButton}
		DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", Y)
		SendInput {H} ; Your grenade bind
		}
	if GetKeyState("F3") { ; Exit the script with F3 when you're done grappling
		KeyWait, F3
		break
		}
     }