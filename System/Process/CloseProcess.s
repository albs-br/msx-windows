; Input:
;   HL = addr of process header
_CLOSE_PROCESS:

    ; IX = HL
    push    hl
    pop     ix

    ; call process.Close event
    push    hl
        ld      e, (ix + PROCESS_STRUCT_IX.closeAddr)         ; process.Close addr (low)
        ld      d, (ix + PROCESS_STRUCT_IX.closeAddr + 1)     ; process.Close addr (high)
        call    JP_DE
    pop     hl

    ; decrease layer number of all processes with layer > this.layer
    push    hl
        ld      c, (ix + PROCESS_STRUCT_IX.layer)
        call    _ADJUST_LAYER_OF_PROCESSES
    pop     hl


    push    hl
        call    _CLOSE_WINDOW
    pop     hl




    push    hl
        ;  ------ clear this process slot (fill with 0xff)
        ld      a, 0xff
        ; ld      hl, (OS.currentProcessAddr)
        ld      (hl), a
        
        push    hl ; DE = HL
        pop     de

        inc     de

        ; ld      hl, ?
        ; ld      de, ?
        ld      bc, Process_struct.size - 1

        ldir
        ; -------
    pop     hl



    ; push    hl
        call    _UPDATE_SCREEN_MAPPING
    ; pop     hl

    
    ; set nextAvailableProcessAddr
    call    _GET_NEXT_AVAILABLE_PROCESS_ADDR
    ; inc     a   ; if (A == 255) .maxProcessLimitReached
    ; jp      z, .maxProcessLimitReached ; OBS: it isn't really necessary here, as one process was just closed
    ld      (OS.nextAvailableProcessAddr), hl



    ; set current process to null
    ld      hl, 0x0000
    ld      (OS.currentProcessAddr), hl



    ret
