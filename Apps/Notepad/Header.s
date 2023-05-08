Notepad:

.Header:
; header here

; .openAddr:		dw .Open
; .workAddr:		dw .Work


.Open:
    INCLUDE "../Notepad/Open.s"

.Draw:
    INCLUDE "../Notepad/Draw.s"

.Work:
    INCLUDE "../Notepad/Work.s"

.Click:
    INCLUDE "../Notepad/Click.s"

.Close:
    INCLUDE "../Notepad/Close.s"

