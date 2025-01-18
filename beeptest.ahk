#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

f5::
    ; Test script for playing a beep sound
    DllCall("Kernel32.dll\Beep", UInt, 750, UInt, 300) ; Frequency 750 Hz, Duration 300 ms
Return