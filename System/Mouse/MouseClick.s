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
