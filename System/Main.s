FNAME "msx-windows.rom"      ; output file

PageSize:	    equ	0x4000	        ; 16kB

; Compilation address
    org 0x4000

    INCLUDE "Include/RomHeader.s"
    INCLUDE "Include/MsxBios.s"
    INCLUDE "Include/MsxConstants.s"
    INCLUDE "Include/CommonRoutines.s"

; System
System_Code_Start:
    INCLUDE "System/Constants.s"
    INCLUDE "System/Interrupt.s"
    INCLUDE "System/Init/Init.s"
    INCLUDE "System/Desktop/Desktop.s"
    INCLUDE "System/Window/Window.s"
    INCLUDE "System/Keyboard/Keyboard.s"
    INCLUDE "System/Mouse/Mouse.s"
    INCLUDE "System/Process/Process.s"
    INCLUDE "System/Time/Time.s"
System_Code_Size: equ $ - System_Code_Start ; currently 5047 bytes


; Assets
Assets_Start:
    ; INCLUDE "Fonts/Atari_Regular.s"
    INCLUDE "Graphics/Tiles.s"
    INCLUDE "Graphics/Sprites.s"
Assets_Size: equ $ - Assets_Start ; currently 1656 bytes


; Apps
Apps_Start:
    INCLUDE "Apps/Notepad/Header.s"
    INCLUDE "Apps/Calc/Header.s"
    INCLUDE "Apps/Paint/Header.s"
    INCLUDE "Apps/Settings/Header.s"
    INCLUDE "Apps/TicTacToe/Header.s"
    INCLUDE "Apps/Tetra/Header.s"
Apps_Size: equ $ - Apps_Start ; currently 4080 bytes



Execute:
    ; init interrupt mode and stack pointer (in case the ROM isn't the first thing to be loaded)
    di                          ; disable interrupts
	im      1                   ; interrupt mode 1
    ld      sp, (BIOS_HIMEM)    ; init SP
    ei

    ; routines named in uppercase means they are OS routines (unless started by "BIOS_")
    ; _ on start means private routines (internal to the OS) while absence of underline means public routines (can be called by apps)

    call    _INIT

.OS_MainLoop:


    ; --- mouse events
    call    _DRAW_MOUSE_CURSOR
    call    _MOUSE_CLICK
    call    _MOUSE_OVER

    
    call    _READ_KEYBOARD


    ; ---------- work to be done once per second
    ld      a, (OS.timeCounter)
    or      a
    jp      nz, .skip
    
    call    _DRAW_TASKBAR_CLOCK

  .skip:
    ; -----------------------------------------

    ; run current process "Work" event
    ld      ix, (OS.currentProcessAddr)
    ld      a, ixl
    or      ixh
    jp      z, .noCurrentProcess     ; if (OS.currentProcessAddr == 0x0000) .noCurrentProcess

    ; get RAM variables area of this process
    ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    push    hl ; IY = HL
    pop     iy

    ld      e, (ix + PROCESS_STRUCT_IX.workAddr)         ; process.Work addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.workAddr + 1)     ; process.Work addr (high)
    call    JP_DE
 .noCurrentProcess:

    jp      .OS_MainLoop


    ; current ROM size: 11648 bytes (some things may be compressed, mainly tiles (2kb))
    db      "End ROM started at 0x4000"

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xff



; RAM
	org     0xc000, 0xe5ff

    INCLUDE "System/Ram.s"
