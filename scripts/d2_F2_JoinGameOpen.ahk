#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

F2::
    Click
    Click
    Click
    clipboard := ""
    Send, ^c
    ClipWait
    if (ErrorLevel) {
        MsgBox, Clipboard wait timed out.
        return
    }
    if WinExist("ahk_exe destiny2.exe") {
        WinActivate
        Sleep, 100
        Pattern := "i)/join.*?#[0-9]{4}"
        if (RegExMatch(clipboard, Pattern, JoinCmd)) {
            clipboard := JoinCmd
        } else {
            MsgBox, No valid join command found.
            return
        }
        Send, {Enter}
        Sleep, 100
        Send, ^v
        Sleep, 100
        Send, {Enter}
        Sleep, 100
        return
    } else {
        MsgBox, idiot, open d2
    }
return