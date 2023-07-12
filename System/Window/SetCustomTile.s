; Set custom tiles (tiles specific for this process)
; Inputs:
;   IX: process address
;   A:  tile number (between 0 and 11, relative to this process)
;   HL: pattern address on RAM
;   DE: color address on RAM
SET_CUSTOM_TILE:

    ld      b, (ix + PROCESS_STRUCT_IX.vramStartTile)
    add     b

    ld      (OS.tempWord), hl
    ld      (OS.tempWord_2), de

    ; --- tile pattern
    ; calc PATTBL addr for custom tile
    ld      h, 0
    ld      l, a

    add     hl, hl ; multiply HL by 8
    add     hl, hl
    add     hl, hl

    ld      c, PORT_0

    ex      de, hl

    ld      b, 3 ; repeat for the 3 parts of the screen
.loop:
    push    bc
        ld		hl, PATTBL
        add     hl, de

        call    BIOS_SETWRT

        ld      hl, (OS.tempWord)
        ld      b, 8
    .innerLoop:
            outi
            jp      nz, .innerLoop ; this uses exactly 29 cycles (t-states)


    ; tile colors
        ld		hl, COLTBL
        add     hl, de

        call    BIOS_SETWRT

        ld      hl, (OS.tempWord_2)
        ld      b, 8
    .innerLoop_1:
            outi
            jp      nz, .innerLoop_1 ; this uses exactly 29 cycles (t-states)

        ; DE += 256 * 8
        ex      de, hl
            ld      de, 256 * 8
            add     hl, de
        ex      de, hl
    pop     bc

    djnz    .loop

    ret