Notepad:

.Header:
.processId:		        db 0		    ; 255: empty (this will be defined by the OS on app startup)
.windowState:	        db WINDOW_STATE.RESTORED
.x:			            db 8
.y:			            db 4
.width:		            db 20
.height:		        db 12
.minWidth:		        db 16
.minHeight:		        db 8

.windowTitle:	        db 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33  ; 16 chars fixed
.isFixedSize:	        db 0
.vertScrollbarEnabled:	db 0
.vertScrollbarPosition:	db 0


; these addresses are fixed and come from App header
.openAddr:		        dw .Open
.workAddr:		        dw .Work
.drawAddr:		        dw .Draw
.clickAddr:		        dw .Click
.closeAddr:		        dw .Close



.Open:
    INCLUDE "../Notepad/Open.s"

.Work:
    INCLUDE "../Notepad/Work.s"

.Draw:
    INCLUDE "../Notepad/Draw.s"

.Click:
    INCLUDE "../Notepad/Click.s"

.Close:
    INCLUDE "../Notepad/Close.s"

