_INIT_RAM:

    ; TODO: clear all ram up to the stack
    ; clear RAM
    xor     a
    ld      hl, RamStart
    ld      de, RamStart + 1
    ld      bc, RamEnd - RamStart - 1
    ldir

    ; init process area (fill with 0xff)
    ld      a, 0xff
    ld      (OS.processes), a
    ld      hl, OS.processes
    ld      de, OS.processes + 1
    ld      bc, OS.processes_size - 1
    ldir
    
    ; set next available process slot to the first one
    ld      hl, OS.processes
    ld      (OS.nextAvailableProcessAddr), hl

    ; set current process to null
    ld      hl, 0
    ld      (OS.currentProcessAddr), hl

    ; init mouse cursor variables
    ld      a, 128 - 8
    ld      (OS.mouseY), a
    ld      (OS.mouseY_1), a
    ld      a, 96 - 8
    ld      (OS.mouseX), a
    ld      (OS.mouseX_1), a
    ld      a, SPRITE_INDEX_CURSOR_0
    ld      (OS.mousePattern), a
    ld      a, SPRITE_INDEX_CURSOR_1
    ld      (OS.mousePattern_1), a
    ld      a, 1 ; black
    ld      (OS.mouseColor), a
    ld      a, 15 ; white
    ld      (OS.mouseColor_1), a

    ret