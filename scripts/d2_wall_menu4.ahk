#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%

F5::
global sens := 6
global speed := 2
global confirm := "on"

global virtualX := 0
global virtualY := 0
global i := 0
global j := 0

if !FileExist("wall_settings.ini") {
	MsgBox, No wall_settings.ini found, please input your settings now.

	InputBox, sens, Sensitivity, Input your ingame sensitivity (default: 6):,, 230, 150
	InputBox, speed, Speed, Choose macro speed (default: 3`,` 1-4):,, 230, 150
    InputBox, confirm, Confirm before input, Review wish before stepping on? (default: on):,, 230, 150

	IniWrite, %sens%, wall_settings.ini, Variables, Sensitivity
	IniWrite, %speed%, wall_settings.ini, Variables, Speed
    IniWrite, %confirm%, wall_settings.ini, Variables, Confirm
} else {
	IniRead, sens, wall_settings.ini, Variables, Sensitivity
	IniRead, speed, wall_settings.ini, Variables, Speed
    IniRead, confirm, wall_settings.ini, Variables, Confirm
}

switch speed {
	case 1:
		global cycle_time := 110
	case 2:
		global cycle_time := 100
	case 3:
		global cycle_time := 90
	case 4:
		global cycle_time := 80
}

global WishNumber
InputBox, WishNumber, Wall of Wishes menu by @theaegisrelic,
(
1. Ethereal Key (once per account) [124]
2. Glittering Key chest spawn [68]
3. Numbers of Power emblem [66]
4. Shuro Chi encounter [214]
5. Morgeth encounter [165]
6. Vault encounter [141]
7. Riven encounter [152]
8. Hope for the Future song [150]
9. Failsafe dialogue [24]
10. Drifter dialogue [64]
11. Party effect on precision kills [147]
12. Random effect around players' heads [108]
13. Petra's Run [166]
14. Corrupted Eggs spawn [102]
15. Change sensitivity (default: 6, current: %sens%)
16. Change speed (default: 3, current: %speed%)
17. Confirm before stepping on (current: %confirm%)
)
,, 315, 400
if ErrorLevel {
	Return
}

Sleep, 150

