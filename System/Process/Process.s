; Input:
;   HL = addr of process header 
_LOAD_PROCESS:

    ; copy header from source to next empty process slot
    ;ld      hl, ???                                        ; source
    ld      de, (OS.nextAvailableProcessAddr)               ; destiny
    ld      bc, Process_struct.size                         ; size
    ldir                                                    ; Copy BC bytes from HL to DE

    ; set current process to this
    ld      hl, (OS.nextAvailableProcessAddr)
    ld      (OS.currentProcessAddr), hl

    ; TODO
    ; update next empty process slot to the next


    ld      hl, (OS.currentProcessAddr)
    call    _DRAW_WINDOW

    ret