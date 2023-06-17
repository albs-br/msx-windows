Paint:

; fixed values for app initialization
.Header:

.processId:		        db 255		    ; on app header must be always 255 (will be given an id by the OS at app load)
.windowState:	        db WINDOW_STATE.RESTORED
.x:			            db 8 - 3
.y:			            db 4
.width:		            db 14
.height:		        db 8
.minWidth:		        db 12
.minHeight:		        db 6

.windowTitle:
                        db TILE_FONT_REVERSED_LOWERCASE_A + 15 ; 'p'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 0  ; 'a'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 8  ; 'i'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 13 ; 'n'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 19 ; 't'
                        db 0 ; end of string
                        db 0
                        db 0
                        db 0
                        db 0
                        db 0
                        db 0
                        db 0
                        db 0
                        db 0
                        db 0
.taskbarTitle:
                        db TILE_FONT_REVERSED_LOWERCASE_A + 15 ; 'p'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 13 ; 'n'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 19 ; 't'
                        db TILE_EMPTY_BLACK
.iconTitle:
                        db TILE_EMPTY
                        db TILE_FONT_LOWERCASE_A + 15 ; 'p'
                        db TILE_FONT_LOWERCASE_A + 0  ; 'a'
                        db TILE_FONT_LOWERCASE_A + 8  ; 'i'
                        db TILE_FONT_LOWERCASE_A + 13 ; 'n'
                        db TILE_FONT_LOWERCASE_A + 19 ; 't'
                        db TILE_EMPTY

.isFixedSize:	        db 0
.vertScrollbarEnabled:	db 0
.vertScrollbarPosition:	db 0


.openAddr:		        dw Paint_Open
.workAddr:		        dw Paint_Work
.drawAddr:		        dw Paint_Draw
.clickAddr:		        dw Paint_Click
.getFocusAddr:		    dw Paint_GetFocus
.loseFocusAddr:		    dw Paint_LoseFocus
.closeAddr:		        dw Paint_Close

.iconAddr:		        dw Paint_Icon

.ramSize:		        dw 1024     ; RAM space reserved for variables of this app


; --------------------------------------------------
Paint.StartProgramCode:

Paint_Open:
    INCLUDE "Apps/Paint/Open.s"

Paint_Work:
    INCLUDE "Apps/Paint/Work.s"

Paint_Draw:
    INCLUDE "Apps/Paint/Draw.s"

Paint_Click:
    INCLUDE "Apps/Paint/Click.s"

Paint_GetFocus:
    INCLUDE "Apps/Paint/GetFocus.s"

Paint_LoseFocus:
    INCLUDE "Apps/Paint/LoseFocus.s"

Paint_Close:
    INCLUDE "Apps/Paint/Close.s"

Paint.EndProgramCode:                ; this may be useful on future for code dinamically relocatable



; --------------------------------------------------
Paint.StartProgramData:

Paint_Icon:
    INCLUDE "Apps/Paint/Icon.s"

Paint_Data:
    INCLUDE "Apps/Paint/Data.s"

Paint.EndProgramData:                ; this may be useful on future for code dinamically relocatable