switch WishNumber
{
	case 1, "key":
	wish := [3, 4, 5, 9, 10, 18, 11, 12, 16, 1
			, 3, 4, 5, 9, 10, 18, 12, 16, 17, 2
			, 3, 4, 5, 9, 10, 18, 11, 16, 17, 6
			, 3, 4, 5, 9, 10, 18, 11, 12, 17, 7
			, 3, 4, 5, 9, 10, 18, 14, 15, 19, 20
			, 3, 4, 5, 9, 10, 18, 14, 15, 19, 20
			, 3, 4, 5, 9, 10, 18, 14, 15, 19, 20
			, 3, 4, 5, 9, 10, 18, 14, 15, 19, 20
			, 3, 4, 5, 9, 10, 18, 11, 12, 16, 17
			, 3, 4, 5, 9, 10, 18, 11, 12, 16, 17
			, 3, 4, 5, 9, 10, 11, 0, 0, 0, 0
			, 3, 4, 5, 9, 10, 12, 0, 0, 0, 0
			, 3, 4, 5, 9, 10, 16, 0, 0, 0, 0
			, 3, 4, 5, 9, 10, 17]
	shoot(wish)
	
	case 2, "chest":
	wish := [3, 8, 13, 18, 20, 1, 6, 5, 10, 15
			, 3, 8, 13, 18, 20, 1, 6, 5, 10, 15
			, 3, 8, 13, 18, 20, 1, 6, 5, 10, 15
			, 3, 8, 13, 18, 20, 1, 6, 11, 16, 0
			, 3, 8, 13, 18, 20, 0, 0, 0, 11, 16
			, 3, 8, 13, 18, 0, 0, 0, 0, 0, 0
			, 3, 8, 13, 18, 0, 0, 0, 0, 0, 0
			, 3, 8, 13, 18, 0, 0, 0, 0, 0, 0
			, 3, 8, 13, 18, 0, 0, 0, 0, 0, 0
			, 3, 8, 13, 18, 0, 0, 0, 0, 0, 0
			, 3, 8]
	shoot(wish)
	
	case 3, "emblem":
	wish := [17, 19, 11, 13, 15, 7, 9, 1, 3, 5
			, 17, 19, 11, 13, 15, 0, 0, 0, 0, 0
			, 17, 19, 11, 13, 15, 0, 0, 0, 0, 0
			, 17, 19, 11, 13, 15, 0, 0, 0, 0, 0
			, 17, 19, 11, 13, 15, 0, 0, 0, 0, 0
			, 17, 19, 11, 13, 15, 0, 0, 0, 0, 0
			, 17, 19, 11, 13, 15, 0, 0, 0, 0, 0
			, 17, 19, 11, 13, 15, 0, 0, 0, 0, 0
			, 17, 19, 11, 13, 15, 0, 0, 0, 0, 0
			, 17, 19, 7, 9, 0, 0, 0, 0, 0, 0
			, 17, 19, 7, 9, 0, 0, 0, 0, 0, 0
			, 17, 19, 7, 9, 0, 0, 0, 0, 0, 0
			, 17, 19, 7, 9]
	shoot(wish)
	
	case 4, "shuro":
	wish := [2, 3, 4, 1, 7, 14, 20, 5, 9, 12
			, 2, 3, 4, 1, 7, 14, 20, 5, 9, 12
			, 2, 3, 4, 1, 7, 14, 20, 16, 9, 12
			, 2, 3, 4, 1, 7, 14, 20, 16, 9, 12
			, 2, 3, 4, 1, 7, 14, 20, 5, 16, 12
			, 2, 3, 4, 1, 7, 14, 20, 5, 16, 12
			, 2, 3, 4, 1, 7, 14, 20, 5, 9, 16
			, 2, 3, 4, 1, 7, 14, 20, 5, 9, 16
			, 2, 3, 4, 1, 7, 14, 20, 5, 9, 8
			, 2, 3, 4, 1, 7, 14, 20, 5, 9, 8
			, 2, 3, 4, 1, 7, 14, 20, 5, 9, 8
			, 2, 3, 4, 12, 16, 6, 10, 11, 15, 8
			, 2, 3, 4, 12, 16, 6, 10, 11, 15, 8
			, 2, 3, 4, 12, 16, 6, 10, 11, 15, 8
			, 2, 3, 1, 7, 14, 20, 5, 17, 18, 19
			, 2, 3, 1, 7, 14, 20, 5, 17, 18, 19
			, 9, 12, 16, 6, 10, 11, 15, 17, 18, 19
			, 9, 12, 16, 6, 10, 11, 15, 17, 18, 19]
	shoot(wish)

	Send, R
	PreciseSleep(2100)

	wish := [4, 1, 7, 14, 20, 5, 9, 12, 16, 8
			, 4, 1, 7, 14, 20, 5, 9, 12, 16, 8
			, 6, 10, 11, 15, 17, 18, 19, 0, 0, 0
			, 6, 10, 11, 15, 17, 18, 19]
	shoot(wish)
	
	case 5, "morgeth":
	wish := [8, 3, 13, 18, 2, 4, 17, 19, 7, 9
			, 8, 3, 13, 18, 2, 4, 17, 19, 7, 9
			, 8, 3, 13, 18, 2, 4, 17, 19, 7, 9
			, 8, 3, 13, 18, 2, 4, 17, 19, 7, 9
			, 8, 3, 13, 18, 2, 4, 17, 19, 12, 14
			, 8, 3, 13, 18, 2, 4, 17, 19, 12, 14
			, 8, 3, 13, 18, 2, 4, 17, 19, 12, 14
			, 8, 3, 13, 18, 2, 4, 17, 19, 12, 14
			, 8, 3, 13, 18, 2, 4, 7, 9, 12, 14
			, 8, 3, 13, 18, 2, 4, 7, 9, 12, 14
			, 8, 3, 13, 18, 2, 4, 7, 9, 12, 14
			, 8, 3, 13, 18, 17, 19, 1, 5, 16, 20
			, 8, 3, 13, 18, 17, 19, 1, 5, 16, 20
			, 8, 3, 13, 18, 17, 19, 1, 5, 16, 20
			, 8, 2, 7, 9, 12, 14, 1, 5, 16, 20
			, 8, 3, 13, 18, 4, 17, 19, 7, 9, 12
			, 14, 1, 5, 16, 20]
	shoot(wish)
	
	case 6, "vault":
	wish := [3, 2, 4, 16, 17, 18, 19, 20, 1, 5
			, 3, 2, 4, 16, 17, 18, 19, 20, 1, 5
			, 3, 2, 4, 16, 17, 18, 19, 20, 1, 5
			, 3, 2, 4, 16, 17, 18, 19, 20, 1, 5
			, 3, 2, 4, 16, 17, 18, 19, 20, 1, 5
			, 3, 2, 4, 16, 17, 18, 19, 20, 7, 9
			, 3, 2, 4, 16, 17, 18, 19, 20, 7, 9
			, 3, 2, 4, 16, 17, 18, 19, 20, 7, 9
			, 3, 2, 4, 16, 17, 18, 19, 20, 7, 9
			, 3, 2, 4, 16, 17, 18, 19, 20, 7, 9
			, 3, 2, 4, 16, 17, 18, 1, 5, 7, 9
			, 3, 2, 4, 19, 20, 1, 5, 7, 9, 6
			, 3, 2, 4, 1, 5, 7, 9, 10, 11, 15
			, 3, 0, 0, 0, 0, 0, 1, 5, 7, 9
			, 3, 0, 0, 0, 0, 0, 1, 5, 7, 9
			, 3]
	shoot(wish)
	
	case 7, "riven":
	wish := [16, 1, 10, 15, 13, 3, 18, 6, 11, 9
			, 16, 1, 10, 15, 13, 3, 18, 6, 11, 14
			, 16, 1, 10, 15, 13, 3, 18, 6, 11, 5
			, 16, 1, 10, 15, 13, 3, 18, 20, 9, 14
			, 16, 1, 10, 15, 13, 3, 18, 6, 11, 5
			, 16, 1, 10, 15, 13, 3, 18, 20, 9, 14
			, 16, 1, 10, 15, 13, 3, 18, 6, 11, 2
			, 16, 1, 10, 15, 13, 3, 18, 17, 5, 20
			, 16, 1, 10, 15, 13, 9, 14, 6, 11, 3
			, 16, 1, 10, 15, 13, 18, 2, 17, 5, 20
			, 16, 1, 10, 15, 13, 9, 14, 6, 11, 3
			, 16, 1, 10, 15, 18, 13, 2, 17, 5, 20
			, 16, 1, 10, 15, 9, 14, 6, 11, 3, 18
			, 16, 1, 13, 10, 15, 2, 17, 5, 20, 9
			, 16, 1, 14, 6, 11, 3, 18, 13, 10, 15
			, 16, 1]
	shoot(wish)

	case 8, "song":
	wish := [13, 3, 8, 18, 2, 7, 12, 17, 4, 9
			, 13, 3, 8, 18, 2, 7, 12, 17, 4, 9
			, 13, 3, 8, 18, 2, 7, 12, 17, 4, 9
			, 13, 3, 8, 18, 2, 7, 12, 17, 4, 9
			, 13, 3, 8, 18, 2, 7, 12, 17, 14, 19
			, 13, 3, 8, 18, 2, 7, 12, 17, 14, 19
			, 13, 3, 8, 18, 2, 7, 12, 17, 14, 19
			, 13, 3, 8, 18, 2, 7, 12, 17, 14, 19
			, 13, 3, 8, 18, 2, 7, 4, 9, 14, 19
			, 13, 3, 8, 18, 2, 7, 4, 9, 14, 19
			, 13, 3, 12, 17, 2, 7, 4, 9, 14, 19
			, 13, 3, 12, 17, 2, 7, 4, 9, 14, 19
			, 13, 3, 8, 18, 12, 17, 4, 9, 14, 19
			, 13, 3, 8, 18, 12, 17, 4, 9, 14, 19
			, 13, 0, 8, 18, 0, 0, 4, 9, 14, 19
			, 13, 0, 8, 18]
	shoot(wish)
	
	case 9, "failsafe":
	wish := [14, 7, 8, 9, 12, 13, 0, 0, 0, 0
			, 14, 7, 8, 9, 12, 13, 0, 0, 0, 0
			, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 14]
	shoot(wish)
	
	case 10, "drifter":
	wish := [7, 8, 13, 14, 10, 15, 19, 20, 1, 2
			, 7, 8, 13, 14, 10, 15, 19, 20, 1, 2
			, 7, 8, 13, 14, 10, 15, 19, 5, 6, 11
			, 7, 8, 13, 14, 10, 15, 19, 5, 6, 11
			, 7, 8, 13, 14, 20, 0, 0, 0, 0, 0
			, 7, 8, 13, 14, 20, 0, 0, 0, 0, 0
			, 7, 8, 13, 14, 0, 0, 0, 0, 0, 0
			, 7, 8, 0, 0, 0, 0, 0, 0, 0, 0
			, 7, 8, 0, 0, 0, 0, 0, 0, 0, 0
			, 7, 8, 0, 0, 0, 0, 0, 0, 0, 0
			, 7, 8, 0, 0, 0, 0, 0, 0, 0, 0
			, 7, 8]
	shoot(wish)
	
	case 11, "party":
	wish := [4, 5, 10, 11, 16, 17, 15, 19, 20, 9
			, 4, 5, 10, 1, 2, 6, 11, 16, 17, 15
			, 4, 5, 10, 1, 2, 6, 11, 16, 17, 15
			, 4, 5, 10, 1, 2, 6, 11, 16, 17, 15
			, 4, 5, 10, 1, 2, 6, 11, 16, 17, 15
			, 4, 5, 10, 1, 2, 6, 11, 16, 17, 15
			, 4, 5, 10, 1, 2, 6, 11, 16, 17, 9
			, 4, 5, 10, 1, 2, 6, 11, 16, 17, 9
			, 4, 5, 10, 1, 2, 6, 11, 16, 17, 9
			, 4, 5, 10, 1, 2, 6, 19, 20, 0, 9
			, 4, 5, 10, 1, 2, 6, 19, 20, 13, 0
			, 4, 5, 10, 1, 2, 6, 19, 20, 13, 0
			, 4, 5, 10, 1, 2, 6, 19, 0, 0, 0
			, 4, 5, 10, 1, 2, 6, 19, 0, 0, 0
			, 4, 5, 10, 1, 2, 6, 20, 8, 0, 0
			, 4, 5, 10, 1, 2, 6, 20, 8]
	shoot(wish)
	
	case 12, "head", "halo":
	wish := [14, 15, 20, 13, 5, 8, 9, 10, 1, 6
			, 14, 15, 20, 13, 5, 8, 9, 10, 11, 7
			, 14, 15, 20, 13, 5, 8, 9, 10, 12, 16
			, 14, 15, 20, 13, 5, 8, 9, 10, 12, 16
			, 14, 15, 20, 13, 5, 8, 9, 10, 11, 12
			, 14, 15, 20, 13, 5, 8, 9, 10, 11, 12
			, 14, 15, 20, 13, 5, 8, 9, 10, 11, 16
			, 14, 15, 20, 13, 5, 8, 9, 10, 0, 16
			, 14, 15, 20, 13, 5, 8, 9, 10, 0, 0
			, 14, 15, 20, 13, 0, 0, 0, 0, 0, 0
			, 14, 15, 20, 13, 0, 0, 0, 0, 0, 0
			, 14, 15, 20, 13, 0, 0, 0, 0, 0, 0
			, 14, 15, 20, 0, 0, 0, 0, 0, 0, 0
			, 14, 15, 20, 0, 0, 0, 0, 0, 0, 0
			, 14, 15, 20]
	shoot(wish)
	
	case 13, "petra":
	wish := [4, 9, 12, 17, 3, 1, 6, 15, 20, 5
			, 4, 9, 12, 17, 3, 1, 6, 15, 20, 5
			, 4, 9, 12, 17, 3, 1, 6, 15, 20, 10
			, 4, 9, 12, 17, 3, 1, 6, 15, 20, 10
			, 4, 9, 12, 17, 3, 1, 6, 15, 20, 11
			, 4, 9, 12, 17, 3, 1, 6, 15, 20, 11
			, 4, 9, 12, 17, 3, 1, 6, 15, 20, 16
			, 4, 9, 12, 17, 3, 1, 6, 15, 20, 16
			, 4, 9, 12, 17, 3, 5, 10, 11, 2, 16
			, 4, 9, 12, 17, 3, 5, 10, 11, 2, 16
			, 4, 9, 12, 17, 1, 6, 15, 20, 7, 14
			, 4, 9, 12, 17, 1, 6, 15, 20, 7, 14
			, 4, 9, 12, 17, 3, 5, 10, 11, 16, 19
			, 4, 9, 12, 17, 3, 5, 10, 11, 16, 19
			, 1, 6, 15, 20, 3, 5, 10, 11, 16, 0
			, 1, 6, 15, 20, 3, 5, 10, 11, 16, 0
			, 4, 9, 12, 17, 1, 6, 15, 20]
	shoot(wish)
	
	case 14, "eggs":
	wish := [8, 3, 17, 20, 2, 4, 14, 13, 1, 11
			, 8, 3, 17, 20, 2, 4, 14, 13, 5, 16
			, 8, 3, 17, 20, 2, 4, 14, 13, 5, 16
			, 8, 3, 17, 20, 2, 4, 14, 13, 5, 16
			, 8, 3, 17, 20, 2, 4, 14, 13, 5, 16
			, 8, 3, 17, 20, 2, 4, 14, 13, 5, 16
			, 8, 3, 17, 20, 2, 4, 14, 1, 0, 0
			, 8, 3, 17, 20, 2, 4, 14, 1, 0, 0
			, 8, 3, 17, 20, 2, 4, 0, 1, 0, 0
			, 8, 3, 17, 20, 2, 0, 0, 1, 0, 0
			, 8, 3, 17, 20, 0, 0, 0, 0, 0, 0
			, 8, 3, 17, 0, 0, 0, 0, 0, 0, 0
			, 8, 3, 0, 0, 0, 0, 0, 0, 0, 0
			, 8, 3, 0, 0, 0, 0, 0, 0, 0, 0
			, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0
			, 8]
	shoot(wish)
	
	case 15, "sens":
		InputBox, sens, Sensitivity, Input your ingame sensitivity (default: 6):,, 230, 150
		IniWrite, %sens%, wall_settings.ini, Variables, Sensitivity
		Reload
		Return

	case 16, "speed":
		InputBox, speed, Speed, Choose macro speed (default: 3`,` 1-4):,, 230, 150
		IniWrite, %speed%, wall_settings.ini, Variables, Speed
		Reload
		Return
    
    case 17, "confirm":
		InputBox, confirm, Confirm before input, Review wish before stepping on? (default: on):,, 230, 150
		if (confirm != "off") {
			IniWrite, "on", wall_settings.ini, Variables, Confirm
		} else {
			IniWrite, %confirm%, wall_settings.ini, Variables, Confirm
		}
		Reload
		Return
	
	default:
		MsgBox, Invalid menu option
		Reload
		Return
}

