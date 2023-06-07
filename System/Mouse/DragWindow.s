; Input:
;   IX = process addr
_START_DRAG_WINDOW:

    ; if (windowState == MAXIMIZED) ret
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.MAXIMIZED
    ret     z




    ; set vars for window dragging
    ld      a, 1
    ld      (OS.isDraggingWindow), a


    ; --- dragOffset_X = mouseX - window_X
    ld      a, (ix + PROCESS_STRUCT_IX.x) ; get window X in columns (0-31)
    ; multiply by 8 to convert to pixels (0-255)
    ; sla     a ; shift left R; bit 7 -> C ; bit 0 -> 0
    ; sla     a
    ; sla     a   ; convert window X to pixels
    add     a   ; If you use register A you can multiply faster by using the ADD A,A instruction, which is 5 T-states per instruction instead of 8
    add     a
    add     a
    inc     a ; adjust for the empty line on left of the window
    ld      (OS.windowCorner_TopLeft_X), a
    ld      b, a

    ld      a, (OS.mouseX)

    sub     b

    ld      (OS.dragOffset_X), a 



    ; --- dragOffset_Y = window_Y - mouseY
    ld      a, (ix + PROCESS_STRUCT_IX.y) ; get window Y in columns (0-31)
    ; multiply by 8 to convert to pixels (0-255)
    ; sla     a ; shift left R; bit 7 -> C ; bit 0 -> 0
    ; sla     a
    ; sla     a   ; convert window X to pixels
    add     a   ; If you use register A you can multiply faster by using the ADD A,A instruction, which is 5 T-states per instruction instead of 8
    add     a
    add     a
    add     6 ; adjust for the 6 empty lines on title bar top
    ld      (OS.windowCorner_TopLeft_Y), a
    ld      b, a

    ld      a, (OS.mouseY)

    sub     b

    ld      (OS.dragOffset_Y), a

    call    _ADJUST_WINDOW_DRAG_CORNERS



    ; set other window corners sprites vars
    ld      a, SPRITE_INDEX_WINDOW_TOP_LEFT
    ld      (OS.windowCorner_TopLeft_Pattern), a
    ld      a, SPRITE_INDEX_WINDOW_BOTTOM_LEFT
    ld      (OS.windowCorner_BottomLeft_Pattern), a
    ld      a, SPRITE_INDEX_WINDOW_TOP_RIGHT
    ld      (OS.windowCorner_TopRight_Pattern), a
    ld      a, SPRITE_INDEX_WINDOW_BOTTOM_RIGHT
    ld      (OS.windowCorner_BottomRight_Pattern), a


    ld      a, 15 ; white
    ld      (OS.windowCorner_TopLeft_Color), a
    ld      (OS.windowCorner_BottomLeft_Color), a
    ld      (OS.windowCorner_TopRight_Color), a
    ld      (OS.windowCorner_BottomRight_Color), a


    ret



; Adjust the other three corners based on the position of the top left corner
_ADJUST_WINDOW_DRAG_CORNERS:
    ; 
    ld      a, (ix + PROCESS_STRUCT_IX.width)
    add     a ; mult by 8 to convert to pixels
    add     a
    add     a
    ld      b, a
    ld      a, (OS.windowCorner_TopLeft_X)
    ld      (OS.windowCorner_BottomLeft_X), a
    add     b
    sub     16 + 5 ; sprite width / decrement window shadow
    ld      (OS.windowCorner_TopRight_X), a
    ld      (OS.windowCorner_BottomRight_X), a
    
    ; ------------------
    ld      a, (ix + PROCESS_STRUCT_IX.height)
    add     a ; mult by 8 to convert to pixels
    add     a
    add     a
    ld      b, a
    ld      a, (OS.windowCorner_TopLeft_Y)
    ld      (OS.windowCorner_TopRight_Y), a
    add     b
    sub     16 + 10; sprite height / decrement window shadow
    ld      (OS.windowCorner_BottomLeft_Y), a
    ld      (OS.windowCorner_BottomRight_Y), a

    ; get color based on JIFFY
    ld      a, (BIOS_JIFFY)
    and     0011 1100 b
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      hl, DRAG_WINDOW_SPRITE_COLOR_LUT
    ld      b, 0
    ld      c, a
    add     hl, bc
    ld      a, (hl)
    ld      (OS.windowCorner_TopLeft_Color), a
    ld      (OS.windowCorner_BottomLeft_Color), a
    ld      (OS.windowCorner_TopRight_Color), a
    ld      (OS.windowCorner_BottomRight_Color), a

    ret

