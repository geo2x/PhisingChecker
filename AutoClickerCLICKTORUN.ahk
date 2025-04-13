#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
SetMouseDelay, -1  ; Max click speed
SetKeyDelay, -1

; Initialize variables
global Recording := false
global Playing := false
global AutoClicking := false
global MouseEvents := []
global StartTime := 0

; F6 - Start/Stop recording
$F6::
    if (!Recording && !Playing)
    {
        Recording := true
        AutoClicking := false
        MouseEvents := []
        StartTime := A_TickCount
        SoundPlay, *-1  ; Beep for start
        TrayTip, AutoClick+, Recording started, 2
    }
    else if (Recording)
    {
        Recording := false
        Playing := true
        SoundPlay, *64  ; Beep for stop
        TrayTip, AutoClick+, Playback started, 2
        SetTimer, Playback, 10  ; Start playback loop
    }
return

; F8 - Toggle autoclicking
$F8::
    AutoClicking := !AutoClicking
    SoundPlay, % (AutoClicking ? *-1 : *64)
    TrayTip, AutoClick+, Autoclicking % (AutoClicking ? "ON" : "OFF"), 2
return

; F9 - Stop playback
$F9::
    if (Playing)
    {
        Playing := false
        AutoClicking := false
        SetTimer, Playback, Off
        SoundPlay, *64
        TrayTip, AutoClick+, Playback stopped, 2
    }
return

; F7 - Exit script
$F7::
    SoundPlay, *16
    ExitApp
return

; Ctrl+Alt+Shift - Kill switch!!!! sorry if your looking at this tried hard to make it work !
$*^!+Escape::
    Recording := false
    Playing := false
    AutoClicking := false
    SetTimer, Playback, Off
    SoundPlay, *16
    TrayTip, AutoClick+, Emergency stop activated, 2
return


#If Recording
*~$LButton::
    RecordEvent("Click", A_TickCount - StartTime)
return

*~$RButton::
    RecordEvent("RClick", A_TickCount - StartTime)
return

; Track mouse movement
SetTimer, RecordMovement, 10
RecordMovement:
    if (Recording)
    {
        MouseGetPos, x, y
        static lastX := x, lastY := y
        if (x != lastX || y != lastY)
        {
            RecordEvent("Move", A_TickCount - StartTime, x, y)
            lastX := x
            lastY := y
        }
    }
return
#If

; Autoclicking loop
SetTimer, AutoClick, 1
AutoClick:
    if (AutoClicking && !Recording && !GetKeyState("LButton", "P"))
    {
        Click
    }
return

Playback:
    if (!Playing)
        return
    static index := 1
    elapsed := A_TickCount - StartTime
    while (index <= MouseEvents.Length() && MouseEvents[index].time <= elapsed)
    {
        event := MouseEvents[index]
        if (event.type = "Click")
            Click
        else if (event.type = "RClick")
            Click, Right
        else if (event.type = "Move")
            MouseMove, % event.x, % event.y, 0
        index++
    }
    if (index > MouseEvents.Length())
    {
        index := 1
        StartTime := A_TickCount
    }
return

RecordEvent(type, time, x:="", y:="")
{
    event := {type: type, time: time}
    if (x != "" && y != "")
    {
        event.x := x
        event.y := y
    }
    MouseEvents.Push(event)
}

