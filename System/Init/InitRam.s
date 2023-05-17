_INIT_RAM:

    ; TODO: clear all ram up to the stack
    ; clear RAM
    xor     a
    ld      (RamStart), a
    ld      hl, RamStart
    ld      de, RamStart + 1
    ld      bc, RamEnd - RamStart - 1
    ldir

    ; init process area (fill with 0xff)
    ld      a, 0xff
    ld      (OS.processes), a
    ld      hl, OS.processes
    ld      de, OS.processes + 1
    ld      bc, OS.processes_size - 1
    ldir
    
    ; set next available process slot to the first one
    ld      hl, OS.processes
    ld      (OS.nextAvailableProcessAddr), hl

    ; set current process to null
    ld      hl, 0
    ld      (OS.currentProcessAddr), hl

    ; init mouse cursor variables
    ld      a, 128 - 8
    ld      (OS.mouseY), a
    ld      (OS.mouseY_1), a
    ld      a, 96 - 8
    ld      (OS.mouseX), a
    ld      (OS.mouseX_1), a
    ld      a, SPRITE_INDEX_CURSOR_0
    ld      (OS.mousePattern), a
    ld      a, SPRITE_INDEX_CURSOR_1
    ld      (OS.mousePattern_1), a
    ld      a, 1 ; black
    ld      (OS.mouseColor), a
    ld      a, 15 ; white
    ld      (OS.mouseColor_1), a

;     ; TODO: use LDIR (faster)
;     ; ------- init OS.screenMapping
;     ld      hl, (OS.screenMapping)
;     ld      bc, 32 * 23             ; size of desktop (23 lines)
; .loop_1:
;     ld      a, 255
;     ld      (hl), a
    
;     inc     hl
    
;     dec     bc
;     ld      a, c
;     or      b
;     jp      nz, .loop_1


;     ld      a, 254
;     ld      b, 32                   ; size of taskbar (last line)
; .loop_2:
;     ld      (hl), a
;     inc     hl
;     djnz    .loop_2
;     ; -------

    ret


; constants (refer to Ram.s (OS.screenMapping) for explanation)
SCREEN_MAPPING_DESKTOP:     equ 255
SCREEN_MAPPING_TASKBAR:     equ 254

SCREEN_MAPPING_WINDOWS_TITLE_BAR:           equ 0001 0000 b
SCREEN_MAPPING_WINDOWS_MINIMIZE_BUTTON:     equ 0010 0000 b
SCREEN_MAPPING_WINDOWS_RESTORE_BUTTON:      equ 0011 0000 b
SCREEN_MAPPING_WINDOWS_MAXIMIZE_BUTTON:     equ 0100 0000 b
SCREEN_MAPPING_WINDOWS_RESIZE_CORNER:       equ 0101 0000 b