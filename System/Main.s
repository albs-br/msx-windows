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
    INCLUDE "System/Window/Window.s"
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

    ; routines named in uppercase means they are OS rotines
    ; _ on start means private routines while absence of underline means public routines

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

    ; TODO:
    ; run current processes "Work" event

    jp      .OS_MainLoop



    db      "End ROM started at 0x4000"

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xff



; RAM
	org     0xc000, 0xe5ff

    INCLUDE "System/Ram.s"
