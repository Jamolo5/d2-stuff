#noenv
#singleinstance force
#ifwinactive ahk_exe destiny2.exe
sendmode input


; all of this to right justify a single menu item, LOL!
; KILL ME!
SetMenuItemTypeRightJustify(HWND, HMENU, ItemPos) {
	Static cbSize := A_PtrSize = 8 ? 80 : 48
	Static MIIM_FTYPE := 0x00000100
	Static MFT_RIGHTJUSTIFY := 0x00004000
	VarSetCapacity(MII, cbSIze, 0)
	NumPut(cbSize, MII, 0, "UInt")
	NumPut(MIIM_FTYPE, MII, 4, "UInt")
	DllCall("User32.dll\GetMenuItemInfo", "Ptr", HMENU, "Int", ItemPos - 1, "Int", 1, "Ptr", &MII)
	NumPut(MIIM_FTYPE, MII, 4, "UInt")
	NumPut(NumGet(MII, 8, "UInt") | MFT_RIGHTJUSTIFY, MII, 8, "UInt")
	DllCall("User32.dll\SetMenuItemInfo", "Ptr", HMENU, "Int", ItemPos - 1, "Int", 1, "Ptr", &MII)
	Return DllCall("User32.dll\DrawMenuBar", "Ptr", HWND, "Int")
 }

; how useful is this actually? i have no idea.
; apparently, the delta of the ahk sleep is upto 31.2ms (the sleep can be wildly longer than it should be, i.e. a sleep 1 can be upto 31.2ms? but usually 15.6) 
; PreciseSleep should make it a maximum of ...1ms? who knows. seems to work. i'm not reading more of this shit: http://www.windowstimestamp.com/description 
PreciseSleep(s)
{
    DllCall("QueryPerformanceFrequency", "Int64*", QPF)
    DllCall("QueryPerformanceCounter", "Int64*", QPCB)
    While (((QPCA - QPCB) / QPF * 1000) < s)
        DllCall("QueryPerformanceCounter", "Int64*", QPCA)
    return ((QPCA - QPCB) / QPF * 1000) 
}
gosub, startup
return

; this is so shit, but it sets up binds for the script to defaults/what is read from destiny 2
; all settings are saved to movementsettings.ini
; if the file already exists, just read from it

; i chatgpt'd these comments lol, anything with capitals/punctuation
; This is the startup label, which will be executed when the script is launched.
startup:
	; Check if the "movementsettings.ini" file exists.
	if fileexist("movementsettings.ini") {
		; If the file exists, load settings from it using a subroutine.
		gosub, readfromini
	}
	else {
		; If the file doesn't exist, set default values for the settings.

		; Key bindings
		menu_bind = F9
		lament_mode = 0
		eager_mode = 1
		light_skate_bind = 4
		heavy_skate_bind = 5
		strand_skate_bind = 6
		snap_skate_bind = 7

		; Various modes and options
		shatter_mode = 0
		auto_jump_light_skate = 0
		auto_jump_heavy_skate = 0
		auto_jump_strand_skate = 0
		auto_jump_snap_skate = 0
		primary_swap = 1
		secondary_swap = 0
		secondary_swap = 1

		; Delays and timings
		delay_1 = 25
		delay_2 = 35
		delay_3 = 0
		auto_jump_delay = 400
		weapon_swap_delay = 750
		weapon_swapback_delay = 400

		bigballs = "LESS"

		; Read Destiny 2 binds from an XML file if it exists
		fileread, xmldata, c:\users\%a_username%\appdata\roaming\bungie\destinypc\prefs\cvars.xml
		if (!errorlevel) {
			doc := comobjcreate("msxml2.domdocument.6.0")
			doc.async := false
			doc.loadxml(xmldata)

			; List of Destiny 2 settings to retrieve
			destiny_settings := ["super", "light_attack", "heavy_attack", "block", "primary_weapon", "special_weapon", "heavy_weapon", "jump", "toggle_crouch", "air_move", "melee_charged"]
			destiny_binds := []

			; Loop through the Destiny 2 settings and extract their key bindings
			loop % destiny_settings.maxindex() {
				destiny_binds[a_index] := doc.selectsinglenode("//body/namespace/cvar[@name='" . destiny_settings[a_index] . "']").getattribute("value")
			}

			; Process the retrieved key bindings
			for index, value in destiny_binds {
				destiny_binds[index] := strreplace(strreplace(strreplace(value, "!unused", ""), " mouse button", ""), "keypad ", "")
				destiny_binds[index] := (destiny_binds[index] = "extra mouse button 2") ? "xbutton5" :(destiny_binds[index] = "extra mouse button 1") ? "xbutton4" : (destiny_binds[index] = "right") ? "rbutton" : (destiny_binds[index] = "left") ? "lbutton" : destiny_binds[index]
			}

			; Save the retrieved key bindings to the "movementsettings.ini" file
			loop % destiny_settings.maxindex() {
				iniwrite, % destiny_binds[a_index], movementsettings.ini, destiny_settings, % destiny_settings[a_index]
			}
			; Now read it so they don't get overwritten later
			for index, value in destiny_settings {
				iniread, %value%, movementsettings.ini, destiny_settings, % destiny_settings[index]
			}

			; Show a message box to notify the user about the found Destiny 2 key bindings.
			msgbox, found some binds from Destiny 2! Check them though, they might be wrong.
		} else {
			; If the Destiny 2 cvars file could not be read, prompt the user to manually input their Destiny key bindings.
			msgbox, could not read Destiny 2 cvars file. You will have to manually input all of your Destiny binds!`n`nSorry!
		}

		; Save the default settings to "movementsettings.ini" file.
		gosub, writetoini

		; Load settings from the "movementsettings.ini" file.
		gosub, readfromini

		; Open the settings GUI.
		gosub, movementgui
	}
