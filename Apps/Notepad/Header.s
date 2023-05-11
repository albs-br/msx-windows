Notepad:

; fixed values for app initialization
.Header:

.processId:		        db 0		    ; 255: empty (this will be defined by the OS on app startup)
.windowState:	        db WINDOW_STATE.RESTORED
.x:			            db 8
.y:			            db 1
.width:		            db 10
.height:		        db 20
.minWidth:		        db 16
.minHeight:		        db 8

.windowTitle:	        db 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33  ; 16 chars fixed
.isFixedSize:	        db 0
.vertScrollbarEnabled:	db 0
.vertScrollbarPosition:	db 0


.openAddr:		        dw .Open
.workAddr:		        dw .Work
.drawAddr:		        dw .Draw
.clickAddr:		        dw .Click
.closeAddr:		        dw .Close

.ramSize:		        dw 1024     ; RAM space reserved for variables of this app

.StartProgramCode:

.Open:
    INCLUDE "Apps/Notepad/Open.s"

.Work:
    INCLUDE "Apps/Notepad/Work.s"

.Draw:
    INCLUDE "Apps/Notepad/Draw.s"

.Click:
    INCLUDE "Apps/Notepad/Click.s"

.Close:
    INCLUDE "Apps/Notepad/Close.s"

.EndProgramCode:                ; this may be useful on future for code dinamically relocatable
