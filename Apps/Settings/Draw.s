; Input
;   IX = base addr of this process slot on RAM

    call    GET_USEFUL_WINDOW_BASE_NAMTBL

;     ; if (windowState == MAXIMIZED) HL++
;     ld      a, (ix + PROCESS_STRUCT_IX.windowState)
;     cp      WINDOW_STATE.MAXIMIZED
;     jp      nz, .skip_1
;     inc     hl
; .skip_1:

    ex      de, hl

    ; draw calc display and keypad
    ld		hl, Settings_Data.SETTINGS_TABS                        ; RAM address (source)
    ld      b, 18    ; size of line
    ld      iyl, 3  ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA



    ; get RAM variables area of this process
    ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    push    hl ; IY = HL
    pop     iy


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
    ld      b, 18    ; size of line
    ld      iyl, 1  ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA

    ret

.drawCurrentTabMouse:
    call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ld      de, 32 * 2 ; two lines below
    add     hl, de
    ex      de, hl

    ld		hl, Settings_Data.CURRENT_TAB_MOUSE_TILES                        ; RAM address (source)
    ld      b, 18    ; size of line
    ld      iyl, 1  ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA

    ret

.drawCurrentTabTime:
    call    GET_USEFUL_WINDOW_BASE_NAMTBL
    ld      de, 32 * 2 ; two lines below
    add     hl, de
    ex      de, hl

    ld		hl, Settings_Data.CURRENT_TAB_TIME_TILES                        ; RAM address (source)
    ld      b, 18    ; size of line
    ld      iyl, 1  ; number of lines
    call    DRAW_ON_WINDOW_USEFUL_AREA

    ret