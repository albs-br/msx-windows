; TODO make this work with all possible HL values

; Input:
;   IX = process header addr
;   HL = ROM start source address (CAUTION, use only _GET_WINDOW_BASE_NAMTBL or _GET_WINDOW_BASE_NAMTBL + 1)
;   DE = VRAM NAMTBL start destiny address
;   B = line width (0-31)
;   C = number of lines
DRAW_ON_WINDOW_USEFUL_AREA:

    ld      a, c
    ld      (OS.tempVar_2), a

    ; ld      iyh, 0 ; progressive line counter
    xor     a
    ld      (OS.tempVar_1), a

.outerLoop:

        ld      a, (ix + PROCESS_STRUCT_IX.windowState)
        cp      WINDOW_STATE.RESTORED
        jp      z, .isRestored

        ; check window height for maximized window
        ld      a, 23 - 1 ; one line for title
        jp      .checkHeight

    .isRestored:
        ; check window height for restored window
        ld      a, (ix + PROCESS_STRUCT_IX.height)
        sub     3 ; two line for title, one line for bottom

    .checkHeight:
        ; cp      iyh
        push    hl
            ld      hl, OS.tempVar_1
            cp      (hl)
        pop     hl
        ret     z ; if (A == progressive line counter) ret
        ret     c ; if (A < progressive line counter) ret

        push    bc, hl, de

                    ex      de, hl ; invert DE and HL
                    
                    push    hl, de
                        call    BIOS_SETWRT
                    pop     hl, de ; invert DE and HL again

                    ld      c, PORT_0
                    .innerLoop:
                        ; TODO: check window width (caution: look input HL for more info)
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

        ; inc     iyh ; progressive line counter
        ld      a, (OS.tempVar_1) ; progressive line counter
        inc     a
        ld      (OS.tempVar_1), a

    ; dec     iyl ; dec line counter
    ld      a, (OS.tempVar_2) ; dec line counter
    dec     a
    ld      (OS.tempVar_2), a
    jp      nz, .outerLoop

    ret