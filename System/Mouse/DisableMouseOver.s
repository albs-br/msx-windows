; Input: nothing
; Output: nothing
_DISABLE_MOUSE_OVER:
    ; ---------- disable mouse over
    ; reset flag mouseOver_Activated
    xor     a
    ld      (OS.mouseOver_Activated), a

    ; reset mouseOver_screenMappingValue
    ld      (OS.mouseOver_screenMappingValue), a

    ; get mouse over NAMTBL addr previously saved 
    ld      hl, (OS.mouseOver_NAMTBL_addr)
    call    BIOS_SETWRT

    ld      a, TILE_EMPTY
    out     (PORT_0), a

    ld      a, SCREEN_MAPPING_DESKTOP ; 255
    ld      (OS.currentTileMouseOver), a
    
    ret