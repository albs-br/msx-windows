; Input
;   IX = base addr of this process slot on RAM


    ; ------------- click on tabs

    ; --- get click position in tiles relative to the window top left
    call    CONVERT_MOUSE_POSITION_IN_PIXELS_TO_TILES

    ld      a, l
    sub     (ix + PROCESS_STRUCT_IX.x)
    ld      l, a

    ld      a, h
    sub     (ix + PROCESS_STRUCT_IX.y)
    ld      h, a



    ; if (y > 2) ret
    ld      a, h
    cp      2 + 1
    ret     nc


    ; if (x <= 5) .ClickTab_Video
    ld      a, l
    cp      5 + 1
    jp      nc, .continue_1

    jp      .ClickTab_Video

.continue_1:

    ; if (x <= 11) .ClickTab_Mouse
    ld      a, l
    cp      11 + 1
    jp      nc, .continue_2

    jp      .ClickTab_Mouse

.continue_2:

    ; if (x <= 16) .ClickTab_Time
    ld      a, l
    cp      16 + 1
    jp      nc, .continue_3

    jp      .ClickTab_Time

.continue_3:



    ret


.ClickTab_Video:
    ret

.ClickTab_Mouse:
    ret

.ClickTab_Time:
    ret