return

; https://www.autohotkey.com/docs/v1/lib/IniWrite.htm
writetoini:
	iniwrite, %light_skate_bind%, movementsettings.ini, script_settings, light skate bind
	iniwrite, %heavy_skate_bind%, movementsettings.ini, script_settings, heavy skate bind
	iniwrite, %strand_skate_bind%, movementsettings.ini, script_settings, strand skate bind
	iniwrite, %snap_skate_bind%, movementsettings.ini, script_settings, snap skate skate bind
	iniwrite, %auto_jump_light_skate%, movementsettings.ini, script_settings, auto jump after light
	iniwrite, %auto_jump_heavy_skate%, movementsettings.ini, script_settings, auto jump after heavy
	iniwrite, %auto_jump_strand_skate%, movementsettings.ini, script_settings, auto jump after strand
	iniwrite, %auto_jump_snap_skate%, movementsettings.ini, script_settings, auto jump after snap
	iniwrite, %shatter_mode%, movementsettings.ini, script_settings, shatter mode
	iniwrite, %lament_mode%, movementsettings.ini, script_settings, lament mode
	iniwrite, %eager_mode%, movementsettings.ini, script_settings, eager mode
	iniwrite, %easy_mode%, movementsettings.ini, script_settings, easy mode
	iniwrite, %menu_bind%, movementsettings.ini, script_settings, menu bind
	iniwrite, %primary_swap%, movementsettings.ini, script_settings, primary swap
	iniwrite, %secondary_swap%, movementsettings.ini, script_settings, secondary swap
	iniwrite, %heavy_swap%, movementsettings.ini, script_settings, heavy swap
	iniwrite, %delay_1%, movementsettings.ini, script_settings, delay 1
	iniwrite, %delay_2%, movementsettings.ini, script_settings, delay 2
	iniwrite, %delay_3%, movementsettings.ini, script_settings, delay 3
	iniwrite, %auto_jump_delay%, movementsettings.ini, script_settings, auto jump delay
	iniwrite, %weapon_swap_delay%, movementsettings.ini, script_settings, weapon swap delay
	iniwrite, %weapon_swapback_delay%, movementsettings.ini, script_settings, weapon swap back delay
	iniwrite, %super%, movementsettings.ini, destiny_settings, super
	iniwrite, %melee_charged%, movementsettings.ini, destiny_settings, melee_charged
	iniwrite, %air_move%, movementsettings.ini, destiny_settings, air_move
	iniwrite, %heavy_attack%, movementsettings.ini, destiny_settings, heavy_attack
	iniwrite, %light_attack%, movementsettings.ini, destiny_settings, light_attack
	iniwrite, %toggle_crouch%, movementsettings.ini, destiny_settings, toggle_crouch
	iniwrite, %primary_weapon%, movementsettings.ini, destiny_settings, primary_weapon
	iniwrite, %special_weapon%, movementsettings.ini, destiny_settings, special_weapon
	iniwrite, %heavy_weapon%, movementsettings.ini, destiny_settings, heavy_weapon
	iniwrite, %jump%, movementsettings.ini, destiny_settings, jump
	iniwrite, %block%, movementsettings.ini, destiny_settings, block

	iniwrite, %lessoptions%, movementsettings.ini, destiny_settings, lessoptionss

	iniwrite, %bigballs%, movementsettings.ini, destiny_settings, bigballss


	gui, destroy
