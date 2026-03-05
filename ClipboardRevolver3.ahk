; Version 3

#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

Menu, Tray, Icon, icon.ico

;#REGION VARIABLES

isRunning := True
isWheeling := True

TOOLTIPNUMBER := 2

display_tip_max_char := 50

SPACECHAR := " "

revolverarray := ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
revolverlockarray := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
; revolverlockarray := [False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False]

max_index := 12
min_index := 0
current_index := 0
current_clipboard := ""

changetriggered := False

; Initialize a counter for the mouse wheel movements
WheelCounter := 0
WheelTimer := 0
; Define the threshold for the number of wheel movements required
Threshold := 3 ; Adjust this value as needed
; Define the time window in milliseconds to reset the counter
ResetTime := 300 ; Adjust this value as needed (e.g., 300 ms)

SoundPath := "C:\Users\Teaio\Documents\marcus\_ahk scripts\clipboard_quick_select\revolver click2.mp3"

LockChar := Chr(0x1F512)
UnlockChar := Chr(0x1F513)
KeyChar := Chr(0x1F511)
LockChar := Chr(0x1F512)
UnlockChar := Chr(0x1F513)
KeyChar := Chr(0x1F511)
SpaceChar := " "

; OnClipboardChange(Callback , 1)

;#ENDREGION VARIABLES

; ; Menu, Tray, Icon, C:\Users\Teaio\Documents\marcus\_ahk scripts\clipboard_quick_select\icon.ico

MainLabel()

;#REGION Tooltip functions
ClearMainToolTip() {
    global TOOLTIPNUMBER
    ToolTip(, , , TOOLTIPNUMBER)
}

ClearOtherTooltips() {
    global max_index
    global TOOLTIPNUMBER

    loop max_index {
        ToolTip(, , , TOOLTIPNUMBER + A_Index)
    }
}

ClearTooltips() {
    ClearMainTooltip()
    ClearOtherTooltips()
}

;#ENDREGION Tooltip functions

;#REGION Toggle Function
!MButton::
    Gosub, ToggleLabel
Return

; +!MButton::
;     if (!isRunning) {
;         Send, +!{MButton}
;         Return
;     }
;     isWheeling := ! isWheeling
;     ToolTip, isWheeling %isWheeling%
;     Sleep, 300

;     ToolTip
; Return

#C::
    Gosub, ToggleLabel
Return

ToggleLabel:
    isRunning := !isRunning

        if (!isRunning) {
            current_clipboard := revolverarray[current_index]
            ClearTooltips()
        }
        return
        ;#ENDREGION Toggle Function

        ;#REGION MAIN
    } ; V1toV2: Added bracket before function

    MainLabel() { ; V1toV2: Added bracket
        global ; V1toV2: Made function global
        while (True) {
            MouseGetPos(&curmousex, &curmousey, &curmousewindow) ;, OutputVarControl, 1|2|3]

            if (isRunning) {
                ; ToolTip, %currentdisplayind%, curmousex - 100, curmousey-100, TOOLTIPNUMBER -1
                ; ToolTip, %clipboard%, curmousex, curmousey, TOOLTIPNUMBER

            if (GetKeyState("LAlt", "P") and GetKeyState("Shift", "P")) {
                isWheeling := ! isWheeling
                ToolTip, isWheeling %isWheeling%, curmousex - 100, curmousey + 16
                Sleep, 300
                ToolTip
            }

            if (GetKeyState("LAlt", "P") and isWheeling) {

                if (!changetriggered) {
                    changetriggered := True
                }

                    loop max_index {
                        offset := 1

                        currentdisplayind := Mod((current_index + A_Index - offset) + max_index, max_index)
                        current_clipboard := revolverarray[currentdisplayind]

                        texttodisplay := current_clipboard

                        cur_display_tip_max_char := display_tip_max_char

                        if (A_Index == 1) {
                            cur_display_tip_max_char := cur_display_tip_max_char * 3
                        }
                        else if ((A_Index) > 3 && A_Index < 11) {
                            cur_display_tip_max_char := 6
                        }

                        if (StrLen(texttodisplay) > cur_display_tip_max_char) {
                            texttodisplay := SubStr(current_clipboard, 1, cur_display_tip_max_char) . "..."
                        }

                        ; modifier := (1-Abs(0.1*(A_Index -4)))
                        modifier2 := cos((offset - A_Index) * 3.141592654 / 6)
                        modifier3 := sin((A_Index - offset) * 3.141592654 / 6)
                        modifier4 := 0.5 * (A_Index - offset)

                        if (!texttodisplay) {
                            texttodisplay := SPACECHAR
                        }

                        if (revolverlockarray[currentdisplayind]) {
                            texttodisplay := LockChar . " " . texttodisplay
                        }

                        ToolTip(texttodisplay, curmousex + (100 * modifier2) - 84, curmousey - (100 * modifier3) + 16,
                        TOOLTIPNUMBER + A_Index - 1)
                    }
                    ;loop end====================

                }
                else {
                    current_clipboard := revolverarray[current_index]
                    texttodisplay := current_clipboard
                    if (!texttodisplay) {
                        texttodisplay := SPACECHAR
                    }

                    if (revolverlockarray[current_index]) {
                        texttodisplay := LockChar . " " . texttodisplay
                    }

                    ToolTip(texttodisplay, curmousex + 16, curmousey + 16, TOOLTIPNUMBER)
                    ClearOtherTooltips()

                    UpdateChangeLabel()

                }

                ;else end====================
            }
            else { ; fishhhh
                ClearTooltips()
            }

            ; Sleep, 10
        }

        MsgBox("Somehow the infinite loop has broken. Please restart", "Error", "")

        return

        ;#ENDREGION MAIN

