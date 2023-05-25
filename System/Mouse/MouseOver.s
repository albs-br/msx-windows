_MOUSE_OVER:

    ; get screenMapping value under mouse cursor
    ld      a, (OS.currentTileMouseOver)

    ; first check if the cursor is on desktop/taskbar
    cp      SCREEN_MAPPING_DESKTOP ; 255
    ret     z
    cp      SCREEN_MAPPING_TASKBAR ; 254
    ret     z


    ; get process id and put it in C
    and     0000 1111 b ; get low nibble
    ld      c, a

    ld      a, (OS.currentTileMouseOver)
    and     1111 0000 b ; get hi nibble


    ; --------------

    cp      SCREEN_MAPPING_WINDOWS_CLOSE_BUTTON
    jp      z, .over_WindowCloseButton

    ; restore button if mouse is no longer over it
    ; if (mouseOverCloseButton) .notOver_WindowCloseButton
    ld      a, (OS.mouseOverCloseButton)
    or      a
    jp      nz, .notOver_WindowCloseButton

    ret

.over_WindowCloseButton:

    ; ; DEBUG
    ; call    BIOS_BEEP
    ; RET

    ; if (mouseOverCloseButton) ret
    ld      a, (OS.mouseOverCloseButton)
    or      a
    ret     nz

    ; set flag mouseOverCloseButton to true
    ld      a, 1
    ld      (OS.mouseOverCloseButton), a

    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    ret     nz

    push    hl

        ; ; TODO:
        ; ; if (mouseY <= 63) .updateScreenTop
        ; ; else if (mouseY <= 127) .updateScreenMiddle
        ; ; else .updateScreenBottom
        ; ld      a, (OS.mouseY)
        ; cp      64
        ; jp      c, .updateScreenTop
        ; cp      128
        ; jp      c, .updateScreenMiddle
        ; jp      .updateScreenBottom

        ; update pattern and color of tile TILE_MOUSE_OVER
        ld		hl, TILE_WINDOW_CLOSE_BUTTON_PATTERN                    ; RAM address (source)
        ld		de, PATTBL + (TILE_MOUSE_OVER * 8)                      ; VRAM address (destiny)
        ld		bc, 8	                                                ; Block length
        call 	BIOS_LDIRVM        	                                    ; Block transfer to VRAM from memory

        ld      a, 0xe1 ;                                               ; value
        ;ld      a, 0x61 ;                                               ; value
        ld      bc, 8                                                   ; size
        ld      hl, COLTBL + (TILE_MOUSE_OVER * 8)                      ; start VRAM address
        call    BIOS_FILVRM
    pop     hl

    ; ---- get close button position of this window on NAMTBL
        
    ; set IX to process addr
    push    hl
    pop     ix
    call    _GET_WINDOW_TITLE_BASE_NAMTBL
    ; add width - n
    ld      c, (ix + PROCESS_STRUCT_IX.width)   ; process.width
    ld      b, 0
    add     hl, bc
    ld      bc, 32 - 2                          ; one line below, two columns to the left
    add     hl, bc
        

    ; update NAMTBL
    call    BIOS_SETWRT
    ld      a, TILE_MOUSE_OVER
    out     (PORT_0), a

    ; -----

    ret

.notOver_WindowCloseButton:


;jp $ ; debug

    ; reset flag mouseOverCloseButton
    xor     a
    ld      (OS.mouseOverCloseButton), a

    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    ret     nz

    ; ---- get close button position of this window on NAMTBL

    ; set IX to process addr
    push    hl
    pop     ix
    call    _GET_WINDOW_TITLE_BASE_NAMTBL
    ; add width - n
    ld      c, (ix + PROCESS_STRUCT_IX.width)   ; process.width
    ld      b, 0
    add     hl, bc
    ld      bc, 32 - 2                          ; one line below, two columns to the left
    add     hl, bc
        

    ; update NAMTBL
    call    BIOS_SETWRT
    ld      a, TILE_WINDOW_CLOSE_BUTTON
    out     (PORT_0), a

    ret


_MOUSE_XY_TO_NAMTBL:
; convert mouse position in pixels (x, y) to tiles (col, line)
    ld      a, (OS.mouseY)
    ; dec     a       ; because of the Y + 1 TMS9918 bug

    ; divide by 8
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      h, a


    ld      a, (OS.mouseX)

    ; divide by 8
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      l, a


    call    _CONVERT_COL_LINE_TO_LINEAR

    ld      bc, NAMTBL
    add     hl, bc

    ret