return

; https://www.autohotkey.com/docs/v1/lib/IniRead.htm
readfromini:
	iniread, light_skate_bind, movementsettings.ini, script_settings, light skate bind, %A_Space%
	iniread, heavy_skate_bind, movementsettings.ini, script_settings, heavy skate bind, %A_Space%
	iniread, strand_skate_bind, movementsettings.ini, script_settings, strand skate bind, %A_Space%
	iniread, snap_skate_bind, movementsettings.ini, script_settings, snap skate skate bind, %A_Space%
	iniread, auto_jump_light_skate, movementsettings.ini, script_settings, auto jump after light, %A_Space%
	iniread, auto_jump_heavy_skate, movementsettings.ini, script_settings, auto jump after heavy, %A_Space%
	iniread, auto_jump_strand_skate, movementsettings.ini, script_settings, auto jump after strand, %A_Space%
	iniread, auto_jump_snap_skate, movementsettings.ini, script_settings, auto jump after snap, %A_Space%
	iniread, shatter_mode, movementsettings.ini, script_settings, shatter mode, %A_Space%
	iniread, lament_mode, movementsettings.ini, script_settings, lament mode, %A_Space%
	iniread, eager_mode, movementsettings.ini, script_settings, eager mode, %A_Space%
	iniread, easy_mode, movementsettings.ini, script_settings, easy mode, %A_Space%
	iniread, menu_bind, movementsettings.ini, script_settings, menu bind, %A_Space%
	iniread, primary_swap, movementsettings.ini, script_settings, primary swap, %A_Space%
	iniread, secondary_swap, movementsettings.ini, script_settings, secondary swap, %A_Space%
	iniread, heavy_swap, movementsettings.ini, script_settings, heavy swap, %A_Space%
	iniread, delay_1, movementsettings.ini, script_settings, delay 1, %A_Space%
	iniread, delay_2, movementsettings.ini, script_settings, delay 2, %A_Space%
	iniread, delay_3, movementsettings.ini, script_settings, delay 3, %A_Space%
	iniread, auto_jump_delay, movementsettings.ini, script_settings, auto jump delay, %A_Space%
	iniread, weapon_swap_delay, movementsettings.ini, script_settings, weapon swap delay, %A_Space%
	iniread, weapon_swapback_delay, movementsettings.ini, script_settings, weapon swap back delay, %A_Space%
	iniread, super, movementsettings.ini, destiny_settings, super, %A_Space%
	iniread, melee_charged, movementsettings.ini, destiny_settings, melee_charged, %A_Space%
	iniread, air_move, movementsettings.ini, destiny_settings, air_move, %A_Space%
	iniread, heavy_attack, movementsettings.ini, destiny_settings, heavy_attack, %A_Space%
	iniread, light_attack, movementsettings.ini, destiny_settings, light_attack, %A_Space%
	iniread, toggle_crouch, movementsettings.ini, destiny_settings, toggle_crouch, %A_Space%
	iniread, primary_weapon, movementsettings.ini, destiny_settings, primary_weapon, %A_Space%
	iniread, special_weapon, movementsettings.ini, destiny_settings, special_weapon, %A_Space%
	iniread, heavy_weapon, movementsettings.ini, destiny_settings, heavy_weapon, %A_Space%
	iniread, jump, movementsettings.ini, destiny_settings, jump, %A_Space%
	iniread, block, movementsettings.ini, destiny_settings, block, %A_Space%

	iniread, lessoptions, movementsettings.ini, destiny_settings, lessoptionss, %A_Space%
	iniread, bigballs, movementsettings.ini, destiny_settings, bigballss, %A_Space%

	gui, destroy
	; channeling my inner yandere dev
	if (menu_bind = light_skate_bind || menu_bind = heavy_skate_bind || menu_bind = snap_skate_bind || menu_bind = strand_skate_bind) {
		; if overlapping binds... reopen gui and freak the fuck out cus the menu bind is the same as another bind
		overlapping_binds = 1
		gosub, movementgui
	} else {
		hotkey, %menu_bind%, menu
		overlapping_binds = 0
	}
	if (light_skate_bind) {
		hotkey, %light_skate_bind%, light_skate_bind
	}
	if (heavy_skate_bind) {
		hotkey, %heavy_skate_bind%, heavy_skate_bind
	}
	if (strand_skate_bind && !lessoptions) {
		hotkey, %strand_skate_bind%, strand_skate_bind
	}
	if (snap_skate_bind && !lessoptions) {
		hotkey, %snap_skate_bind%, snap_skate_bind	
	}
