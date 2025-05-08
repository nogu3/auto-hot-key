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

; [key combination]
; allow for vim
~^left::home
~^right::end

; for slack
!Enter::^Enter

; [system]
; screen lock
; https://stackoverflow.com/questions/42314908/how-can-i-lock-my-computer-with-autohotkey
^+r::DllCall("LockWorkStation")

 ; shift + alt + space is undefine for vscode shortcut
!+Space::return

; screen shot
^+s::#+s

; 最大化（カレントモニター）
#up:: {
    activeMonitor := GetMonitorIndexFromWindow(WinExist("A"))
    MonitorGetWorkArea(activeMonitor, &monitorLeft, &monitorTop, &monitorRight, &monitorBottom)
    monitorWidth := monitorRight - monitorLeft
    monitorHeight := monitorBottom - monitorTop
    WinMove(monitorLeft, monitorTop, monitorWidth, monitorHeight, "A")
}

; 左半分表示（カレントモニター）- 隙間調整
#+Left:: {
    activeMonitor := GetMonitorIndexFromWindow(WinExist("A"))
    MonitorGetWorkArea(activeMonitor, &monitorLeft, &monitorTop, &monitorRight, &monitorBottom)
    monitorWidth := monitorRight - monitorLeft
    monitorHeight := monitorBottom - monitorTop
    
    ; 隙間調整（+1ピクセル）
    adjustedWidth := monitorWidth / 2 + 1
    
    WinMove(monitorLeft, monitorTop, adjustedWidth, monitorHeight, "A")
}

; 右半分表示（カレントモニター）- 隙間調整
#+Right:: {
    activeMonitor := GetMonitorIndexFromWindow(WinExist("A"))
    MonitorGetWorkArea(activeMonitor, &monitorLeft, &monitorTop, &monitorRight, &monitorBottom)
    monitorWidth := monitorRight - monitorLeft
    monitorHeight := monitorBottom - monitorTop
    
    ; 位置と幅の調整
    adjustedWidth := monitorWidth / 2 + 1
    adjustedLeft := monitorLeft + monitorWidth / 2 - 1
    
    WinMove(adjustedLeft, monitorTop, adjustedWidth, monitorHeight, "A")
}

; アクティブウィンドウがあるモニターのインデックスを取得する関数
GetMonitorIndexFromWindow(windowHandle) {
    ; モニター情報を取得
    monitorCount := MonitorGetCount()
    if (monitorCount <= 1)
        return 1
    
    ; ウィンドウの位置を取得
    WinGetPos(&winX, &winY, &winWidth, &winHeight, windowHandle)
    winMiddleX := winX + winWidth / 2
    winMiddleY := winY + winHeight / 2
    
    ; 各モニターについて確認
    Loop monitorCount {
        MonitorGetWorkArea(A_Index, &monLeft, &monTop, &monRight, &monBottom)
        if (winMiddleX >= monLeft && winMiddleX <= monRight && winMiddleY >= monTop && winMiddleY <= monBottom) {
            return A_Index
        }
    }
    
    ; デフォルト値（プライマリモニター）
    return 1
}