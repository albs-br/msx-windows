; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    ; ; get RAM variables area of this process
    ; ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ; ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    ; push    hl ; IY = HL
    ; pop     iy

    ; cursor = 0
    xor     a
    ld      (iy + NOTEPAD_VARS.CURSOR_POSITION), a

    ; set empty text
    ld      a, TEXT_END_OF_FILE
    ld      (iy + NOTEPAD_VARS.TEXT_START), a

    ; clear keyboard buffer
    call    BIOS_KILBUF

    ; ld      a, TILE_STAR
    ; ld      (hl), a ; debug

    ; ; get base NAMTBL of the window
    ; ; push    hl ; ix = hl
    ; ; pop     ix
    ; ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ; ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    ; call    _CONVERT_COL_LINE_TO_LINEAR
    
    ; ld      bc, NAMTBL + (32 * 2) + 1; two lines below and one column right
    ; add     hl, bc

    ; call    _GET_WINDOW_BASE_NAMTBL

    ; ; one line below
    ; ld      bc, 32 * 1
    ; add     hl, bc

    ; ld      de, TEST_NOTEPAD_OPEN_EVENT_STRING
    ; call    _DRAW_STRING

    ; ; debug
    ; ; write a test char 
    ; call    BIOS_SETWRT
    ; ld      a, TILE_FONT_UPPERCASE_A + 0 ; 'A'
    ; out     (PORT_0), a

    ret
