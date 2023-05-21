; ------------------- RAM usage

; OS variables                                     810 bytes
; process slots                 4 * 811 bytes =   3244 bytes
; process variables space       4 * ? bytes =        ? bytes

; start of RAM: 0xc000 (49152)
; end of RAM: 0xF380 (62336)  [ or 0xe5ff (58879) ? ]

; 49152 - 810 - 3244 = 53206

; 62336 - 53206 = 9130 bytes for apps variables
; 58879 - 53206 = 5673 bytes for apps variables

; BIOS variables:
	; BOTTOM:   equ $fc48 ; Address of the beginning of the available RAM area
	; HIMEM:    equ $fc4a ; High free RAM address available (init stack with)

RamStart:

; --------------------------------------------------------------------------------------------

Seed:                   rw 1

OS:

.mouseSpriteAttributes:
.mouseY:		        rb 1
.mouseX:		        rb 1
.mousePattern:	        rb 1
.mouseColor:	        rb 1
.mouseY_1:		        rb 1
.mouseX_1:		        rb 1
.mousePattern_1:	    rb 1
.mouseColor_1:	        rb 1

.mouseButton_1:         rb 1
.mouseButton_2:         rb 1

.keyboardMatrix:	    rb 10			; https://map.grauw.nl/articles/keymatrix.php

.ticksSinceLastInput:	rw 1		    ; used to trigger screen saver



.currentTime:	        			    ; BCD encoded time hh:mm:ss
.currentTime_Hours:     rb 1
.currentTime_Minutes:   rb 1
.currentTime_Seconds:   rb 1

.currentDate:	        rb 3			; BCD encoded date dd/mm/yyyy

.timeCounter:	        rb 1			; 0-59 JIFFY based counter to increment time/date (0-49 on PAL machines)



.storeOldInterruptHook: rb 6
.interruptBusy:         rb 1


; TODO: this can be moved to the free VRAM area (addr 7040)

; used to map each tile to a window/desktop (useful on mouse click/over). 
; 255: desktop, 254: taskbar;
; 4 high bits: 
;   window title buttons/resize corner (don't use 1111b as it would crash with the 255/254 values)
;   0000 on high bits means the inner of process window (neither title nor borders)
; 4 lower bits (0-15): process id
.screenMapping: 	    rb 32*24
.currentTileMouseOver:  rb 1            ; stores value of current mouse position in OS.screenMapping 
                                        ; to avoid being calclated more than once

.currentProcessAddr:            rw 1    ; 0x0000 means empty current process
.nextAvailableProcessAddr:      rw 1

; --------------------------------------------------------------------------------------------

.processes:		        
    ;rb Process_struct.size * (MAX_PROCESS_ID + 1) 
    .process_slot_0:        rb Process_struct.size
    .process_slot_1:        rb Process_struct.size
    .process_slot_2:        rb Process_struct.size
    .process_slot_3:        rb Process_struct.size
.processes_end:
.processes_size: equ $ - .processes

; --------------------------------------------------------------------------------------------

Process_struct:
.processId:		        rb 1		    ; 255: empty
.windowState:	        rb 1		    ; 0: minimized, 1: restored, 2: maximized
.x:			            rb 1
.y:			            rb 1
.width:		            rb 1
.height:		        rb 1
.minWidth:		        rb 1
.minHeight:		        rb 1

.windowTitle:	        rb 16
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
.closeAddr:		        rw 1

.ramSize:		        rw 1     ; RAM space reserved for variables of this app

; these RAM and VRAM addresses are dinamically defined by OS on app startup
.ramStartAddr:	        rw 1
.vramStartTileAddr:	    rw 1

.size_without_screenTilesBehind: equ $ - Process_struct

.screenTilesBehind:	    rb 32*24

.size: equ $ - Process_struct

; ------------------------------------
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
.isFixedSize:	        equ Process_struct.isFixedSize	           - Process_struct
.vertScrollbarEnabled:  equ Process_struct.vertScrollbarEnabled    - Process_struct
.vertScrollbarPosition: equ Process_struct.vertScrollbarPosition   - Process_struct

.openAddr:		        equ Process_struct.openAddr    - Process_struct
.workAddr:		        equ Process_struct.workAddr    - Process_struct
.drawAddr:		        equ Process_struct.drawAddr    - Process_struct
.clickAddr:		        equ Process_struct.clickAddr   - Process_struct
.closeAddr:		        equ Process_struct.closeAddr   - Process_struct

; TODO: other properties

.screenTilesBehind:	    equ Process_struct.screenTilesBehind   - Process_struct

RamEnd: