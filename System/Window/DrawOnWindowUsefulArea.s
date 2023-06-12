; Input:
;   HL = ROM start source address
;   DE = VRAM NAMTBL start destiny address
;   B = line width (0-31)
;   C = number of lines
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

            ex      de, hl
            
            push    hl, de
            ; push    bc ; TODO: not sure if it is necessary
                call    BIOS_SETWRT
            ; pop     bc
            pop     hl, de

            ;ex      de, hl            
            push    bc
            ld      c, PORT_0
            .innerLoop:
                outi
                jp      nz, .innerLoop ; this uses exactly 29 cycles (t-states)
            pop     bc
        pop     de, hl, bc

        ; TODO
        ; HL += 32

    dec     c
    jp      nz, .outerLoop

    ret