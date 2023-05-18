FNAME "msx-windows.rom"      ; output file

PageSize:	    equ	0x4000	        ; 16kB

; Compilation address
    org 0x4000

    INCLUDE "Include/RomHeader.s"
    INCLUDE "Include/MsxBios.s"
    INCLUDE "Include/MsxConstants.s"
    INCLUDE "Include/CommonRoutines.s"

; System
    INCLUDE "System/Constants.s"
    INCLUDE "System/Interrupt.s"
    INCLUDE "System/Init/Init.s"
    INCLUDE "System/Desktop/Desktop.s"
    INCLUDE "System/Window/Window.s"
    INCLUDE "System/Keyboard/Keyboard.s"
    INCLUDE "System/Mouse/Mouse.s"
    INCLUDE "System/Process/Process.s"
    INCLUDE "System/Time/Time.s"

; Assets
    ; INCLUDE "Fonts/Atari_Regular.s"
    INCLUDE "Graphics/Tiles.s"
    INCLUDE "Graphics/Sprites.s"


; Apps
    INCLUDE "Apps/Notepad/Header.s"
    ;INCLUDE "Apps/Calc/Header.s"



Execute:

    ; routines named in uppercase means they are OS rotines (unless started by "BIOS_")
    ; _ on start means private routines (internal to the OS) while absence of underline means public routines (can be called by apps)

    call    _INIT

    ; DEBUG
    ld      hl, Notepad.Header
    call    _LOAD_PROCESS

    ; ; DEBUG
    ; ; ld      hl, (OS.currentProcessAddr)
    ; ld      l, 10       ; col number (0-31)
    ; ld      h, 0       ; line number (0-23)
    ; call    _DRAW_WINDOW

    ; ld      l, 5       ; col number (0-31)
    ; ld      h, 6       ; line number (0-23)
    ; call    _DRAW_WINDOW

    ; ld      l, 0       ; col number (0-31)
    ; ld      h, 12       ; line number (0-23)
    ; call    _DRAW_WINDOW

.OS_MainLoop:

    call    _DRAW_MOUSE_CURSOR

    ; run current process "Work" event
    ld      hl, (OS.currentProcessAddr)
    ld      a, l
    or      h
    jp      z, .noCurrentProcess     ; if (OS.currentProcessAddr == 0x0000) .noCurrentProcess
    ld      e, (ix + PROCESS_STRUCT_IX.workAddr)         ; process.Work addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.workAddr + 1)     ; process.Work addr (high)
    call    JP_DE
 .noCurrentProcess:

    jp      .OS_MainLoop



    db      "End ROM started at 0x4000"

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xff



; RAM
	org     0xc000, 0xe5ff

    INCLUDE "System/Ram.s"
