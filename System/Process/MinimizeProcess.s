; Input:
;   HL = addr of process header
_MINIMIZE_PROCESS:

    ; IX = HL
    push    hl
    pop     ix

    ; if (windowState == MINIMIZED) ret
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.MINIMIZED
    ret     z

    ; save window state
    ld      (ix + PROCESS_STRUCT_IX.previousWindowState), a

    ; set status = minimized
    ld      a, WINDOW_STATE.MINIMIZED
    ld      (ix + PROCESS_STRUCT_IX.windowState), a

    push    ix

        ; if it is the current process, set current process to null
        ld      hl, (OS.currentProcessAddr)
        push    ix ; DE = IX
        pop     de
        call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
        jp      nz, .skip_1

        ld      hl, 0x0000
        ld      (OS.currentProcessAddr), hl
    .skip_1:

    pop     ix

    call    _CLOSE_WINDOW

    call    _UPDATE_SCREEN

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


    call    _DRAW_TASKBAR    


    ret