Send, r
MoveMouse(515, 310+i, false)
if (confirm == "off") {
	Send, {w down}
	Sleep, 400
	Send, {w up}
	Sleep, 600
	Send, {s down}
	Sleep, 450
	Send, {s up}
}
Reload

shoot(Array) {
    Loop, % Array.Length() {
		recoil := true
        switch Array[A_Index] {
			case 0:
				MoveMouse(515, 310+i, false)
				recoil := false
				
			case 1: MoveMouse(0, 0+i)
			case 2: MoveMouse(250, 0+i)
			case 3: MoveMouse(515, 0+i)
			case 4: MoveMouse(770, 0+i)
			case 5: MoveMouse(1005, 20+i)
	
			case 6: MoveMouse(0, 220+i)
			case 7: MoveMouse(250, 220+i)
			case 8: MoveMouse(515, 250+i)
			case 9: MoveMouse(770, 250+i)
			case 10: MoveMouse(1005, 250+i)
	
			case 11: MoveMouse(0, 480+i)
			case 12: MoveMouse(250, 480+i)
			case 13: MoveMouse(515, 480+i)
			case 14: MoveMouse(770, 480+i)
			case 15: MoveMouse(1005, 480+i)
	
			case 16: MoveMouse(0, 720+i)
			case 17: MoveMouse(250, 720+i)
			case 18: MoveMouse(515, 720+i)
			case 19: MoveMouse(770, 720+i)
			case 20: MoveMouse(1005, 720+i)
		}
	
		if (recoil == true) {
			switch speed {
				case 1:
					i += 4
				case 2:
					i += 3
					if (mod(j, 7) == 0 || mod(j, 7) == 1 || mod(j, 7) == 2) {
						i += 1
					}
				case 3, 4:
					i += 2
					if (mod(j, 7) != 6) {
						i += 1
					}
			}
			j++			
		} else {
			if (mod(i, 2) == 0) {
				i -= 1
			}
		}
    }
}

MoveMouse(xTarget, yTarget, shoot := true) {
    xDist := xTarget - virtualX
    yDist := yTarget - virtualY
    
    DllCall("mouse_event", uint, 1, int, xDist / (sens / 6), int, yDist / (sens / 6))
    
    virtualX := xTarget
    virtualY := yTarget

    PreciseSleep(cycle_time)
    
	if (shoot == true) {
		Click
	}
    Return
}

PreciseSleep(s) {
    DllCall("QueryPerformanceFrequency", "Int64*", QPF)
    DllCall("QueryPerformanceCounter", "Int64*", QPCB)
    While (((QPCA - QPCB) / QPF * 1000) < s)
        DllCall("QueryPerformanceCounter", "Int64*", QPCA)
    return ((QPCA - QPCB) / QPF * 1000) 
}

F4::
Send, {LButton Up}
ExitApp

F5::
Send, {LButton Up}
Reload