; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    ; push    iy
        call    GET_USEFUL_WINDOW_BASE_NAMTBL

    ;     ; if (windowState == MAXIMIZED) HL++
    ;     ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    ;     cp      WINDOW_STATE.MAXIMIZED
    ;     jp      nz, .skip_1
    ;     inc     hl
    ; .skip_1:

        ex      de, hl

        ; draw tabs
        ld		hl, Settings_Data.SETTINGS_TABS                        ; RAM address (source)
        ld      b, 18       ; size of line
        ld      c, 11       ; number of lines
        call    DRAW_ON_WINDOW_USEFUL_AREA

    ; pop     iy

    ; ; get RAM variables area of this process
    ; ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ; ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    ; push    hl ; IY = HL
    ; pop     iy


    ld      a, (iy + SETTINGS_VARS.TAB_SELECTED)
    cp      SETTINGS_TABS_VALUES.TAB_VIDEO
    jp      z, .drawCurrentTabVideo
    cp      SETTINGS_TABS_VALUES.TAB_MOUSE
    jp      z, .drawCurrentTabMouse
    cp      SETTINGS_TABS_VALUES.TAB_TIME
    jp      z, .drawCurrentTabTime


    ret

.drawCurrentTabVideo:
    call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ld      de, 32 * 2 ; two lines below
    add     hl, de
    ex      de, hl

    ld		hl, Settings_Data.CURRENT_TAB_VIDEO_TILES                        ; RAM address (source)
    ld      b, 18       ; size of line
    ld      c, 1        ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA

    ret

.drawCurrentTabMouse:
    call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ld      de, 32 * 2 ; two lines below
    add     hl, de
    ex      de, hl

    ld		hl, Settings_Data.CURRENT_TAB_MOUSE_TILES                        ; RAM address (source)
    ld      b, 18       ; size of line
    ld      c, 1        ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA

    ret

.drawCurrentTabTime:
    call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ld      de, 32 * 2 ; two lines below
    add     hl, de
    ex      de, hl

    ld		hl, Settings_Data.CURRENT_TAB_TIME_TILES                        ; RAM address (source)
    ld      b, 18       ; size of line
    ld      c, 1        ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA



    ; Draw time
    call    .DrawClock



    ret



; draw system time on window
.DrawClock:

    call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ld      de, 2 + (32 * 5)
    add     hl, de
    call    BIOS_SETWRT
    ld      c, PORT_0


    ld      b, TILE_FONT_NUMBERS_0

    ; tens of hours digit
    ld      a, (OS.currentTime_Hours)
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    or      a
    jp      z, .skipTensOfHours ; if tens of hours == 0 not print 
    add     b ; convert digit in BCD to tile number
    jp      .continue
.skipTensOfHours:
    ld      a, TILE_EMPTY
.continue:
    out     (c), a

    ; units of hours digit
    ld      a, (OS.currentTime_Hours)
    and     0000 1111 b
    add     b ; convert digit in BCD to tile number
    out     (c), a

    ; write char ':'
    nop
    nop
    ld      a, TILE_COLON ; char ':'
    out     (c), a

    ; tens of minutes digit
    ld      a, (OS.currentTime_Minutes)
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    add     b ; convert digit in BCD to tile number
    out     (c), a
    
    ; units of minutes digit
    ld      a, (OS.currentTime_Minutes)
    and     0000 1111 b
    add     b ; convert digit in BCD to tile number
    out     (c), a

    ; write char ':'
    nop
    nop
    ld      a, TILE_COLON ; char ':'
    out     (c), a

    ; tens of seconds digit
    ld      a, (OS.currentTime_Seconds)
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    add     b ; convert digit in BCD to tile number
    out     (c), a
    
    ; units of seconds digit
    ld      a, (OS.currentTime_Seconds)
    and     0000 1111 b
    add     b ; convert digit in BCD to tile number
    out     (c), a

    ret
