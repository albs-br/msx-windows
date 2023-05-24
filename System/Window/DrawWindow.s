; Input
;   IX = addr of process header
_DRAW_WINDOW:

    ;call    Wait_Vblank


    
    
    ; get variables from process
    ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    
    call    _CONVERT_COL_LINE_TO_LINEAR
    
    ; ; update OS.screenMapping
    ; push    hl
    ;     call    _UPDATE_SCREEN_MAPPING_WINDOW
    ; pop     hl

    ; set HL to NAMTBL position of window top left
    ld      bc, NAMTBL
    add     hl, bc



    ; --------------- draw window title bar -----------------------
    



    ; first line of title bar
    ;ld  hl, NAMTBL + 10 + (0 * 32) ; DEBUG x=10, y=1
    push    hl
        call    BIOS_SETWRT
        
        ld      a, TILE_WINDOW_TITLE_TOP_LEFT
        out     (PORT_0), a

        ld      a, (ix + PROCESS_STRUCT_IX.width) ; process.width
        sub     2 ; process.width - 2
        ld      b, a
    .loop_1:    
        ld      a, TILE_WINDOW_TITLE_MIDDLE_TOP
        out     (PORT_0), a
        djnz    .loop_1

        nop
        nop
        ld      a, TILE_WINDOW_TOP_RIGHT_CORNER_TOP
        out     (PORT_0), a
    pop     hl
    
    ; second line of title bar
    ld      de, 32
    add     hl, de
   
    push    hl
        call    BIOS_SETWRT
        ld      a, TILE_WINDOW_TITLE_BOTTOM_LEFT
        out     (PORT_0), a
        
        ld      a, (ix + PROCESS_STRUCT_IX.width) ; process.width
        sub     5 ; process.width - 5
        ld      b, a
    .loop_2:
        ld      a, TILE_WINDOW_TITLE_MIDDLE_BOTTOM
        out     (PORT_0), a
        djnz    .loop_2

        nop
        nop
        ld      a, TILE_WINDOW_MINIMIZE_BUTTON
        out     (PORT_0), a

        nop
        nop
        ld      a, TILE_WINDOW_MAXIMIZE_BUTTON
        out     (PORT_0), a

        nop
        nop
        ld      a, TILE_WINDOW_CLOSE_BUTTON
        out     (PORT_0), a

        nop
        nop
        ld      a, TILE_WINDOW_TOP_RIGHT_CORNER_BOTTOM
        out     (PORT_0), a
    pop     hl

    ; draw name of process on window title
    push    hl, ix
        inc     hl
        call    BIOS_SETWRT
        
        ld      b, 16 ; max size of string
    .loop_10:
        ld      a, (ix + PROCESS_STRUCT_IX.windowTitle) ; process.windowTitle
        or      a ; check for 0 meaning end of string
        jp      z, .endLoop_10
        out     (PORT_0), a
        inc     ix
        djnz    .loop_10
    .endLoop_10:
    pop     ix, hl

    ; --------------- draw window middle borders and empty background -----------------------

    ld      a, (ix + PROCESS_STRUCT_IX.height) ; process.height
    sub     4           ; subtract 4 (2 from title and 2 from bottom)
    ld      b, a
.loop_height:
    push    bc

        ld      de, 32
        add     hl, de
    
        push    hl
            call    BIOS_SETWRT
            ld      a, TILE_WINDOW_BORDER_LEFT
            out     (PORT_0), a

            ld      a, (ix + PROCESS_STRUCT_IX.width) ; process.width
            sub     2 ; ; process.width - 2
            ld      b, a
        .loop_3:
            ld      a, TILE_EMPTY
            out     (PORT_0), a
            djnz    .loop_3

            nop
            nop
            ld      a, TILE_WINDOW_BORDER_RIGHT
            out     (PORT_0), a
        pop     hl

    pop     bc
    djnz    .loop_height

    ; --------------- draw window bottom border and empty background -----------------------

    ; first line of window bottom
    ld      de, 32
    add     hl, de
   
    push    hl
        call    BIOS_SETWRT
        ld      a, TILE_WINDOW_BORDER_LEFT
        out     (PORT_0), a
        
        ld      a, (ix + PROCESS_STRUCT_IX.width) ; process.width
        sub     2 ; ; process.width
        ld      b, a
    .loop_4:
        ld      a, TILE_EMPTY
        out     (PORT_0), a
        djnz    .loop_4

        nop
        nop
        ld      a, TILE_WINDOW_RESIZE_CORNER_TOP
        out     (PORT_0), a
    pop     hl

    ; second line of window bottom
    ld      de, 32
    add     hl, de
   
    push    hl
        call    BIOS_SETWRT
        ld      a, TILE_WINDOW_BORDER_BOTTOM_LEFT
        out     (PORT_0), a
        
        ld      a, (ix + PROCESS_STRUCT_IX.width) ; process.width
        sub     3 ; ; process.width - 3
        ld      b, a
    .loop_5:
        ld      a, TILE_WINDOW_BORDER_MIDDLE_BOTTOM
        out     (PORT_0), a
        djnz    .loop_5

        nop
        nop
        ld      a, TILE_WINDOW_RESIZE_CORNER_LEFT
        out     (PORT_0), a

        nop
        nop
        ld      a, TILE_WINDOW_RESIZE_CORNER_RIGHT
        out     (PORT_0), a
    pop     hl

    ; ---------------------------------------------



    ; call "Draw" event of the process
    ; ld      ix, (OS.currentProcessAddr)
    ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    call    JP_DE



    ret



