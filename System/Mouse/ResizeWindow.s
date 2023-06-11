; Input:
;   IX = process addr
_START_RESIZE_WINDOW:

    ; if (windowState != RESTORED) ret
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.RESTORED
    ret     nz



    ; set vars for window risizing
    ld      a, 1
    ld      (OS.isResizingWindow), a


    ; -----------------------------------------------------------

    ; --- dragOffset_X = mouseX - (window_X + width)
    ;     windowBottomRight_X = (window_X + width)
    ld      a, (ix + PROCESS_STRUCT_IX.x) ; get window X in columns (0-31)
    ; multiply by 8 to convert to pixels (0-255)
    add     a   ; If you use register A you can multiply qfaster by using the ADD A,A instruction, which is 5 T-states per instruction instead of 8
    add     a
    add     a ; convert window X to pixels
    inc     a ; adjust for the empty line on left of the window
    ld      (OS.windowCorner_TopLeft_X), a
    ld      (OS.windowCorner_BottomLeft_X), a
    dec     a ; restore original value
    ld      c, a ; C = width in pixels
    ld      a, (ix + PROCESS_STRUCT_IX.width) ; get window width in columns (0-31)
    ; multiply by 8 to convert to pixels (0-255)
    add     a   ; If you use register A you can multiply faster by using the ADD A,A instruction, which is 5 T-states per instruction instead of 8
    add     a
    add     a ; convert window width to pixels
    add     c ; A = window_X + width
    sub     16 + 4 ; minus sprite width; minus 4 lines of window shadow at right
    ld      (OS.windowCorner_BottomRight_X), a
    ld      b, a

    ld      a, (OS.mouseX)

    sub     b

    ld      (OS.dragOffset_X), a

    ; --- set windowCorner_BottomRight_X for minWidth
    ld      a, (ix + PROCESS_STRUCT_IX.minWidth) ; get window minWidth in columns (0-31)
    ; multiply by 8 to convert to pixels (0-255)
    add     a   ; If you use register A you can multiply faster by using the ADD A,A instruction, which is 5 T-states per instruction instead of 8
    add     a
    add     a ; convert window minWidth to pixels
    add     c ; A = window_X + minWidth
    sub     16 + 4 ; minus sprite width; minus 4 lines of window shadow at right
    ld      (OS.resizeWindowCorner_BottomRight_X_Min), a



    ; -----------------------------------------------------------------

    ; --- dragOffset_Y = mouseY - (window_Y + height)
    ;     windowBottomRight_Y = (window_Y + height)
    ld      a, (ix + PROCESS_STRUCT_IX.y) ; get window Y in columns (0-31)
    ; multiply by 8 to convert to pixels (0-255)
    add     a   ; If you use register A you can multiply faster by using the ADD A,A instruction, which is 5 T-states per instruction instead of 8
    add     a
    add     a ; convert window Y to pixels
    add     6 ; adjust for the 6 empty lines on title bar top
    ld      (OS.windowCorner_TopLeft_Y), a
    ld      (OS.windowCorner_TopRight_Y), a
    sub     6 ; restore original value
    ld      c, a ; C = width in pixels
    ld      a, (ix + PROCESS_STRUCT_IX.height) ; get window height in columns (0-23)
    ; multiply by 8 to convert to pixels (0-191)
    add     a   ; If you use register A you can multiply faster by using the ADD A,A instruction, which is 5 T-states per instruction instead of 8
    add     a
    add     a ; convert window height to pixels
    add     c ; A = window_Y + height
    sub     16 + 4 ; minus sprite height; minus 4 lines of window shadow at bottom
    ld      (OS.windowCorner_BottomRight_Y), a
    ld      b, a

    ld      a, (OS.mouseY)

    sub     b

    ld      (OS.dragOffset_Y), a


    ; --- set windowCorner_BottomRight_Y for minHeight
    ld      a, (ix + PROCESS_STRUCT_IX.minHeight) ; get window minHeight in columns (0-31)
    ; multiply by 8 to convert to pixels (0-255)
    add     a   ; If you use register A you can multiply faster by using the ADD A,A instruction, which is 5 T-states per instruction instead of 8
    add     a
    add     a ; convert window minWidth to pixels
    add     c ; A = window_Y + minHeight
    sub     16 + 4 ; minus sprite height; minus 4 lines of window shadow at bottom
    ld      (OS.resizeWindowCorner_BottomRight_Y_Min), a


    ; -------------------------------------------------------

    call    _ADJUST_WINDOW_RESIZE_CORNERS


    ret



; Adjust the top right and bottom left corners based on the position of the bottom right corner
_ADJUST_WINDOW_RESIZE_CORNERS:

    ld      a, (OS.windowCorner_BottomRight_X)
    ld      (OS.windowCorner_TopRight_X), a

    ld      a, (OS.windowCorner_BottomRight_Y)
    ld      (OS.windowCorner_BottomLeft_Y), a


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

