; Input:
;   HL = ROM start source address
;   DE = VRAM NAMTBL start destiny address
;   B = line width (0-31)
;   IYL = number of lines
DRAW_ON_WINDOW_USEFUL_AREA:

    ; ; debug
    ; ld  c, PORT_0
    ; ex de, hl
    ; call    BIOS_SETWRT
    ; ex de, hl
    ; outi
    ; ret


.outerLoop:
        push    bc, hl, de

                    ex      de, hl ; invert DE and HL
                    
                    push    hl, de
                        call    BIOS_SETWRT
                    pop     hl, de ; invert DE and HL again

                    ld      c, PORT_0
                    .innerLoop:
                        outi
                        jp      nz, .innerLoop ; this uses exactly 29 cycles (t-states)

                pop     de

                ; DE += 32
                ex      de, hl
                    ld      bc, 32
                    add     hl, bc
                ex      de, hl

            pop     hl
        pop     bc

        ; HL += B (line width)
        ld      c, b
        ld      b, 0
        add     hl, bc
        ld      b, c

    dec     iyl ; dec line counter
    jp      nz, .outerLoop

    ret