; Input
;   IX = base addr of this process slot on RAM
;   IY = base addr of variables area of this process



    ; ------------- click on tabs

    ; --- get click position in tiles relative to the window top left
    call    GET_MOUSE_POSITION_IN_TILES

    ; TODO: fix bug (this is working only on restored window)
    ; adjust mouse position in tiles to be relative to window top left
    ld      a, l
    sub     (ix + PROCESS_STRUCT_IX.x)
    ld      l, a

    ld      a, h
    sub     (ix + PROCESS_STRUCT_IX.y)
    ld      h, a



    ; if (y > 2) ret
    ld      a, h
    cp      2 + 1 + 2 ; +2 because of the title
    jp      nc, .notClickOnTabs ; ret     nc


    ; if (x <= 5) .ClickTab_Video
    ld      a, l
    cp      5 + 1 + 1 ; +1 because of left border
    jp      nc, .continue_1

    jp      .ClickTab_Video

.continue_1:

    ; if (x <= 11) .ClickTab_Mouse
    ld      a, l
    cp      11 + 1 + 1 ; +1 because of left border
    jp      nc, .continue_2

    jp      .ClickTab_Mouse

.continue_2:

    ; if (x <= 16) .ClickTab_Time
    ld      a, l
    cp      16 + 1 + 1 ; +1 because of left border
    jp      nc, .continue_3

    jp      .ClickTab_Time

.continue_3:



    ret

.notClickOnTabs:

    ld      a, (iy + SETTINGS_VARS.TAB_SELECTED)
    cp      SETTINGS_TABS_VALUES.TAB_TIME
    jp      z, .isOnTimeTab

    ret

.isOnTimeTab:

    ; check if click is on checkbox ShowTicks
    ; if (y != 7) ret
    ld      a, h
    cp      7 + 2
    ret     nz

    ; ; if (x < ?) ret
    ; ld      a, l
    ; cp      ?
    ; ret     c

    ; ; if (x >= ?) ret
    ; ld      a, l
    ; cp      ?
    ; ret     nc

    ; if (CHECKBOX_SHOW_TICKS_VALUE == 0) setCheckbox;
    ld      a, (iy + SETTINGS_VARS.CHECKBOX_SHOW_TICKS_VALUE)
    or      a
    jp      z, .setCheckbox

    ; else resetCheckbox;
    xor     a
    ld      (iy + SETTINGS_VARS.CHECKBOX_SHOW_TICKS_VALUE), a

    jp      .return

.setCheckbox:
    ld      a, 1
    ld      (iy + SETTINGS_VARS.CHECKBOX_SHOW_TICKS_VALUE), a
    jp      .return

.ClickTab_Video:
    ld      a, SETTINGS_TABS_VALUES.TAB_VIDEO
    ld      (iy + SETTINGS_VARS.TAB_SELECTED), a
    jp      .return

.ClickTab_Mouse:
    ld      a, SETTINGS_TABS_VALUES.TAB_MOUSE
    ld      (iy + SETTINGS_VARS.TAB_SELECTED), a
    jp      .return

.ClickTab_Time:
    ld      a, SETTINGS_TABS_VALUES.TAB_TIME
    ld      (iy + SETTINGS_VARS.TAB_SELECTED), a
    jp      .return

.return:
    ; call "Draw" event of this process
    ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    call    JP_DE
    ret
