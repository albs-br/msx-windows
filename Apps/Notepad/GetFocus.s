; Input
;   IX = base addr of this process slot on RAM

    ; clear keyboard buffer
    call    BIOS_KILBUF
    
    ret