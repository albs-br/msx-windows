RamStart:

Seed:                   rw 1

OS:

.mouseY:		        rb 1
.mouseX:		        rb 1
.mousePattern:	        rb 1
.mouseColor:	        rb 1
.mouseY_1:		        rb 1
.mouseX_1:		        rb 1
.mousePattern_1:	    rb 1
.mouseColor_1:	        rb 1

.keyboardMatrix:	    rb 10			; https://map.grauw.nl/articles/keymatrix.php

.ticksSinceLastInput:	rw 1		    ; used to trigger screen saver

.currentTime:	        rb 3			; BCD encoded time hh:mm:ss
.currentDate:	        rb 3			; BCD encoded date dd/mm/yyyy
.timeCounter:	        rb 1			; 0-59 JIFFY based counter to increment time/date (0-49 on PAL machines)



; TODO: this can be moved to the free VRAM area (addr 7040)
.screenMapping: 	    rb 32*24		; used to map each tile to a window/desktop (useful on mouse click/over). 
                                        ; 255: desktop, 254: bottom bar;
                                        ; 4 high bits: window title buttons/resize corner (don't use 1111b as it would crash with the 255/254 values)
                                        ; 4 lower bits (0-15): process id

.currentProcessAddr:            rw 1
.nextAvailableProcessAddr:      rw 1

.processes:		        rb Process_struct.size * 4 ; maybe 6 in the future


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

.screenTilesBehind:	    rb 32*24

.size: equ $ - Process_struct

RamEnd: