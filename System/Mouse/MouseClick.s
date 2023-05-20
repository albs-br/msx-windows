_MOUSE_CLICK:

    ld      a, (OS.mouseButton_1)
    or      a
    ret     z


    ld      a, (OS.currentTileMouseOver)
    and     1111 0000 b ; get hi nibble
    cp      SCREEN_MAPPING_WINDOWS_TITLE_BAR
    jp      z, .click_WindowTitleBar

    ret

; ---------------------------------------

.click_WindowTitleBar:
    ; get process id
    ld      a, (OS.currentTileMouseOver)
    and     0000 1111 b ; get low nibble
    ld      c, a

    ; loop through process slots looking for this process id
    ld      hl, OS.processes
    ld      de, Process_struct.size
    ld      b, MAX_PROCESS_ID + 1
.loop_1:
    ld      a, (hl)
    cp      c
    jp      z, .processIdFind
    add     hl, de
    djnz    .loop_1

    ret

.processIdFind:
    ; set curr proc to process to this
    ld      (OS.currentProcessAddr), hl
    ret

; ---------------------------------------
