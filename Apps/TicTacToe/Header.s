TicTacToe:

; fixed values for app initialization
.Header:

.processId:		        db 255		    ; on app header must be always 255 (will be given an id by the OS at app load)
.windowState:	        db WINDOW_STATE.RESTORED
.x:			            db 2
.y:			            db 2
.width:		            db 14
.height:		        db 15
.minWidth:		        db 14
.minHeight:		        db 15

.windowTitle:
                        db TILE_FONT_REVERSED_LOWERCASE_T
                        db TILE_FONT_REVERSED_LOWERCASE_I
                        db TILE_FONT_REVERSED_LOWERCASE_C
                        db TILE_FONT_REVERSED_LOWERCASE_T
                        db TILE_FONT_REVERSED_LOWERCASE_A
                        db TILE_FONT_REVERSED_LOWERCASE_C
                        db TILE_FONT_REVERSED_LOWERCASE_T
                        db TILE_FONT_REVERSED_LOWERCASE_O
                        db TILE_FONT_REVERSED_LOWERCASE_E
                        db 0 ; end of string ; TODO
                        db 0
                        db 0
                        db 0
                        db 0
                        db 0
                        db 0
.taskbarTitle:
                        db TILE_FONT_REVERSED_LOWERCASE_T
                        db TILE_FONT_REVERSED_LOWERCASE_I
                        db TILE_FONT_REVERSED_LOWERCASE_C
                        db TILE_EMPTY_BLACK
.iconTitle:
                        db TILE_FONT_LOWERCASE_T
                        db TILE_FONT_LOWERCASE_I
                        db TILE_FONT_LOWERCASE_C
                        db TILE_EMPTY
                        db TILE_FONT_LOWERCASE_T
                        db TILE_FONT_LOWERCASE_A
                        db TILE_FONT_LOWERCASE_C

.isFixedSize:	        db 0
.vertScrollbarEnabled:	db 0
.vertScrollbarPosition:	db 0


.openAddr:		        dw TicTacToe_Open
.workAddr:		        dw TicTacToe_Work
.drawAddr:		        dw TicTacToe_Draw
.clickAddr:		        dw TicTacToe_Click
.getFocusAddr:		    dw TicTacToe_GetFocus
.loseFocusAddr:		    dw TicTacToe_LoseFocus
.closeAddr:		        dw TicTacToe_Close

.iconAddr:		        dw TicTacToe_Icon

.ramSize:		        dw 1024     ; RAM space reserved for variables of this app


; --------------------------------------------------
TicTacToe.StartProgramCode:

TicTacToe_Open:
    INCLUDE "Apps/TicTacToe/Open.s"

TicTacToe_Work:
    INCLUDE "Apps/TicTacToe/Work.s"

TicTacToe_Draw:
    INCLUDE "Apps/TicTacToe/Draw.s"

TicTacToe_Click:
    INCLUDE "Apps/TicTacToe/Click.s"

TicTacToe_GetFocus:
    INCLUDE "Apps/TicTacToe/GetFocus.s"

TicTacToe_LoseFocus:
    INCLUDE "Apps/TicTacToe/LoseFocus.s"

TicTacToe_Close:
    INCLUDE "Apps/TicTacToe/Close.s"

TicTacToe.EndProgramCode:                ; this may be useful on future for code dinamically relocatable



; --------------------------------------------------
TicTacToe.StartProgramData:

TicTacToe_Icon:
    INCLUDE "Apps/TicTacToe/Icon.s"

TicTacToe_Data:
    INCLUDE "Apps/TicTacToe/Data.s"

TicTacToe.EndProgramData:                ; this may be useful on future for code dinamically relocatable

