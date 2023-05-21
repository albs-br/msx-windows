_MOUSE_CLICK:

    ld      a, (OS.mouseButton_1)
    or      a
    ret     z

    ; get process id and put in C
    ld      a, (OS.currentTileMouseOver)
    and     0000 1111 b ; get low nibble
    ld      c, a



    ld      a, (OS.currentTileMouseOver)
    and     1111 0000 b ; get hi nibble

    cp      SCREEN_MAPPING_WINDOWS_TITLE_BAR
    jp      z, .click_WindowTitleBar

    cp      SCREEN_MAPPING_WINDOWS_CLOSE_BUTTON
    jp      z, .click_WindowCloseButton

    ret

; ---------------------------------------

.click_WindowTitleBar:
    call    _GET_PROCESS_BY_ID
    jp      z, .processIdFound

    ret

; ---------------------------------------

.processIdFound:
    call    _SET_CURRENT_PROCESS
    ret

; ---------------------------------------

.click_WindowCloseButton:
    call    _GET_PROCESS_BY_ID
    call    z, .processIdFound
    ret     nz

    ; TODO: put in process.s

    ; restore tiles behind the window
    ; push    hl

        ; IX = HL
        push    hl
        pop     ix

        ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
        ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
        
        call    _CONVERT_COL_LINE_TO_LINEAR

        ; set HL to NAMTBL position of window top left
        ld      bc, NAMTBL
        add     hl, bc

        ; DE = IX
        push    ix
        pop     de

        ; DE += PROCESS_STRUCT_IX.screenTilesBehind
        ex      de, hl
            ld      bc, PROCESS_STRUCT_IX.screenTilesBehind
            add     hl, bc
        ex      de, hl

        ; outer loop (process.height)
        ld      c, (ix + PROCESS_STRUCT_IX.height)
    .outerLoop_2:
        
            call    BIOS_SETWRT

            ; inner loop (process.width)
            ld      b, (ix + PROCESS_STRUCT_IX.width)
        .innerLoop_2:

                ; read tile from RAM pointed by DE
                ld      a, (de)
                inc     de
            
                ; ld a, 0 ; debug

                ; write tile to VRAM pointed by HL
                out      (PORT_0), a

            djnz    .innerLoop_2

            push    bc
                ld      bc, 32
                add     hl, bc 
            pop     bc

        dec     c
        jp      nz, .outerLoop_2
    ; pop     hl



    ; ------ clear this process slot (fill with 0xff)
    ld      a, 0xff
    ld      hl, (OS.currentProcessAddr)
    ld      (hl), a
    
    push    hl ; DE = HL
    pop     de

    inc     de

    ; ld      hl, ?
    ; ld      de, ?
    ld      bc, Process_struct.size - 1

    ldir
    ; -------


    ; set nextAvailableProcessAddr
    call    _GET_NEXT_AVAILABLE_PROCESS_ADDR
    inc     a   ; if (A == 255) .maxProcessLimitReached
    jp      z, .maxProcessLimitReached
    ld      (OS.nextAvailableProcessAddr), hl



    ; set current process to null
    ld      hl, 0x0000
    ld      (OS.currentProcessAddr), hl




    ret

.maxProcessLimitReached:
    call    BIOS_BEEP ; debug
    jp      .maxProcessLimitReached ; debug
    ret
