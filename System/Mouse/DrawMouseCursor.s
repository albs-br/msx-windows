_DRAW_MOUSE_CURSOR:

    ; ; TODO: fix Y+1 bug of TMS 9918
    ; ld      hl, SPRATR
    ; call    BIOS_SETWRT
    ; ld      c, PORT_0
    ; ld      hl, OS.mouseSpriteAttributes

    ; dec     (hl)
    ; outi        ; .mouseY:		        

    ; nop
    ; nop
    ; nop
    ; outi        ; .mouseX:		        

    ; nop
    ; nop
    ; nop
    ; outi        ; .mousePattern:	        

    ; nop
    ; nop
    ; nop
    ; outi        ; .mouseColor:	        

    ; dec     (hl)
    ; outi        ; .mouseY_1:		        

    ; nop
    ; nop
    ; nop
    ; outi        ; .mouseX_1:		        

    ; nop
    ; nop
    ; nop
    ; outi        ; .mousePattern_1:	    

    ; nop
    ; nop
    ; nop
    ; outi        ; .mouseColor_1:	        



    ; update mouse cursor sprites
    ld      hl, SPRATR
    call    BIOS_SETWRT
    ld      hl, OS.mouseSpriteAttributes
    ld      c, PORT_0
    ld      b, 8
.loop_1:
    outi
    jp      nz, .loop_1 ; this uses exactly 29 cycles (t-states)

    nop
    nop
    ld      a, 208
    out     (c), a    ; hide all other sprites



    ; check mouse position on screen (OS.screenMapping)
    ld      a, (OS.mouseX) ; mouse x in pixels (0-255)
    ; divide by 8 to convert to columns (0-31)
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      l, a

    ld      a, (OS.mouseY) ; mouse y in pixels (0-191)
    ; divide by 8 to convert to lines (0-23)
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      h, a

    call    _CONVERT_COL_LINE_TO_LINEAR

    ld      bc, OS.screenMapping
    add     hl, bc

    ld      a, (hl)

    ld      (OS.currentTileMouseOver), a

    ; ; debug
    ; cp      SCREEN_MAPPING_TASKBAR
    ; jp      z, .mouseOverTaskbar




    ret

; .mouseOverTaskbar:
;     call    BIOS_BEEP
;     ret
