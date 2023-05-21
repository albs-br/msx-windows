; Input:
;   HL = addr of process header
_CLOSE_WINDOW:

    ; restore tiles behind the window
    ; push    hl

        ; IX = HL
        push    hl
        pop     ix

        ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
        ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
        
        call    _CONVERT_COL_LINE_TO_LINEAR

        ; set HL to NAMTBL position of window top left
        ld      bc, NAMTBL
        add     hl, bc

        ; DE = IX
        push    ix
        pop     de

        ; DE += PROCESS_STRUCT_IX.screenTilesBehind
        ex      de, hl
            ld      bc, PROCESS_STRUCT_IX.screenTilesBehind
            add     hl, bc
        ex      de, hl

        ; outer loop (process.height)
        ld      c, (ix + PROCESS_STRUCT_IX.height)
    .outerLoop_2:
        
            call    BIOS_SETWRT

            ; inner loop (process.width)
            ld      b, (ix + PROCESS_STRUCT_IX.width)
        .innerLoop_2:

                ; read tile from RAM pointed by DE
                ld      a, (de)
                inc     de
            
                ; write tile to VRAM pointed by HL
                out      (PORT_0), a

            djnz    .innerLoop_2

            push    bc
                ld      bc, 32
                add     hl, bc 
            pop     bc

        dec     c
        jp      nz, .outerLoop_2
    ; pop     hl



    ; update OS.screenMapping
    ; TODO
    
    

    ret