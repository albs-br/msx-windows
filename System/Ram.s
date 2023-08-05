; ------------------- RAM usage

; OS variables                  1641 bytes
; process slots                 4 * 61 bytes = 244 bytes
; process variables space       4 * ? bytes =        ? bytes

; start of RAM: 0xc000 (49152)
; end of RAM: 0xF380 (62336)  [ or 0xe5ff (58879) ? ]

; 49152 - 810 - 176 = 48166

; 62336 - 48166 = 14170 bytes for app variables
; 58879 - 48166 = 10713 bytes for app variables

; BIOS variables:
	; BOTTOM:   equ $fc48 ; Address of the beginning of the available RAM area
	; HIMEM:    equ $fc4a ; High free RAM address available (init stack with)

RamStart:

; --------------------------------------------------------------------------------------------

Seed:                   rw 1

OS:

; --- input
.mouseSpriteAttributes:
.mouseY:		        rb 1
.mouseX:		        rb 1
.mousePattern:	        rb 1
.mouseColor:	        rb 1
.mouseY_1:		        rb 1
.mouseX_1:		        rb 1
.mousePattern_1:	    rb 1
.mouseColor_1:	        rb 1
.windowCorner_TopLeft_Y:       rb 1
.windowCorner_TopLeft_X:       rb 1
.windowCorner_TopLeft_Pattern: rb 1
.windowCorner_TopLeft_Color:   rb 1
.windowCorner_TopRight_Y:       rb 1
.windowCorner_TopRight_X:       rb 1
.windowCorner_TopRight_Pattern: rb 1
.windowCorner_TopRight_Color:   rb 1
.windowCorner_BottomLeft_Y:       rb 1
.windowCorner_BottomLeft_X:       rb 1
.windowCorner_BottomLeft_Pattern: rb 1
.windowCorner_BottomLeft_Color:   rb 1
.windowCorner_BottomRight_Y:       rb 1
.windowCorner_BottomRight_X:       rb 1
.windowCorner_BottomRight_Pattern: rb 1
.windowCorner_BottomRight_Color:   rb 1

.mouseButton_1:         rb 1
.mouseButton_2:         rb 1

.oldMouseButton_1:      rb 1
.oldMouseButton_2:      rb 1

.mouseLastClick_Jiffy:  rw 1
.isDoubleClick:         rb 1


.isDraggingWindow:      rb 1
.dragOffset_X:          rb 1    ; these two "dragOffset" vars are used both on windows drag and resize
.dragOffset_Y:          rb 1
.isResizingWindow:      rb 1
.resizeWindowCorner_BottomRight_X_Min:      rb 1
.resizeWindowCorner_BottomRight_Y_Min:      rb 1

.oldKeyboardMatrix:	    rb 11			; https://map.grauw.nl/articles/keymatrix.php

.ticksSinceLastInput:	rw 1		    ; used to trigger screen saver


; --- time
.currentTime:	        			    ; BCD encoded time hh:mm:ss
.currentTime_Hours:     rb 1
.currentTime_Minutes:   rb 1
.currentTime_Seconds:   rb 1

.currentDate:	        			    ; BCD encoded date dd/mm/yyyy
.currentDate_Day:       rb 1
.currentDate_Month:     rb 1
.currentDate_Year:      rb 2

.timeCounter:	        rb 1			; 0-59 JIFFY based counter to increment time/date (0-49 on PAL machines)



; --- interrupt
.storeOldInterruptHook: rb 6
.interruptBusy:         rb 1


; --- video

; TODO: this can be moved to the free VRAM area (addr 7040)

