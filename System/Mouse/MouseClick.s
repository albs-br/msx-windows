_MOUSE_CLICK:

    ld      a, (OS.mouseButton_1)
    or      a
    ret     z

    ; get screenMapping value under mouse cursor
    ld      a, (OS.currentTileMouseOver)

    ; ; TODO:
    ; ; first check if the click was on desktop/taskbar
    ; cp      SCREEN_MAPPING_DESKTOP ; 255
    ; jp      z, .click_Desktop
    ; cp      SCREEN_MAPPING_TASKBAR ; 254
    ; jp      z, .click_Taskbar

    ; get process id and put in C
    and     0000 1111 b ; get low nibble
    ld      c, a

    ; ; TODO: do it here, and remove from the subroutines below
    ; call    _GET_PROCESS_BY_ID
    ; jp      z, .processIdFound


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

    call    _CLOSE_PROCESS

    ret
