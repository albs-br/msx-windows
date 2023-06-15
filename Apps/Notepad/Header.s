Notepad:

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
.taskbarTitle:
                        db TILE_FONT_REVERSED_LOWERCASE_A + 13 ; 'n'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 14 ; 'o'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 19 ; 't'
                        db TILE_FONT_REVERSED_LOWERCASE_A + 4  ; 'e'
.iconTitle:
                        db TILE_FONT_LOWERCASE_A + 13 ; 'n'
                        db TILE_FONT_LOWERCASE_A + 14 ; 'o'
                        db TILE_FONT_LOWERCASE_A + 19 ; 't'
                        db TILE_FONT_LOWERCASE_A + 4  ; 'e'
                        db TILE_FONT_LOWERCASE_A + 15 ; 'p'
                        db TILE_FONT_LOWERCASE_A + 0  ; 'a'
                        db TILE_FONT_LOWERCASE_A + 3  ; 'd'

.isFixedSize:	        db 0
.vertScrollbarEnabled:	db 0
.vertScrollbarPosition:	db 0


.openAddr:		        dw Notepad_Open
.workAddr:		        dw Notepad_Work
.drawAddr:		        dw Notepad_Draw
.clickAddr:		        dw Notepad_Click
.closeAddr:		        dw Notepad_Close

.iconAddr:		        dw Notepad_Icon

.ramSize:		        dw 1024     ; RAM space reserved for variables of this app


; --------------------------------------------------
Notepad.StartProgramCode:

Notepad_Open:
    INCLUDE "Apps/Notepad/Open.s"

Notepad_Work:
    INCLUDE "Apps/Notepad/Work.s"

Notepad_Draw:
    INCLUDE "Apps/Notepad/Draw.s"

Notepad_Click:
    INCLUDE "Apps/Notepad/Click.s"

Notepad_Close:
    INCLUDE "Apps/Notepad/Close.s"

Notepad.EndProgramCode:                ; this may be useful on future for code dinamically relocatable



; --------------------------------------------------
Notepad.StartProgramData:

Notepad_Icon:
    INCLUDE "Apps/Notepad/Icon.s"

Notepad_Data:
    INCLUDE "Apps/Notepad/Data.s"

Notepad.EndProgramData:                ; this may be useful on future for code dinamically relocatable