; Input:
;   DE = addr of string (0 terminated)
;   HL = VRAM NAMTBL addr
_DRAW_STRING:
    ; ex      de, hl
        call    BIOS_SETWRT
    ; ex      de, hl
.loop:
    ld      a, (de)
    or      a
    ret     z   ; if (char == 0) ret

    ; TODO:
    ; if (A >= 65 && A <= 91) .textUpperCase
    ; else if (A >= ? && A <= ?) .textLowerCase
    ; else if (A >= ? && A <= ?) .digits
    
    ; if (A == 32) .setTileEmpty
    cp      32
    jp      z, .setTileEmpty

    ; else
    add     -65 + TILE_FONT_UPPERCASE_A ; 65 = ASCII code for 'A'


.continue:
    out     (PORT_0), a

    inc     de

    jp      .loop

.setTileEmpty:
    ld      a, TILE_EMPTY
    jp      .continue

; ---------------------------------

; _RESTORE_TILES_BEHIND_WINDOW:

;     ; restore tiles behind the window
;     ; push    hl

;         ; IX = HL
;         push    hl
;         pop     ix

;         ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
;         ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
        
;         call    _CONVERT_COL_LINE_TO_LINEAR

;         ; set HL to NAMTBL position of window top left
;         ld      bc, NAMTBL
;         add     hl, bc

;         ; DE = IX
;         push    ix
;         pop     de

;         ; DE += PROCESS_STRUCT_IX.screenTilesBehind
;         ex      de, hl
;             ld      bc, PROCESS_STRUCT_IX.screenTilesBehind
;             add     hl, bc
;         ex      de, hl

;         ; outer loop (process.height)
;         ld      c, (ix + PROCESS_STRUCT_IX.height)
;     .outerLoop_2:
        
;             call    BIOS_SETWRT

;             ; inner loop (process.width)
;             ld      b, (ix + PROCESS_STRUCT_IX.width)
;         .innerLoop_2:

;                 ; read tile from RAM pointed by DE
;                 ld      a, (de)
;                 inc     de
            
;                 ; write tile to VRAM pointed by HL
;                 out      (PORT_0), a

;             djnz    .innerLoop_2

;             push    bc
;                 ld      bc, 32
;                 add     hl, bc 
;             pop     bc

;         dec     c
;         jp      nz, .outerLoop_2
;     ; pop     hl

;     ret



; UPDATE_TILES_BEHIND_WINDOW:


;         ; get variables from process
;         ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
;         ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
        
;         call    _CONVERT_COL_LINE_TO_LINEAR
        
;         ; set HL to NAMTBL position of window top left
;         ld      bc, NAMTBL
;         add     hl, bc

;         ; ld      e, (ix + PROCESS_STRUCT_IX.screenTilesBehind)       ; process.screenTilesBehind
;         ; ld      d, (ix + PROCESS_STRUCT_IX.screenTilesBehind + 1)   ; process.screenTilesBehind + 1

;         ; DE = IX
;         push    ix
;         pop     de

;         ; DE += PROCESS_STRUCT_IX.screenTilesBehind
;         ex      de, hl
;             ld      bc, PROCESS_STRUCT_IX.screenTilesBehind
;             add     hl, bc
;         ex      de, hl

;         ; outer loop (process.height)
;         ld      c, (ix + PROCESS_STRUCT_IX.height)
;     .outerLoop_2:
        
;             call    BIOS_SETRD

;             ; inner loop (process.width)
;             ld      b, (ix + PROCESS_STRUCT_IX.width)
;         .innerLoop_2:

;                 ; read tile from VRAM pointed by HL
;                 in      a, (PORT_0)

;                 ; write to RAM pointed by DE
;                 ld      (de), a
;                 inc     de
            
;             djnz    .innerLoop_2

;             push    bc
;                 ld      bc, 32
;                 add     hl, bc 
;             pop     bc

;         dec     c
;         jp      nz, .outerLoop_2

;     ret