; look up table for smooth blinking effect using a color ramp
DRAG_WINDOW_SPRITE_COLOR_LUT: 
    db 15, 14, 14, 7, 5, 5, 4, 1, 1, 4, 4, 5, 7, 7, 14, 15



_DO_DRAG_WINDOW:
    ; windowCorner_TopLeft_X = mouseX - dragOffset_X

    ; do operation in 16 bits
    ld      a, (OS.mouseX)
    ld      l, a
    ld      h, 0x80 ; put current A value in the middle of the 16 bits range 
                    ; (the same as doing the operation with signed numbers)
    ld      a, (OS.dragOffset_X)
    ld      e, a
    ld      d, 0
    xor     a ; clear carry flag
    sbc     hl, de

    push    hl
        ; if (windowCorner_TopLeft_X < 1) windowCorner_TopLeft_X = 1
        ld      de, 0x8000 + 1
        call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
        jp      nc, .skip_20
        ld      a, 1
        jp      .cont_10
    .skip_20:
        ld      a, l
    .cont_10:
        ld      (OS.windowCorner_TopLeft_X), a
    pop     hl
    
    ; if ( ( windowCorner_TopLeft_X + (process.width * 8) ) > 255) windowCorner_TopLeft_X = 255 - (process.width * 8)
    ld      a, (ix + PROCESS_STRUCT_IX.width)
    add     a ; mult by 8 to convert to pixels
    add     a
    add     a
    ld      c, a
    ld      b, 0
    add     hl, bc

    ; HL now contains windowCorner_TopLeft_X + (process.width * 8)
    ld      de, 0x8000 + (255 + 2)
    call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jp      nc, .skip_3 ; HL >= DE
    jp      .skip_4 ; HL < DE
.skip_3:
    ; windowCorner_TopLeft_X = 255 - (process.width * 8)
    ld      a, 1 ; 255 + 2 = 1, in 8 bits
    sub     c
    ld      (OS.windowCorner_TopLeft_X), a
.skip_4:
    ; ---------------------------

    ; windowCorner_TopLeft_Y = mouseY - dragOffset_Y
    ld      a, (OS.dragOffset_Y)
    ld      b, a
    ld      a, (OS.mouseY)
    sub     b

    ; if(windowCorner_TopLeft_Y > 191) windowCorner_TopLeft_Y = 6
    cp      191
    jp      nc, .skip_1
    ; if(windowCorner_TopLeft_Y < 6) windowCorner_TopLeft_Y = 6
    cp      6
    jp      nc, .skip_2
.skip_1:
    ld      a, 6
.skip_2:
    ld      (OS.windowCorner_TopLeft_Y), a

    ; A now has OS.windowCorner_TopLeft_Y
    ; if ( ( windowCorner_TopLeft_Y + (process.height * 8) ) > (191 - 16)) windowCorner_TopLeft_Y = (191 - 16) - (process.height * 8)
    ld      b, a
    ld      a, (ix + PROCESS_STRUCT_IX.height)
    add     a ; mult by 8 to convert to pixels
    add     a
    add     a
    ld      c, a
    add     b

    cp      191 - 9
    jp      c, .skip_5

    ; windowCorner_TopLeft_Y = (191 - 16) - (process.height * 8)
    ld      a, 191 - 9
    sub     c
    ld      (OS.windowCorner_TopLeft_Y), a
.skip_5:
    
    ; ---------------------------

    call    _ADJUST_WINDOW_DRAG_CORNERS

    ret



_END_DRAG_WINDOW:
    
    ; reset window dragging vars
    xor     a
    ld      (OS.isDraggingWindow), a

    ld      ix, (OS.currentProcessAddr)

    ld      a, (OS.windowCorner_TopLeft_X)
    dec     a ; adjust for the empty line on left of the window
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      (ix + PROCESS_STRUCT_IX.x), a

    ld      a, (OS.windowCorner_TopLeft_Y)
    sub     6 ; adjust for the 6 empty lines on title bar top
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      (ix + PROCESS_STRUCT_IX.y), a

    call    _UPDATE_SCREEN

    ret
