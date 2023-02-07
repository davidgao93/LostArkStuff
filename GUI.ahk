Gui,+AlwaysOnTop
Gui, Add, Button, x12 y19 w110 h30 , Start
Gui, Add, Text, vVar x12 y59 w240 h20 , Status message will appear here...
Gui, Add, Button, x142 y19 w110 h30 , Reload
; Generated using SmartGUI Creator 4.0
Gui, Show, x2280 y1273 h97 w265, %SCRIPT_NAME%
Return

GuiClose:
ExitApp

ButtonReload:
reload 

ButtonStart:
Main()

SetStatus(t) {
	GuiControl,, Var, %t%
}