OnClipboardChange:
    ; MsgBox, , TEST, %ClipboardAll%
    if (!isRunning || GetKeyState("Alt", "P") = 1){
        return
    }
    if (revolverlockarray[current_index] || revolverarray[current_index] != "") {
        ; MsgBox, , test, test, 1
        changetriggered = True
        Gosub, UpdateChangeLabel
        return
    }
    Sleep, 100
    ; current_clipboard := Clipboard
    revolverarray[current_index] := Clipboard
    clipboardallarray%current_index% := ClipboardAll

            if (revolverarray[current_index] = "" && clipboardallarray%current_index% != "") {
                revolverarray[current_index] := " ... "
            }
            return
        } ; V1toV2: Added Bracket before label
    } ; V1toV2: Added bracket before function

UpdateChangeLabel:
    if (changetriggered) {
        changetriggered := False
        ; Clipboard := revolverarray[current_index]
        Clipboard := clipboardallarray%current_index%
    }
Return

Testlabel:

Return

;#REGION CLEAR
!Space::
    if (!isRunning) {
        Send, !{Space}
        Return
    }
    if (!revolverlockarray[current_index]) {
        revolverarray[current_index] := ""
        clipboardallarray%current_index% := ""
    }

        return
    } ; V1toV2: Added Bracket before hotkey or Hotstring

^!Space::
    if (!isRunning) {
        Send, ^!{Space}
        Return
    }
    Fish := max_index + 1
    Loop, %Fish% {
        curindex := A_Index -1
        if (!revolverlockarray[curindex]) {
            revolverarray[curindex] := ""
            clipboardallarray%curindex% := ""
        }
    }
Return

;#ENDREGION CLEAR
!l::
    if (!isRunning) {
        Send, !{l}
        Return
    }
    MouseGetPos, curmousex, curmousey, curmousewindow ;, OutputVarControl, 1|2|3]

        if (!revolverlockarray[current_index]) {
            ToolTip("Locking " SpaceChar " " SpaceChar " " LockChar, curmousex - 80, curmousey + 16)

            revolverlockarray[current_index] := 1
        }
        else {
            ToolTip("Unlocking " UnlockChar, curmousex - 80, curmousey + 16)

            revolverlockarray[current_index] := 0
        }

        Sleep(300)
        ToolTip()

        return

    } ; V1toV2: Added Bracket before hotkey or Hotstring

; Hotkey for the mouse wheel down
!WheelDown::
    if (!isRunning) {
        Send, !{WheelDown}
        Return
    }
    ; WheelCounter++
    ; Reset the timer
    ; SetTimer, ResetWheelCounter, Off
    ; SetTimer, ResetWheelCounter, %ResetTime%
    ; if (WheelCounter >= Threshold)
    ; {
    ;     WheelCounter := 0
    NextSlotLabel()
; }
Return

