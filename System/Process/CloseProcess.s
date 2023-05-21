; Input:
;   HL = addr of process header
_CLOSE_PROCESS:


    ; TODO
    ; call process.Close event



    call    _CLOSE_WINDOW



    ;  ------ clear this process slot (fill with 0xff)
    ld      a, 0xff
    ld      hl, (OS.currentProcessAddr)
    ld      (hl), a
    
    push    hl ; DE = HL
    pop     de

    inc     de

    ; ld      hl, ?
    ; ld      de, ?
    ld      bc, Process_struct.size - 1

    ldir
    ; -------


    
    ; set nextAvailableProcessAddr
    call    _GET_NEXT_AVAILABLE_PROCESS_ADDR
    inc     a   ; if (A == 255) .maxProcessLimitReached
    jp      z, .maxProcessLimitReached ; OBS: it isn't really necessary here, as one process was just closed
    ld      (OS.nextAvailableProcessAddr), hl



    ; set current process to null
    ld      hl, 0x0000
    ld      (OS.currentProcessAddr), hl



    ret


.maxProcessLimitReached:
    call    BIOS_BEEP ; debug
    jp      .maxProcessLimitReached ; debug
    ret
