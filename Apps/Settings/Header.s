Settings:

; fixed values for app initialization
.Header:

.processId:		        db 255		    ; on app header must be always 255 (will be given an id by the OS at app load)
.windowState:	        db WINDOW_STATE.RESTORED
.x:			            db 2
.y:			            db 2
.width:		            db 20
.height:		        db 16
.minWidth:		        db 20
.minHeight:		        db 6

.windowTitle:
                        db TILE_FONT_REVERSED_LOWERCASE_S
                        db TILE_FONT_REVERSED_LOWERCASE_E
                        db TILE_FONT_REVERSED_LOWERCASE_T
                        db TILE_FONT_REVERSED_LOWERCASE_T
                        db TILE_FONT_REVERSED_LOWERCASE_I
                        db TILE_FONT_REVERSED_LOWERCASE_N
                        db TILE_FONT_REVERSED_LOWERCASE_G
                        db TILE_FONT_REVERSED_LOWERCASE_S
                        db 0 ; end of string ; TODO
                        db 0
                        db 0
                        db 0
                        db 0
                        db 0
                        db 0
                        db 0
.taskbarTitle:
                        db TILE_FONT_REVERSED_LOWERCASE_S
                        db TILE_FONT_REVERSED_LOWERCASE_E
                        db TILE_FONT_REVERSED_LOWERCASE_T
                        db TILE_EMPTY_BLACK
.iconTitle:
                        db TILE_FONT_LOWERCASE_S
                        db TILE_FONT_LOWERCASE_E
                        db TILE_FONT_LOWERCASE_T
                        db TILE_FONT_LOWERCASE_T
                        db TILE_FONT_LOWERCASE_I
                        db TILE_FONT_LOWERCASE_N
                        db TILE_FONT_LOWERCASE_G

.isFixedSize:	        db 0
.vertScrollbarEnabled:	db 0
.vertScrollbarPosition:	db 0


.openAddr:		        dw Settings_Open
.workAddr:		        dw Settings_Work
.drawAddr:		        dw Settings_Draw
.clickAddr:		        dw Settings_Click
.getFocusAddr:		    dw Settings_GetFocus
.loseFocusAddr:		    dw Settings_LoseFocus
.closeAddr:		        dw Settings_Close

.iconAddr:		        dw Settings_Icon

.ramSize:		        dw 1024     ; RAM space reserved for variables of this app


; --------------------------------------------------
Settings.StartProgramCode:

Settings_Open:
    INCLUDE "Apps/Settings/Open.s"

Settings_Work:
    INCLUDE "Apps/Settings/Work.s"

Settings_Draw:
    INCLUDE "Apps/Settings/Draw.s"

Settings_Click:
    INCLUDE "Apps/Settings/Click.s"

Settings_GetFocus:
    INCLUDE "Apps/Settings/GetFocus.s"

Settings_LoseFocus:
    INCLUDE "Apps/Settings/LoseFocus.s"

Settings_Close:
    INCLUDE "Apps/Settings/Close.s"

Settings.EndProgramCode:                ; this may be useful on future for code dinamically relocatable



; --------------------------------------------------
Settings.StartProgramData:

Settings_Icon:
    INCLUDE "Apps/Settings/Icon.s"

Settings_Data:
    INCLUDE "Apps/Settings/Data.s"

Settings.EndProgramData:                ; this may be useful on future for code dinamically relocatable