; ; look up table for smooth blinking effect using a color ramp
; DRAG_WINDOW_SPRITE_COLOR_LUT: 
;     db 15, 14, 14, 7, 5, 5, 4, 1, 1, 4, 4, 5, 7, 7, 14, 15


_DO_RESIZE_WINDOW:

    ; windowCorner_BottomRight_X = mouseX - dragOffset_X
    ld      a, (OS.dragOffset_X)
    ld      b, a
    ld      a, (OS.mouseX)
    sub     b
    jp      c, .lessThanMinWidth ; if (dragOffset_X > mouseX)
    ld      (OS.windowCorner_BottomRight_X), a

    ; --- check for minimum width
    ; if (windowCorner_BottomRight_X < resizeWindowCorner_BottomRight_X_Min)
    ;       windowCorner_BottomRight_X = resizeWindowCorner_BottomRight_X_Min;
    ld      b, a ; B = windowCorner_BottomRight_X
    ld      a, (OS.resizeWindowCorner_BottomRight_X_Min)
    cp      b
    jp      nc, .lessThanMinWidth ; if (A >= n)
    jp      .cont_1
.lessThanMinWidth:
    ld      a, (OS.resizeWindowCorner_BottomRight_X_Min)
    ld      (OS.windowCorner_BottomRight_X), a
    jp      .cont_2 ; if is min width, no need to test for max width
.cont_1:


    ; --- check for maximum width
    ; if (windowCorner_BottomRight_X > (255 - 16 - 4))
    ;       windowCorner_BottomRight_X = 255 - 16 - 4;
    ld      b, 256 - 16 - 4 ; subtract sprite width and 4 lines of window shade
    ld      a, (OS.windowCorner_BottomRight_X)
    cp      b
    jp      nc, .greaterThanMaxWidth ; if (A >= n)
    jp      .cont_2
.greaterThanMaxWidth:
    ld      a, 256 - 16 - 4 ; subtract sprite width and 4 lines of window shade
    ld      (OS.windowCorner_BottomRight_X), a
.cont_2:

    ; --------------------------------------------------------

    ; windowCorner_BottomRight_Y = mouseY - dragOffset_Y
    ld      a, (OS.dragOffset_Y)
    ld      b, a
    ld      a, (OS.mouseY)
    sub     b
    jp      c, .lessThanMinHeight ; if (dragOffset_Y > mouseY)
    ld      (OS.windowCorner_BottomRight_Y), a

    ; --- check for minimum height
    ; if (windowCorner_BottomRight_Y < resizeWindowCorner_BottomRight_Y_Min)
    ;       windowCorner_BottomRight_Y = resizeWindowCorner_BottomRight_Y_Min;
    ld      b, a ; B = windowCorner_BottomRight_Y
    ld      a, (OS.resizeWindowCorner_BottomRight_Y_Min)
    cp      b
    jp      nc, .lessThanMinHeight ; if (A >= n)
    jp      .cont_10
.lessThanMinHeight:
    ld      a, (OS.resizeWindowCorner_BottomRight_Y_Min)
    ld      (OS.windowCorner_BottomRight_Y), a
    jp      .cont_20 ; if is min height, no need to test for max height
.cont_10:


    ; --- check for maximum height
    ; if (windowCorner_BottomRight_Y > (191 - 16 - 16 - 4))
    ;       windowCorner_BottomRight_Y = 191 - 16 - 16 - 4;
    ld      b, 192 - 16 - 16 - 4 ; subtract taskbar, sprite height and 4 lines of window shade
    ld      a, (OS.windowCorner_BottomRight_Y)
    cp      b
    jp      nc, .greaterThanMaxHeight ; if (A >= n)
    jp      .cont_20
.greaterThanMaxHeight:
    ld      a, 192 - 16 - 16 - 4 ; subtract taskbar, sprite height and 4 lines of window shade
    ld      (OS.windowCorner_BottomRight_Y), a
.cont_20:

    ; ---------------------------

    call    _ADJUST_WINDOW_RESIZE_CORNERS

    ret


_END_RESIZE_WINDOW:
    
    ; reset window resizing vars
    xor     a
    ld      (OS.isResizingWindow), a

    ld      ix, (OS.currentProcessAddr)

    ; window.width = (windowCorner_BottomRight_X/8) - window.x
    ld      a, (OS.windowCorner_BottomRight_X)
    dec     a ; ajust for empty line at left border
    add     16 + 4 ; adjust for sprite width / window shadow
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0

    ld      b, (ix + PROCESS_STRUCT_IX.x)

    sub     b

    inc     a ; not sure why...
    ld      (ix + PROCESS_STRUCT_IX.width), a



    ; window.height = (windowCorner_BottomRight_Y/8) - window.y
    ld      a, (OS.windowCorner_BottomRight_Y)
    add     16 + 4 ; adjust for sprite height / window shadow
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0

    ld      b, (ix + PROCESS_STRUCT_IX.y)

    sub     b

    ld      (ix + PROCESS_STRUCT_IX.height), a



    call    _UPDATE_SCREEN

    ret
