; Input:
;   HL = addr of process header
_MAXIMIZE_PROCESS:

    ; IX = HL
    push    hl
    pop     ix

    ; set status = MAXIMIZED
    ld      a, WINDOW_STATE.MAXIMIZED
    ld      (ix + PROCESS_STRUCT_IX.windowState), a

    call    _SET_CURRENT_PROCESS

    ; push    ix

    ;     ; if it is the current process, set current process to null
    ;     ld      hl, (OS.currentProcessAddr)
    ;     push    ix ; DE = IX
    ;     pop     de
    ;     call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    ;     jp      nz, .skip_1

    ;     ld      hl, 0x0000
    ;     ld      (OS.currentProcessAddr), hl
    ; .skip_1:

    ; pop     ix

    ; call    _CLOSE_WINDOW

    call    _UPDATE_SCREEN


    ; ---------- disable mouse over
    ; reset flag mouseOver_Activated
    xor     a
    ld      (OS.mouseOver_Activated), a

    ; reset mouseOver_screenMappingValue
    ld      (OS.mouseOver_screenMappingValue), a

    ; ; get mouse over NAMTBL addr previously saved 
    ; ld      hl, (OS.mouseOver_NAMTBL_addr)
    ; call    BIOS_SETWRT

    ; ld      a, TILE_EMPTY
    ; out     (PORT_0), a

    ; ld      a, SCREEN_MAPPING_DESKTOP ; 255
    ; ld      (OS.currentTileMouseOver), a
    ; -----------


    call    _DRAW_TASKBAR    

    ret