return



movementgui:
	; ??????????
	Gui, +hwndHGUI

	; if menu bind is equal to any other bind, freak the fuck out
	if(overlapping_binds) {
		gui font, s11 q5 cred, verdana
		gui add, text, x120 y575 w300 h25 +0x200, your menu bind is the same as another!
	}
	; gui settings
	gui font, s11 q5 cblack, verdana
	gui, -minimizebox
	; sub menu shit, taken from https://www.autohotkey.com/docs/v1/lib/Menu.htm
	; Menu, EditMenu, Add, I went fishing with Jeffrey Epstein, MenuHandler
	; Menu, EditMenu, Add, I went to the zoo with Michael Jackson, MenuHandler
	; Menu, EditMenu, Add ; with no more options, this is a seperator
	; Menu, EditMenu, Add, I was only 4, MenuHandler

	Menu, MyMenuBar, Add, %bigballs%, lessoptions

	; Menu, MyMenuBar, Add, HELP ME I DON'T KNOW WHAT'S GOING ON, :EditMenu
	Menu, MyMenuBar, Add, Discord, opendiscord

	Gui, Menu, MyMenuBar ; Attach MyMenuBar to the GUI

	if(!lessoptions) {
		gui add, button, x120 y550 w300 h25 +default, save
	} else {
		gui add, button, x5 y195 w230 h25 +default, save
	}
	; draw save button first to ensure it is default 
	if(!lessoptions) {
	; draw a box around skate settings
		gui font, s12 bold q5 cblack, verdana
		gui add, groupbox, x5 y5 w275 h300, skate settings
		gui font, s11 norm q5 cblack, verdana
	} else {
		gui font, s12 bold q5 cblack, verdana
		gui add, groupbox, x5 y5 w230 h150, skate settings
		gui font, s11 norm q5 cblack, verdana
	}

	; light skate
	gui add, text, x15 y30 w150 h25 +0x200, ground skate:
	gui add, edit, x125 y30 w75 h25 vlight_skate_bind, %light_skate_bind%
	gui add, checkbox, x15 y60 checked%auto_jump_light_skate% vauto_jump_light_skate, jump after light skate?

	; heavy skate
	gui add, text, x15 y90 w150 h25 +0x200, edge skate:
	gui add, edit, x125 y90 w75 h25 vheavy_skate_bind, %heavy_skate_bind%
	gui add, checkbox, x15 y120 checked%auto_jump_heavy_skate% vauto_jump_heavy_skate, jump after heavy skate?
	if(!lessoptions) {
	; strand skate
	gui add, text, x15 y150 w150 h25 +0x200, strand skate:
	gui add, edit, x125 y150 w75 h25 vstrand_skate_bind, %strand_skate_bind%
	gui add, checkbox, x15 y180 checked%auto_jump_strand_skate% vauto_jump_strand_skate, jump after strand skate?

	; snap skate
	gui add, text, x15 y210 w150 h25 +0x200, snap skate:
	gui add, edit, x125 y210 w75 h25 vsnap_skate_bind, %snap_skate_bind%
	gui add, checkbox, x15 y240 checked%auto_jump_snap_skate% vauto_jump_snap_skate, jump after snap skate?

	; snap skate
	gui add, text, x15 y270 w150 h25 +0x200, menu:
	gui add, edit, x125 y270 w75 h25 vmenu_bind, %menu_bind%
	}

	if(!lessoptions) {
		; draw a box around destiny settings
		gui font, s12 bold q5 cblack, verdana
		gui add, groupbox, x295 y5 w245 h365, destiny settings
		gui font, s11 norm q5 cblack, verdana

		; super
		gui add, text, x305 y30 w150 h25 +0x200, super:
		gui add, edit, x435 y30 w75 h25 vsuper, %super%

		; light attack
		gui add, text, x305 y60 w150 h25 +0x200, light attack:
		gui add, edit, x435 y60 w75 h25 vlight_attack, %light_attack%

		; heavy attack
		gui add, text, x305 y90 w150 h25 +0x200, heavy attack:
		gui add, edit, x435 y90 w75 h25 vheavy_attack, %heavy_attack%

		; block
		gui add, text, x305 y120 w150 h25 +0x200, block:
		gui add, edit, x435 y120 w75 h25 vblock, %block%

		; primary weapon
		gui add, text, x305 y150 w150 h25 +0x200, primary weapon:
		gui add, edit, x435 y150 w75 h25 vprimary_weapon, %primary_weapon%

		; special weapon
		gui add, text, x305 y180 w150 h25 +0x200, special weapon:
		gui add, edit, x435 y180 w75 h25 vspecial_weapon, %special_weapon%

		; heavy weapon
		gui add, text, x305 y210 w150 h25 +0x200, heavy weapon:
		gui add, edit, x435 y210 w75 h25 vheavy_weapon, %heavy_weapon%

		; jump
		gui add, text, x305 y240 w150 h25 +0x200, jump:
		gui add, edit, x435 y240 w75 h25 vjump, %jump%

		; crouch
		gui add, text, x305 y270 w150 h25 +0x200, crouch:
		gui add, edit, x435 y270 w75 h25 vtoggle_crouch, %toggle_crouch%

		; air move
		gui add, text, x305 y300 w150 h25 +0x200, air move:
		gui add, edit, x435 y300 w75 h25 vair_move, %air_move%

		; melee charged
		gui add, text, x305 y330 w150 h25 +0x200, melee charged:
		gui add, edit, x435 y330 w75 h25 vmelee_charged, %melee_charged%

		; delays
		gui font, s12 bold q5 cblack, verdana
		gui add, groupbox, x5 y325 w285 h220, delays
		gui font, s11 norm q5 cblack, verdana

		; delay 1
		gui add, text, x15 y350 w100 h25 +0x200, delay 1:
		gui add, edit, x80 y350 w75 h25 vdelay_1, %delay_1%

		; delay 2
		gui add, text, x15 y380 w100 h25 +0x200, delay 2:
		gui add, edit, x80 y380 w75 h25 vdelay_2, %delay_2%

		; delay 3
		gui add, text, x15 y410 w100 h25 +0x200, delay 3:
		gui add, edit, x80 y410 w75 h25 vdelay_3, %delay_3%

		; auto jump delay
		gui add, text, x15 y440 w150 h25 +0x200, auto jump delay:
		gui add, edit, x160 y440 w75 h25 vauto_jump_delay, %auto_jump_delay%

		; weapon swap back delay
		gui add, text, x15 y470 w190 h25 +0x200, swap back delay:
		gui add, edit, x160 y470 w75 h25 vweapon_swapback_delay, %weapon_swapback_delay%

		; weapon swap delay
		gui add, text, x15 y500 w170 h25 +0x200, heavy swap delay:
		gui add, edit, x160 y500 w75 h25 vweapon_swap_delay, %weapon_swap_delay%



		; modes
		gui add, checkbox, x300 y375 checked%primary_swap% gCheck vprimary_swap, primary swap back
		gui add, checkbox, x300 y405 checked%secondary_swap% gCheck vsecondary_swap, secondary swap back
		gui add, checkbox, x300 y435 checked%heavy_swap% vheavy_swap, heavy swap

		gui add, checkbox, x300 y465 checked%shatter_mode%  vshatter_mode, shatter mode

		gui add, checkbox, x300 y495 checked%lament_mode% gCheck1 vlament_mode, lament mode
		gui add, checkbox, x300 y525 checked%eager_mode% gCheck1 veager_mode, eager mode



		gui show, w550, movement settings
	} else { 

	gui add, checkbox, x5 y165 checked%shatter_mode%  vshatter_mode, shatter mode
	gui show, w245, movement settings
	}
	HMENU := DllCall("User32.dll\GetMenu", "Ptr", HGUI, "UPtr")
	SetMenuItemTypeRightJustify(HGUI, HMENU, 2)
