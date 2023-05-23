_MOUSE_CLICK:

    ; TODO: get only transition of click

    ld      a, (OS.mouseButton_1)
    or      a
    ret     z

    ; get screenMapping value under mouse cursor
    ld      a, (OS.currentTileMouseOver)

    ; first check if the click was on desktop/taskbar
    cp      SCREEN_MAPPING_DESKTOP ; 255
    jp      z, .click_Desktop
    cp      SCREEN_MAPPING_TASKBAR ; 254
    jp      z, .click_Taskbar

    ; get process id and put in C
    and     0000 1111 b ; get low nibble
    ld      c, a

    ; ; TODO: do it here, and remove from the subroutines below
    ; call    _GET_PROCESS_BY_ID
    ; jp      z, .processIdFound


    ld      a, (OS.currentTileMouseOver)
    and     1111 0000 b ; get hi nibble

    cp      SCREEN_MAPPING_WINDOWS
    jp      z, .click_Window

    cp      SCREEN_MAPPING_WINDOWS_TITLE_BAR
    jp      z, .click_WindowTitleBar

    cp      SCREEN_MAPPING_WINDOWS_CLOSE_BUTTON
    jp      z, .click_WindowCloseButton

    ret

; ---------------------------------------

.click_Window:

    push    bc
        ; debug
        ld      b, 5
        .test:
            push    bc
                call    BIOS_BEEP
            pop bc
        djnz .test
    pop     bc

    call    _GET_PROCESS_BY_ID
    call    z, _SET_CURRENT_PROCESS
    ret     nz

    ; TODO
    ; call "Click" event of the process

    ret

; ---------------------------------------

.click_WindowTitleBar:
    call    _GET_PROCESS_BY_ID
    call    z, _SET_CURRENT_PROCESS
    ; jp      z, .click_WindowTitleBar_processIdFound

    ret

; .click_WindowTitleBar_processIdFound:
;     call    _SET_CURRENT_PROCESS
;     ret

; ---------------------------------------

.click_WindowCloseButton:
    call    _GET_PROCESS_BY_ID
    ; push    af
    ;     call    z, .processIdFound
    ; pop     af ; restore Z/NZ flags
    ret     nz

    call    _CLOSE_PROCESS

    ret

; --------------------------------------

.click_Desktop:
    ret

; --------------------------------------

.click_Taskbar:
    ret