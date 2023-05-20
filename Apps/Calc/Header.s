Calc:

; fixed values for app initialization
.Header:

.processId:		        db 255		    ; on app header must be always 255 (will be given an id by the OS at app load)
.windowState:	        db WINDOW_STATE.RESTORED
.x:			            db 8 + 13
.y:			            db 10
.width:		            db 10
.height:		        db 8
.minWidth:		        db 10
.minHeight:		        db 8

.windowTitle:
                        db TILE_FONT_REVERSED_LOWERCASE_A + 2  ; 'c'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 0  ; 'a'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 11 ; 'l'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 2  ; 'c'
                        db 0 ; end of string
                        db 33
                        db 33
                        db 33
                        db 33
                        db 33
                        db 33
                        db 33
                        db 33
                        db 33
                        db 33
                        db 33
                        
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
    INCLUDE "Apps/Calc/Open.s"

.Work:
    INCLUDE "Apps/Calc/Work.s"

.Draw:
    INCLUDE "Apps/Calc/Draw.s"

.Click:
    INCLUDE "Apps/Calc/Click.s"

.Close:
    INCLUDE "Apps/Calc/Close.s"

.EndProgramCode:                ; this may be useful on future for code dinamically relocatable