; Hotkey for the mouse wheel up
!WheelUp::
    if (!isRunning) {
        Send, !{WheelUp}
        Return
    }
    ; WheelCounter++
    ; ; Reset the timer
    ; SetTimer, ResetWheelCounter, Off
    ; SetTimer, ResetWheelCounter, %ResetTime%
    ; if (WheelCounter >= Threshold)
    ; {
    ;     WheelCounter := 0
    PreviousSlotLabel()
; }
Return

        ; Timer to reset the wheel counter
    } ; V1toV2: Added bracket before function
    ResetWheelCounter() { ; V1toV2: Added bracket
        global ; V1toV2: Made function global
        WheelCounter := Threshold
        SetTimer(ResetWheelCounter, 0)
        return

        ;#region Moving Arrows
    } ; V1toV2: Added Bracket before hotkey or Hotstring

!Right::
    if (!isRunning) {
        Send, !{Right}
        Return
    }
    NextSlotLabel()

Return

!Down::
    if (!isRunning) {
        Send, !{Down}
        Return
    }
    NextSlotLabel()
Return

!Left::
    if (!isRunning) {
        Send, !{Left}
        Return
    }
    PreviousSlotLabel()
Return

!Up::
    if (!isRunning) {
        Send, !{Up}
        Return
    }
    PreviousSlotLabel()
Return

        ;#endregion Moving Arrows
    } ; V1toV2: Added bracket before function

    NextSlotLabel() {
        global isRunning, SoundPath, current_index, min_index, max_index

        if (!isRunning)
            return
        ; SoundPlay, %SoundPath%
        ; SoundPlay, *-1
        current_index := current_index - 1
        if (current_index < min_index) {
            current_index := max_index - 1
        }

    }

    PreviousSlotLabel() {
        global isRunning, SoundPath, current_index, min_index, max_index

        if (!isRunning)
            return
        ; SoundPlay, %SoundPath%
        ; SoundPlay, *-1

        current_index := current_index + 1
        if (current_index >= max_index) {
            current_index := min_index
        }
    }

; ~^x::
; ~^c::
; Return

!v::
    if (!isRunning) {
        Send, !{v}
        Return
    }
    KeyWait, Alt, U
    Gosub, UpdateChangeLabel
    Sleep, 300
    SetKeyDelay, 50
    Send, %Clipboard%
    SetKeyDelay, 10
Return

        ; # Manual input
    } ; V1toV2: Added Bracket before hotkey or Hotstring

!n::
    if (!isRunning) {
        Send, !{n}
        Return
    }
    KeyWait, Alt, U
    ClearTooltips()
    CoordMode, Mouse, Screen
    MouseGetPos, curmousex, curmousey, curmousewindow ;, OutputVarControl, 1|2|3]
    InputBox, NewClipboard, , , , 200, 100, curmousex, curmousey, Locale, ,

        ; Gui, +AlwaysOnTop +ToolWindow -Caption +LastFound +Owner ; Creates a GUI without a title bar
        ; ; Gui, Color, EEAA99 ; Sets the background color of the GUI
        ; Gui, Font, s10 ; Sets the font size
        ; Gui, Add, Edit, vMyEdit w200 h20, ; w200 sets the width, h20 sets the height
        ; Gui, Show, xCenter yCenter NoActivate ; Centers the GUI on the screen

        ; ControlFocus, Edit1, A
        ; WinSet, Transparent, 200

    Clipboard := NewClipboard
    revolverarray[current_index] := Clipboard
    clipboardallarray%current_index% := ClipboardAll

Return

        ; ; Define a hotkey to submit the input
        ; #IfWinActive ahk_class AutoHotkeyGUI
        ; Enter::
        ;     Gui, Submit, NoHide

        ;     Clipboard := MyEdit
        ;     revolverarray[current_index] := Clipboard
        ;     clipboardallarray%current_index% := ClipboardAll

        ;     Gui, Destroy
        ; return

        ; ; Define a hotkey to exit the input box
        ; Esc::
        ;     Gui, Destroy
        ; return
        ; #IfWinActive

    } ; V1toV2: Added bracket in the end