return

lessoptions:
	lessoptions:=!lessoptions
	if(lessoptions) {
		bigballs = "MORE"
	} else {
		bigballs = "LESS"
	}
	gui, submit
	Menu, MyMenuBar, deleteall
	gosub, writetoini
	gosub, readfromini
	gosub, movementgui
return

opendiscord:
	Run, https://discord.gg/KGyjysA5WY
return


Check:
	If (A_GuiControl="primary_swap")
		GuiControl,,secondary_swap,0
	Else 
		GuiControl,,primary_swap,0
return

Check1:
	If (A_GuiControl="eager_mode")
		GuiControl,,lament_mode,0
	Else 
		GuiControl,,eager_mode,0
return

buttonsave:
	gui, submit
	gosub, writetoini
	gui, destroy
	reload
return

guiclose:
	gui, submit
	gosub, writetoini
	gui, destroy
return

menu:
	if (winexist("movement settings")) {
		gui, show
	} else {
		gosub, movementgui
	}
return

light_skate_bind:
	if(heavy_swap){	
		send {%heavy_weapon%}
		PreciseSleep(weapon_swap_delay)
	}
	if(lament_mode){
		send {%block% down}
		PreciseSleep(500)
	}
	send {%jump%}
	PreciseSleep(delay_1)
	send {%light_attack%}
	PreciseSleep(delay_2)
	send {%jump%}
	PreciseSleep(delay_3)
	if(shatter_mode){
		send {%air_move%}
	} else {
		send {%super%}
	}
	if(lament_mode){
		send {%block% up}
	}
	if(auto_jump_light_skate){
		PreciseSleep(auto_jump_delay)
		send {%jump%}
	}
	if(primary_swap){
		PreciseSleep(weapon_swapback_delay)
		send {%primary_weapon%}
	}
	if(secondary_swap){
		PreciseSleep(weapon_swapback_delay)
		send {%special_weapon%}
	}
