Tetra:

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
                        db TILE_FONT_REVERSED_LOWERCASE_E
                        db TILE_FONT_REVERSED_LOWERCASE_T
                        db TILE_FONT_REVERSED_LOWERCASE_R
                        db TILE_FONT_REVERSED_LOWERCASE_A
                        db 0 ; end of string ; TODO
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
                        db TILE_FONT_REVERSED_LOWERCASE_T
                        db TILE_FONT_REVERSED_LOWERCASE_E
                        db TILE_FONT_REVERSED_LOWERCASE_T
                        db TILE_EMPTY_BLACK
.iconTitle:
                        db TILE_EMPTY
                        db TILE_FONT_LOWERCASE_T
                        db TILE_FONT_LOWERCASE_E
                        db TILE_FONT_LOWERCASE_T
                        db TILE_FONT_LOWERCASE_R
                        db TILE_FONT_LOWERCASE_A
                        db TILE_EMPTY

.isFixedSize:	        db 0
.vertScrollbarEnabled:	db 0
.vertScrollbarPosition:	db 0


.openAddr:		        dw Tetra_Open
.workAddr:		        dw Tetra_Work
.drawAddr:		        dw Tetra_Draw
.clickAddr:		        dw Tetra_Click
.getFocusAddr:		    dw Tetra_GetFocus
.loseFocusAddr:		    dw Tetra_LoseFocus
.closeAddr:		        dw Tetra_Close

.iconAddr:		        dw Tetra_Icon

.ramSize:		        dw 1024     ; RAM space reserved for variables of this app


; --------------------------------------------------
Tetra.StartProgramCode:

Tetra_Open:
    INCLUDE "Apps/Tetra/Open.s"

Tetra_Work:
    INCLUDE "Apps/Tetra/Work.s"

Tetra_Draw:
    INCLUDE "Apps/Tetra/Draw.s"

Tetra_Click:
    INCLUDE "Apps/Tetra/Click.s"

Tetra_GetFocus:
    INCLUDE "Apps/Tetra/GetFocus.s"

Tetra_LoseFocus:
    INCLUDE "Apps/Tetra/LoseFocus.s"

Tetra_Close:
    INCLUDE "Apps/Tetra/Close.s"

Tetra.EndProgramCode:                ; this may be useful on future for code dinamically relocatable



; --------------------------------------------------
Tetra.StartProgramData:

Tetra_Icon:
    INCLUDE "Apps/Tetra/Icon.s"

Tetra_Data:
    INCLUDE "Apps/Tetra/Data.s"

Tetra.EndProgramData:                ; this may be useful on future for code dinamically relocatable

