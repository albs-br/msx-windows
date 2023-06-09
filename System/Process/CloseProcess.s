; Input:
;   HL = addr of process header
_CLOSE_PROCESS:

    ; IX = HL
    push    hl
    pop     ix

    ; call process "Close" event
    push    hl

        ; get RAM variables area of this process
        ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
        ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

        push    hl ; IY = HL
        pop     iy


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




    ; --- clear variables area of this process slot
    push    hl
        xor     a
        ld      (iy + 0), a
        
        push    iy ; HL = IY
        pop     hl
        
        push    hl
            inc     hl ; DE = HL + 1
            push    hl
            pop     de
        pop     hl
        
        ld      bc, OS.PROCESS_VARS_AREA_SIZE - 1
        ldir
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



    call    _DISABLE_MOUSE_OVER
    ; ; ---------- disable mouse over
    ; ; reset flag mouseOver_Activated
    ; xor     a
    ; ld      (OS.mouseOver_Activated), a

    ; ; reset mouseOver_screenMappingValue
    ; ld      (OS.mouseOver_screenMappingValue), a

    ; ; get mouse over NAMTBL addr previously saved 
    ; ld      hl, (OS.mouseOver_NAMTBL_addr)
    ; call    BIOS_SETWRT

    ; ld      a, TILE_EMPTY
    ; out     (PORT_0), a

    ; ld      a, SCREEN_MAPPING_DESKTOP ; 255
    ; ld      (OS.currentTileMouseOver), a
    ; ; -----------



    call    _UPDATE_SCREEN


    call    _DRAW_TASKBAR

    ; set nextAvailableProcessAddr
    call    _GET_NEXT_AVAILABLE_PROCESS_ADDR
    ld      (OS.nextAvailableProcessAddr), hl



    ; set current process to null
    ld      hl, 0x0000
    ld      (OS.currentProcessAddr), hl



    ret
