#SingleInstance force
#MaxThreadsPerHotkey 2
#NoEnv
CoordMode,Pixel,Screen
CoordMode,Mouse,Screen
SetBatchLines, -1
global SCRIPT_NAME := "LA - Buy Fish"
global Settings_Strings := ["MP_Search", "Search", "Fish", "Buy", "Bundles", "Purchase", "Pet", "Select", "Take"]
global Settings_Prompts := [">>>OPEN marketplace<<< then hover over search bar and press enter", ">>>HOVER over<<< magnifying glass and press enter", ">>>SEARCH item<<< then hover over item row and press enter", ">>>HOVER over<<< 'Buy' button and press enter", ">>>OPEN Buy Window<<< then hover over number for bundles and press enter", ">>>HOVER over Buy<<< and press enter", ">>>OPEN Pet menu<<< then hover over Mail icon press enter", ">>>OPEN Mail menu<<< then hover over Select all press enter", ">>>HOVER over Take attachment<<< and press enter"]
#Include, %A_ScriptDir%\GUI.ahk

WriteCfg(i, val) {
	IniWrite, %i%, %A_ScriptDir%\cfg\settings.ini, Coords, %val%
}	

GameWindow() {
	if (not WinActive("ahk_class EFLaunchUnrealUWindowsClient")) {
		if (WinExist("ahk_class EFLaunchUnrealUWindowsClient")) {
			WinActivate
		}
	}
}

ReadCfg(element) {
	elex := element . "_X"
	eley := element . "_Y"
	IniRead, ele_x, %A_ScriptDir%\cfg\settings.ini, Coords, %elex%
	IniRead, ele_y, %A_ScriptDir%\cfg\settings.ini, Coords, %eley%
	SetStatus(ele_x . " " . ele_y)
	comb := [ele_x, ele_y]
	return comb
}

Setup() {
	SetStatus("Writing config")
	IniWrite, True, %A_ScriptDir%\cfg\settings.ini, Script, Settings
	MsgBox, Performing initial setup, make sure Marketplace shortcut is Alt+Y, and Pet is Alt+P
	for index, str in Settings_Strings {
		message := Settings_Prompts[index]
		MsgBox, %message%
		MouseGetPos, px, py
		app_x := str . "_X"
		app_y := str . "_Y"
		WriteCfg(px, app_x)
		WriteCfg(py, app_y)
	}
}

Main() {
	GameWindow()
	if not FileExist(A_ScriptDir "\cfg") {
		FileCreateDir, %A_ScriptDir%\cfg
	}
	IniRead, cfg_exist, %A_ScriptDir%\cfg\settings.ini, Script, Settings
	if (cfg_exist = "ERROR") {
		Setup()
		reload
	}
	; Load variables
	Send, !y ; Open Marketplace
	Sleep, 150
	while (True) {
		SetStatus("Buying fish")
		; Click search
		mp := ReadCfg(Settings_Strings[1])
		MouseMove, mp[1], mp[2]
		Click
		; Search for fish
		Send, fish
		Sleep, 50
		search := ReadCfg(Settings_Strings[2])
		MouseMove, search[1], search[2]
		Sleep, 50
		Click
		Sleep, 3000
		Loop, 1 {
			BuyFish()
			Sleep, 3000
		}
		Mail()
	}
}

BuyFish() {
	; Buy fish
	fish := ReadCfg(Settings_Strings[3])
	MouseMove, fish[1], fish[2]
	Sleep, 150
	Click
	buy := ReadCfg(Settings_Strings[4])
	MouseMove, buy[1], buy[2]
	Sleep, 150
	Click
	; Enter bundle info
	bundle := ReadCfg(Settings_Strings[5])
	MouseMove, bundle[1], bundle[2]
	Sleep, 150
	Click, 2
	Send, 99
	Sleep, 150
	; Click Buy in Purchase window
	purchase := ReadCfg(Settings_Strings[6])
	MouseMove, purchase[1], purchase[2]
	Sleep, 150
	Click
	Sleep, 150
	Send, {ESC}
}

Mail() {
; Mailbox full, pet process
	SetStatus("Clearing mail")
	Send, !p ; open pet menu
	pet := ReadCfg(Settings_Strings[7])
	Sleep, 500
	MouseMove, pet[1], pet[2]
	Sleep, 150
	Click
	Sleep, 1500
	select := ReadCfg(Settings_Strings[8])
	MouseMove, select[1], select[2]
	Sleep, 150
	Click
	take := ReadCfg(Settings_Strings[9])
	MouseMove, take[1], take[2]
	Sleep, 150
	Click
	MouseMove, select[1], select[2]
	Sleep, 150
	Click
	MouseMove, take[1] + 150, take[2]
	Sleep, 150
	Click
	Sleep, 500
	Send, {Enter}
	Sleep, 1500
	Send, {ESC}
	Sleep, 3000
	Send, {ESC}
	Sleep, 1500
}

F1::Main()
F3::reload
F5::Setup()