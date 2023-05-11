_INIT_RAM:

    ; clear RAM
    ; xor     a
    ; ld      hl, RamStart
    ; ld      de, RamStart + 1
    ; ld      bc, ?
    ; ldir

    ; init process area (fill with 0xff)
    ld      a, 0xff
    ld      (OS.processes), a
    ld      hl, OS.processes
    ld      de, OS.processes + 1
    ld      bc, OS.processes_size - 1
    ldir
    

    ret