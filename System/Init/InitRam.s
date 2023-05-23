_INIT_RAM:

    ; TODO: clear all ram up to the stack
    ; clear RAM
    xor     a
    ld      (RamStart), a
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

    ; set current process to 0x0000 (null)
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

    ; init keyboard vars
    ld      a, 1111 1111 b
    ld      (OS.keyboardMatrix + 0), a
    ld      (OS.keyboardMatrix + 1), a
    ld      (OS.keyboardMatrix + 2), a
    ld      (OS.keyboardMatrix + 3), a
    ld      (OS.keyboardMatrix + 4), a
    ld      (OS.keyboardMatrix + 5), a
    ld      (OS.keyboardMatrix + 6), a
    ld      (OS.keyboardMatrix + 7), a
    ld      (OS.keyboardMatrix + 8), a
    ld      (OS.keyboardMatrix + 9), a


    ; init video vars
    ld      a, 8
    ld      (OS.nextWindow_x), a
    ld      a, 6
    ld      (OS.nextWindow_y), a



    call    _INIT_SCREEN_MAPPING



    ret