return

heavy_skate_bind:
	if(heavy_swap){	
		send {%heavy_weapon%}
		PreciseSleep(weapon_swap_delay)
	}
	send {%heavy_attack%}
	PreciseSleep(delay_2)	
	send {%jump%}
	if(shatter_mode){
		send {%air_move%}
	} else {
		send {%super%}
	}
	if(auto_jump_heavy_skate){
		PreciseSleep(auto_jump_delay)
		send {%jump%}
	}
	if(primary_swap){
		PreciseSleep(weapon_swapback_delay)
		send {%primary_weapon%}
	}
	if(secondary_swap){
		PreciseSleep(weapon_swapback_delay)
		send {%special_weapon%}
	}
return

strand_skate_bind:
	if(heavy_swap){	
		send {%heavy_weapon%}
		PreciseSleep(weapon_swap_delay)
	}
	send {%heavy_attack%}
	PreciseSleep(delay_2)
	send {%air_move%}
	send {%jump%}
	if(auto_jump_strand_skate){
		PreciseSleep(auto_jump_delay)
		send {%jump%}
	}
	if(primary_swap){
		PreciseSleep(weapon_swapback_delay)
		send {%primary_weapon%}
	}
	if(secondary_swap){
		PreciseSleep(weapon_swapback_delay)
		send {%special_weapon%}
	}
return

snap_skate_bind:
	send {%toggle_crouch%}
	PreciseSleep(delay_1)
	send {%jump%}
	PreciseSleep(delay_2)
	send {%super%}
	PreciseSleep(delay_2)
	send {%jump%}
	PreciseSleep(delay_2)
	send {%air_move%}
	if(auto_jump_snap_skate){
		PreciseSleep(auto_jump_delay)
		send {%jump%}
	}
	if(primary_swap){
		PreciseSleep(weapon_swapback_delay)
		send {%primary_weapon%}
	}
	if(secondary_swap){
		PreciseSleep(weapon_swapback_delay)
		send {%special_weapon%}
	}
return