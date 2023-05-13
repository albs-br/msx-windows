Notepad:

; fixed values for app initialization
.Header:

.processId:		        db 0		    ; 255: empty (this will be defined by the OS on app startup)
.windowState:	        db WINDOW_STATE.RESTORED
.x:			            db 8
.y:			            db 16
.width:		            db 11
.height:		        db 8
.minWidth:		        db 10
.minHeight:		        db 8

.windowTitle:
                        db TILE_FONT_REVERSED_LOWERCASE_A + 13 ; 'n'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 14 ; 'o'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 19 ; 't'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 4  ; 'e'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 15 ; 'p'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 0  ; 'a'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 3  ; 'd'
                        db 0 ; end of string
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
