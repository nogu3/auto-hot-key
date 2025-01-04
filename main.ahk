#Requires AutoHotkey v2.0

; Main
; https://www.naporitansushi.com/autohotkey/#
; official
; https://ahkscript.github.io/ja/docs/v2/Hotkeys.htm#Intro

; use keyboard hook
#UseHook
; This AutoHotkey is auto restart when another AutoHotkey script.
#SingleInstance Force
; working dir is script run dir.
SetWorkingDir A_ScriptDir

; [functions]
; alone and withctrl is keybind.
CombinationCtrl(alone, withctrl) {
    if GetKeyState("Control") {
        Send withctrl
        return
    }

    Send alone
}

; key is valid when single
SinglePress(lastkey, sendkey) {
    KeyWait lastkey
    If (A_PriorKey = lastkey)
    {
        Send sendkey
    }
    return
}

; [single press]
~LControl:: SinglePress("LControl", "{Enter}")

; [key combination]
; allow
~^left::home
~^right::end

; semicolon and colon
^Enter::Send "{`;}"
+Enter::Send "{`:}"
; for slack
!Enter:: ^Enter

; LAlt -> eisuu
LAlt::Send "{vk1Dsc07B}"

; RAlt -> kana
RAlt::Send "{vk1Csc079}"

; [system]
; alt tab
LAlt & w::AltTab

; screen lock
; https://stackoverflow.com/questions/42314908/how-can-i-lock-my-computer-with-autohotkey
^+r::DllCall("LockWorkStation")

 ; shift + alt + space is undefine for vscode shortcut
!+Space::return

; screen shot
^+s::#+s

; maximize win
#up:: {
  WinMove 0, 0, A_ScreenWidth, A_ScreenHeight, "A"
}

; left win
#+Left:: {
  WinMove 0, 0, A_ScreenWidth/2, A_ScreenHeight, "A"
}

; right win
#+Right:: {
  WinMove A_ScreenWidth/2, 0, A_ScreenWidth/2, A_ScreenHeight, "A"
}
