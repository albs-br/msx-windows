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

    ; init mouse/cursor variables
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

    xor     a
    ld      (OS.mouseButton_1), a
    ld      (OS.mouseButton_2), a
    ld      (OS.oldMouseButton_1), a
    ld      (OS.oldMouseButton_2), a
    ld      (OS.isDoubleClick), a
    
    ld      (OS.isDraggingWindow), a
    ld      (OS.dragOffset_X), a
    ld      (OS.dragOffset_Y), a
    ld      (OS.isResizingWindow), a
    ld      (OS.resizeWindowCorner_BottomRight_X_Min), a
    ld      (OS.resizeWindowCorner_BottomRight_Y_Min), a

    ld      hl, 0
    ld      (OS.mouseLastClick_Jiffy), hl

    ; set window corners sprites vars
    ld      a, SPRITE_INDEX_WINDOW_TOP_LEFT
    ld      (OS.windowCorner_TopLeft_Pattern), a
    ld      a, SPRITE_INDEX_WINDOW_BOTTOM_LEFT
    ld      (OS.windowCorner_BottomLeft_Pattern), a
    ld      a, SPRITE_INDEX_WINDOW_TOP_RIGHT
    ld      (OS.windowCorner_TopRight_Pattern), a
    ld      a, SPRITE_INDEX_WINDOW_BOTTOM_RIGHT
    ld      (OS.windowCorner_BottomRight_Pattern), a

    ld      a, 15 ; white
    ld      (OS.windowCorner_TopLeft_Color), a
    ld      (OS.windowCorner_BottomLeft_Color), a
    ld      (OS.windowCorner_TopRight_Color), a
    ld      (OS.windowCorner_BottomRight_Color), a

    ; init keyboard vars
    ld      a, 1111 1111 b
    ld      (OS.oldKeyboardMatrix + 0), a
    ld      (OS.oldKeyboardMatrix + 1), a
    ld      (OS.oldKeyboardMatrix + 2), a
    ld      (OS.oldKeyboardMatrix + 3), a
    ld      (OS.oldKeyboardMatrix + 4), a
    ld      (OS.oldKeyboardMatrix + 5), a
    ld      (OS.oldKeyboardMatrix + 6), a
    ld      (OS.oldKeyboardMatrix + 7), a
    ld      (OS.oldKeyboardMatrix + 8), a
    ld      (OS.oldKeyboardMatrix + 9), a


    ; init video vars
    ld      a, 0
    ld      (OS.nextWindow_x), a
    ld      a, 0
    ld      (OS.nextWindow_y), a

    xor     a
    ld      (OS.mouseOver_Activated), a
    ld      (OS.mouseOver_screenMappingValue), a
    ld      (OS.mouseOver_tileToBeRestored), a
    ld      hl, 0
    ld      (OS.mouseOver_NAMTBL_addr), a



    call    _INIT_SCREEN_MAPPING



    ret


