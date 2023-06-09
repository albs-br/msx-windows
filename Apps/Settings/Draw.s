; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process

    call    GET_USEFUL_WINDOW_BASE_NAMTBL

    ex      de, hl

    ; draw tabs
    ld		hl, Settings_Data.SETTINGS_TABS                        ; RAM address (source)
    ld      b, 18       ; size of line
    ld      c, 11       ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA



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

    ; --- draw label screen saver
    call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ld      de, 1 + (32 * 4) ; 4 lines below, one tile to the right
    add     hl, de
    ex      de, hl

    ld		hl, Settings_Data.LABEL_COMBO_SCREEN_SAVER                        ; RAM address (source)
    ld      b, 12       ; size of line
    ld      c, 1        ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA


    ; --- draw combo screen saver
    call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ld      de, 1 + (32 * 5) ; 5 lines below, one tile to the right
    add     hl, de
    ex      de, hl

    ld		hl, Settings_Data.COMBO_SCREEN_SAVER                        ; RAM address (source)
    ld      b, 12       ; size of line
    ld      c, 3        ; number of lines
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


    ; --- draw checkbox
    call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ld      de, 2 + (32 * 7) ; 7 lines below, 2 tileS to the right
    add     hl, de
    ex      de, hl

    push    de
        ld		hl, Settings_Data.CHECKBOX_SHOW_TICKS                        ; RAM address (source)
        ld      b, 12       ; size of line
        ld      c, 1        ; number of lines
        call    DRAW_ON_WINDOW_USEFUL_AREA


        ; if (CHECKBOX_SHOW_TICKS_VALUE != 0)
        ld      a, (iy + SETTINGS_VARS.CHECKBOX_SHOW_TICKS_VALUE)
        or      a
    pop     hl
    ret     z

    call    BIOS_SETWRT
    ld      a, TILE_CHECKBOX_CHECKED
    out     (PORT_0), a
    


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


    ; if (checkboxShowTicks == false) ret
    ld      a, (iy + SETTINGS_VARS.CHECKBOX_SHOW_TICKS_VALUE)
    or      a
    ret     z

    ; ---- write system time ticks counter (in hex)

    ; write char '.'
    ld      a, TILE_DOT ; char '.'
    out     (c), a

    
    ld      a, (OS.timeCounter)
    ld      d, a ; save A reg
    and     1111 0000 b
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      b, TILE_FONT_NUMBERS_0 + 0
    add     b
    out     (PORT_0), a

    ld      a, d ; restore a
    and     0000 1111 b
    ld      b, TILE_FONT_NUMBERS_0 + 0
    add     b
    out     (PORT_0), a





    ret