; used to map each tile to a window/desktop (useful on mouse click/over). 
; 255: desktop, 254: taskbar;
; 4 high bits: 
;   window title buttons/resize corner (don't use 1111b as it would crash with the 255/254 values)
;   0000 on high bits means the inner of process window (neither title nor borders)
; 4 lower bits (0-15): process id
.screenMapping: 	    rb 32*24
.currentTileMouseOver:  rb 1            ; stores value of current mouse position in OS.screenMapping 
                                        ; to avoid being calculated more than once
.nextWindow_x:         rb 1
.nextWindow_y:         rb 1

.mouseOver_Activated:  rb 1
.mouseOver_screenMappingValue:  rb 1
.mouseOver_tileToBeRestored:    rb 1
.mouseOver_NAMTBL_addr:         rw 1

.taskbar_Button_0_Process_addr: rw 1
.taskbar_Button_1_Process_addr: rw 1
.taskbar_Button_2_Process_addr: rw 1
.taskbar_Button_3_Process_addr: rw 1

.desktop_Tiles:                 rb 32 * 22

; --- temp vars / debug
.tempVar_1:  rb 1
.tempVar_2:  rb 1
.tempWord:   rw 1
.tempWord_1: rw 1
.tempWord_2: rw 1
.tempWord_3: rw 1

.tempIcon:   rb NUMBER_OF_TILES_PER_ICON * 8

; --- processes
.currentProcessAddr:            rw 1    ; 0x0000 means empty current process
.nextAvailableProcessAddr:      rw 1

; --------------------------------------------------------------------------------------------

.processes:		        
    rb Process_struct.size * (MAX_PROCESS_ID + 1) 
    .process_slot_0:      equ .processes + (Process_struct.size * 0)
    .process_slot_1:      equ .processes + (Process_struct.size * 1)
    .process_slot_2:      equ .processes + (Process_struct.size * 2)
    .process_slot_3:      equ .processes + (Process_struct.size * 3)
.processes_end:
.processes_size: equ $ - .processes


; ------------------------------------


.PROCESS_VARS_AREA_SIZE: equ 1024

.processesVariablesArea:		        
    rb .PROCESS_VARS_AREA_SIZE * (MAX_PROCESS_ID + 1) 
    .processesVariablesArea_0:      equ .processesVariablesArea + (.PROCESS_VARS_AREA_SIZE * 0)
    .processesVariablesArea_1:      equ .processesVariablesArea + (.PROCESS_VARS_AREA_SIZE * 1)
    .processesVariablesArea_2:      equ .processesVariablesArea + (.PROCESS_VARS_AREA_SIZE * 2)
    .processesVariablesArea_3:      equ .processesVariablesArea + (.PROCESS_VARS_AREA_SIZE * 3)
.processesVariablesArea_end:
.processesVariablesArea_size: equ $ - .processesVariablesArea

; --------------------------------------------------------------------------------------------

; TODO: this is wasting space (put inside process slot 0)
Process_struct:
.processId:		        rb 1		    ; 255: empty
.windowState:	        rb 1		    ; check WINDOW_STATE constant values
.x:			            rb 1
.y:			            rb 1
.width:		            rb 1
.height:		        rb 1
.minWidth:		        rb 1
.minHeight:		        rb 1

.windowTitle:	        rb 16
.taskbarTitle:	        rb 4
.iconTitle:	            rb 7
.isFixedSize:	        rb 1            ; 0: no, 1: yes
.vertScrollbarEnabled:	rb 1            ; 0: no, 1: yes
.vertScrollbarPosition:	rb 1
;TODO:
; .horizScrollbarEnabled:	rb 1            ; 0: no, 1: yes
; .horizScrollbarPosition:	rb 1

; ---- or
; .vertScrollbar:	        rb 1            ; 255: disabled, other values meaning position
; .horizScrollbar:	        rb 1            ; 255: disabled, other values meaning position


; these addresses are fixed and come from App header
.openAddr:		        rw 1
.workAddr:		        rw 1
.drawAddr:		        rw 1
.clickAddr:		        rw 1
.getFocusAddr:	        rw 1
.loseFocusAddr:	        rw 1
.closeAddr:		        rw 1

.iconAddr:		        rw 1     ; Icon: 9x 8x8 pixels (see _INIT_DESKTOP for more info on positioning rules)

.ramSize:		        rw 1     ; RAM space reserved for variables of this app (currently not used, vars space is fixed for now)
; estimated RAM for some apps:
; - calc: 2 * 6 bytes (fixed precision 5.1) = 12 bytes
; - spreadsheet: 1 cell = 4 bytes (fixed precision 3.1) + 1 byte for properties
;		512 cells = 2,5 kb
; - minesweeper: 30x20 playfield = 600 bytes
; - tic tac toe = 9 bytes
; - tetris = 10 x 20 playfield = 200 bytes

.size_Header: equ $ - Process_struct

; these RAM and VRAM addresses are dinamically defined by OS on app startup
.ramStartAddr:	        rw 1
.vramStartTile:	        rb 1

.layer:					rb 1		; layer means the order in which the windows should be drawn
										; desktop is drawn first, then window with layer = 0, then layer = 1, and so on

.previousWindowState:   rb 1            ; window state before being minimized

.size: equ $ - Process_struct


; --------------------------------------------------------------------------------------------
; constants for using Process_struct with (ix + n) addressing

PROCESS_STRUCT_IX:
.processId:		        equ Process_struct.processId    - Process_struct
.windowState:	        equ Process_struct.windowState  - Process_struct
.x:			            equ Process_struct.x            - Process_struct
.y:			            equ Process_struct.y            - Process_struct
.width:		            equ Process_struct.width        - Process_struct
.height:		        equ Process_struct.height       - Process_struct
.minWidth:		        equ Process_struct.minWidth     - Process_struct
.minHeight:		        equ Process_struct.minHeight    - Process_struct

.windowTitle:	        equ Process_struct.windowTitle 	           - Process_struct
.taskbarTitle:	        equ Process_struct.taskbarTitle	           - Process_struct
.iconTitle:	            equ Process_struct.iconTitle 	           - Process_struct
.isFixedSize:	        equ Process_struct.isFixedSize	           - Process_struct
.vertScrollbarEnabled:  equ Process_struct.vertScrollbarEnabled    - Process_struct
.vertScrollbarPosition: equ Process_struct.vertScrollbarPosition   - Process_struct

.openAddr:		        equ Process_struct.openAddr         - Process_struct
.workAddr:		        equ Process_struct.workAddr         - Process_struct
.drawAddr:		        equ Process_struct.drawAddr         - Process_struct
.clickAddr:		        equ Process_struct.clickAddr        - Process_struct
.getFocusAddr:	        equ Process_struct.getFocusAddr     - Process_struct
.loseFocusAddr:	        equ Process_struct.loseFocusAddr    - Process_struct
.closeAddr:		        equ Process_struct.closeAddr        - Process_struct

.iconAddr:		        equ Process_struct.iconAddr   - Process_struct

; TODO: other properties
.ramStartAddr:	        equ Process_struct.ramStartAddr   - Process_struct
.vramStartTile:	        equ Process_struct.vramStartTile  - Process_struct

.layer:					equ Process_struct.layer    	- Process_struct

.previousWindowState:	equ Process_struct.previousWindowState  - Process_struct

; ----------------------------------------------------





RamEnd: