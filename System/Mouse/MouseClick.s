_MOUSE_CLICK:

    ; ; if (!OS.isDraggingWindow && !OS.isResizingWindow) skip window corner sprites
    ; ld      a, (OS.isDraggingWindow)
    ; ld      b, a
    ; ld      a, (OS.isResizingWindow)
    ; or      b
    ; jp      z, .skip_1

    ; if (OS.isDraggingWindow) ...
    ld      a, (OS.isDraggingWindow)
    or      a
    jp      z, .skip_100
        ; if (mouseButton_1 == false) _END_DRAG_WINDOW else _DO_DRAG_WINDOW
        ld      a, (OS.mouseButton_1) ; check if button is pressed
        or      a
        jp      z, _END_DRAG_WINDOW
        jp      _DO_DRAG_WINDOW
        jp      .skip_1

.skip_100:
    ; if (OS.isResizingWindow) ...
    ld      a, (OS.isResizingWindow)
    or      a
    jp      z, .skip_1
        ; if (mouseButton_1 == false) _END_DRAG_WINDOW else _DO_DRAG_WINDOW
        ld      a, (OS.mouseButton_1) ; check if button is pressed
        or      a
        jp      z, _END_RESIZE_WINDOW
        jp      _DO_RESIZE_WINDOW
        ; jp      .skip_1

.skip_1:

    ; ----- get only positive transition of click

    ld      a, (OS.mouseButton_1) ; check if button is pressed
    ld      b, a
    or      a
    jp      z, .return


    ld      a, (OS.oldMouseButton_1) ; check if button was previously released
    or      a
    jp      nz, .return


    ; update old mouse button state
    ld      a, b
    ld      (OS.oldMouseButton_1), a


    ; ----- mouse click code starts here

    ; check for double click
    ld      de, (OS.mouseLastClick_Jiffy)
    ld      hl, (BIOS_JIFFY)
    ld      (OS.mouseLastClick_Jiffy), hl ; update MouseLastClick_Jiffy
    xor     a ; clear carry flag
    sbc     hl, de ; HL receives the difference of current JIFFY and last click JIFFY
    ; if (HL < n) isDoubleClick else isNotDoubleClick
    ld      de, MOUSE_DOUBLE_CLICK_INTERVAL
    call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jp      nc, .isNotDoubleClick
    ; isDoubleClick
    ld      a, 1
    jp      .continue_1
.isNotDoubleClick:
    xor     a ; reset isDoubleClick
.continue_1:
    ld      (OS.isDoubleClick), a



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

    cp      SCREEN_MAPPING_WINDOWS_MAXIMIZE_RESTORE_BUTTON
    jp      z, .click_WindowMaximizeButton

    cp      SCREEN_MAPPING_WINDOWS_MINIMIZE_BUTTON
    jp      z, .click_WindowMinimizeButton

    cp      SCREEN_MAPPING_WINDOWS_RESIZE_CORNER
    jp      z, .click_WindowResizeCorner

    ret

.return:
    ; update old mouse button state
    ld      a, b
    ld      (OS.oldMouseButton_1), a
    ret

; ---------------------------------------

.click_Window:


    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    ret     nz

    push    hl ; IX = HL
        call    z, _SET_CURRENT_PROCESS
    pop     ix

    ; get RAM variables area of this process
    ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    push    hl ; IY = HL
    pop     iy

    ; ---------------- calc x, y in tiles/pixels of click relative to window top left useful area and pass to process
    call    GET_MOUSE_POSITION_IN_TILES

    ; adjust mouse position in tiles to be relative to window top left of useful area

    ld      a, (ix + PROCESS_STRUCT_IX.windowState)         ; process.Click addr (low)
    cp      WINDOW_STATE.RESTORED
    ; if window is maximized, no need to adjust
    jp      nz, .cont_1


    ld      a, l
    sub     (ix + PROCESS_STRUCT_IX.x)
    dec     a ; window left border
    ld      l, a

    ld      a, h
    sub     (ix + PROCESS_STRUCT_IX.y)
    ld      h, a
    dec     h ; window title (restored is 2 lines tall, maximized is 1 line tall)
.cont_1:

    dec     h ; window title

    ; call "Click" event of the process
    ld      e, (ix + PROCESS_STRUCT_IX.clickAddr)         ; process.Click addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.clickAddr + 1)     ; process.Click addr (high)
    call    JP_DE

    ret

; ---------------------------------------

.click_WindowTitleBar:


    ; ---- if double click, maximize/restore app
    ld      a, (OS.isDoubleClick)
    or      a
    jp      nz, .click_WindowMaximizeButton


    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    push    hl
        call    z, _SET_CURRENT_PROCESS
    pop     ix

    ; TODO: fix it
    ; ; ignore click on the first 6 lines of title
    ; ; if (mouseY < ((windowY*8) + 6)) ret
    ; ld      a, (ix + PROCESS_STRUCT_IX.y)
    ; ; ld  (TempWord), ix;debug
    ; ; ld  (Temp), a;debug
    ; add     a ; mult by 8 to convert to pixels
    ; add     a
    ; add     a
    ; add     6
    ; ld      b, a
    ; ; ld  (Temp), a;debug
    ; ld      a, (OS.mouseY)
    ; cp      b
    ; ret     c

    call    _START_DRAG_WINDOW

    ret


; ---------------------------------------

.click_WindowCloseButton:

    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID

    ret     nz

    call    _CLOSE_PROCESS

    ret

; --------------------------------------

.click_WindowMinimizeButton:

    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    ret     nz

    call    _MINIMIZE_PROCESS

    ret

; --------------------------------------

; click on the button Maximize/Restore
.click_WindowMaximizeButton:

    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    ret     nz

    push    hl ; IX = HL
    pop     ix

    ; if (process.windowState == RESTORED)
    ;   _MAXIMIZE_PROCESS
    ; else if (process.windowState == MAXIMIZED)
    ;   _RESTORE_PROCESS
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.RESTORED
    jp      z, .isRestored

    call    _RESTORE_PROCESS
    ret

.isRestored:
    call    _MAXIMIZE_PROCESS
    ret

; --------------------------------------

.click_WindowResizeCorner:

    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    push    hl
        call    z, _SET_CURRENT_PROCESS
    pop     ix

    call    _START_RESIZE_WINDOW

    ret

; --------------------------------------

.click_Desktop:


    ; -------------- click icon 0x0 --------------------

    ld      h, 3 * 8                                    ; icon tile top left X
    ld      l, 1 * 8                                    ; icon tile top left Y
    ld      ix, Notepad.Header                          ; process header addr on ROM
    ld		de, PATTBL + (TILE_BASE_DESKTOP_ICON_0 * 8)	; icon VRAM PATTBL address (destiny)
    ld      bc, OS.desktop_Tiles                        ; icon name base NAMTBL buffer addr
    call    _CHECK_CLICK_DESKTOP_ICON
    ret     nz ; if icon clicked end processing

    ; -------------- click icon 1x0 --------------------

    ld      h, 11 * 8                                   ; icon tile top left X
    ld      l, 1 * 8                                    ; icon tile top left Y
    ld      ix, Calc.Header                             ; process header addr on ROM
    ld		de, PATTBL + (TILE_BASE_DESKTOP_ICON_1 * 8) ; icon VRAM PATTBL address (destiny)
    ld      bc, OS.desktop_Tiles + 8                    ; icon name base NAMTBL buffer addr
    call    _CHECK_CLICK_DESKTOP_ICON
    ret     nz ; if icon clicked end processing

    ; -------------- click icon 0x1 --------------------

    ld      h, 3 * 8                                                    ; icon tile top left X
    ld      l, 9 * 8                                                    ; icon tile top left Y
    ld      ix, Paint.Header                                            ; process header addr on ROM
    ld		de, PATTBL + (256 * 8) + (TILE_BASE_DESKTOP_ICON_0 * 8)     ; icon VRAM PATTBL address (destiny)
    ld      bc, OS.desktop_Tiles + 256                                  ; icon name base NAMTBL buffer addr
    call    _CHECK_CLICK_DESKTOP_ICON
    ret     nz ; if icon clicked end processing

    ; -------------- click icon 1x1 --------------------

    ld      h, 11 * 8                                                   ; icon tile top left X
    ld      l, 9 * 8                                                    ; icon tile top left Y
    ld      ix, TicTacToe.Header                                        ; process header addr on ROM
    ld		de, PATTBL + (256 * 8) + (TILE_BASE_DESKTOP_ICON_1 * 8)     ; icon VRAM PATTBL address (destiny)
    ld      bc, OS.desktop_Tiles + 256 + 8                              ; icon name base NAMTBL buffer addr
    call    _CHECK_CLICK_DESKTOP_ICON
    ret     nz ; if icon clicked end processing

    ; -------------- click icon 0x2 --------------------

    ld      h, 3 * 8                                                    ; icon tile top left X
    ld      l, 17 * 8                                                   ; icon tile top left Y
    ld      ix, Settings.Header                                         ; process header addr on ROM
    ld		de, PATTBL + (512 * 8) + (TILE_BASE_DESKTOP_ICON_0 * 8)     ; icon VRAM PATTBL address (destiny)
    ld      bc, OS.desktop_Tiles + 512                                  ; icon name base NAMTBL buffer addr
    call    _CHECK_CLICK_DESKTOP_ICON
    ret     nz ; if icon clicked end processing

    ; -------------- click icon 1x2 --------------------

    ld      h, 11 * 8                                                   ; icon tile top left X
    ld      l, 17 * 8                                                   ; icon tile top left Y
    ld      ix, Tetra.Header                                            ; process header addr on ROM
    ld		de, PATTBL + (512 * 8) + (TILE_BASE_DESKTOP_ICON_1 * 8)     ; icon VRAM PATTBL address (destiny)
    ld      bc, OS.desktop_Tiles + 512 + 8                              ; icon name base NAMTBL buffer addr
    call    _CHECK_CLICK_DESKTOP_ICON
    ret     nz ; if icon clicked end processing



    ; ------ click on empty part of desktop (disable selected icon)

    call    _INIT_DESKTOP

    call    _UPDATE_SCREEN

    ret

; --------------------------------------

.click_Taskbar:

    ; avoid first 6 lines of taskbar
    ; if (mouseY < 182) ret
    ld      a, (OS.mouseY)
    cp      191 + 1 - 10 ; 191: screen last line ; 10: height of taskbar
    ret     c



    ld      a, (OS.mouseX)
    
    ; if (mouseX >= 26*8)
    cp      26 * 8
    jp      nc, .click_Taskbar_Clock

    ; else if (mouseX >= 20*8)
    cp      20 * 8
    ld      hl, (OS.taskbar_Button_3_Process_addr)
    jp      nc, .click_Taskbar_button

    ; else if (mouseX >= 15*8)
    cp      15 * 8
    ld      hl, (OS.taskbar_Button_2_Process_addr)
    jp      nc, .click_Taskbar_button

    ; else if (mouseX >= 10*8)
    cp      10 * 8
    ld      hl, (OS.taskbar_Button_1_Process_addr)
    jp      nc, .click_Taskbar_button

    ; else if (mouseX >= 5*8)
    cp      5 * 8
    ld      hl, (OS.taskbar_Button_0_Process_addr)
    jp      nc, .click_Taskbar_button

    ; else if (mouseX >= 3*8 && mouseX < 4*8)
    cp      3 * 8
    jp      c, .skip_10
    cp      4 * 8
    jp      c, .click_Taskbar_ShowDesktop
.skip_10:


    ret



.click_Taskbar_ShowDesktop:

    call    _MINIMIZE_ALL_PROCESSES
    
    ret


.click_Taskbar_Clock:
    ; ---- if double click, open settings app
    ld      a, (OS.isDoubleClick)
    or      a
    ret     z

    ; ld      a, SETTINGS_TABS_VALUES.TAB_TIME
    ld      hl, Settings.Header
    call    _LOAD_PROCESS


    ; ----- set current tab to Time

    ld      ix, (OS.currentProcessAddr)

    ; get RAM variables area of this process
    ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    push    hl ; IY = HL
    pop     iy

    ld      a, SETTINGS_TABS_VALUES.TAB_TIME
    ld      (iy + SETTINGS_VARS.TAB_SELECTED), a

    ; call "Draw" event of this process
    ld      e, (ix + PROCESS_STRUCT_IX.drawAddr)         ; process.Draw addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.drawAddr + 1)     ; process.Draw addr (high)
    call    JP_DE

    ret


; Input:
;   HL = process addr (0xffff if empty)
.click_Taskbar_button:

    ; if (taskbar_Button_?_Process_addr == 0xffff) ret:
    push    hl
        inc     hl
        ld      a, l
        or      h
    pop     hl
    ret     z

    push    hl  ; IX = HL
    pop     ix

    ; if window is minimized, set window state to RESTORED/MAXIMIZED previously saved
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.MINIMIZED
    jp      nz, .skip_20

    ld      a, (ix + PROCESS_STRUCT_IX.previousWindowState)
    ld      (ix + PROCESS_STRUCT_IX.windowState), a
.skip_20:

    call    _SET_CURRENT_PROCESS

    ret


; Inputs:
;   H = icon tile top left X
;   L = icon tile top left Y
;   IX = process header addr on ROM
;   DE = icon VRAM PATTBL address (destiny)
;   BC = icon name base NAMTBL buffer addr
; Outputs:
;   NZ (icon clicked)
;   Z (icon not clicked)
_CHECK_CLICK_DESKTOP_ICON:

    ld      a, (OS.mouseX)
    ; if (mouseX < 3*8) not_click_icon_0x0
    cp      h ;3 * 8
    jp      c, .not_click_icon
    ; if (mouseX >= 6*8) not_click_icon_0x0
    ld      a, 3 * 8
    add     h
    ld      h, a
    ld      a, (OS.mouseX)
    cp      h ;6 * 8
    jp      nc, .not_click_icon

    ld      a, (OS.mouseY)
    ; if (mouseY < 1*8) not_click_icon_0x0
    cp      l ; 1 * 8
    jp      c, .not_click_icon
    ; if (mouseY >= 4*8) not_click_icon_0x0
    ld      a, 3 * 8
    add     l
    ld      l, a
    ld      a, (OS.mouseY)
    cp      l ;4 * 8
    jp      nc, .not_click_icon

    ; ---- if double click, open app
    ld      a, (OS.isDoubleClick)
    or      a
    jp      z, .isNotDoubleClick_1
    push    ix ; HL = IX
    pop     hl
    call    _LOAD_PROCESS
    jp      .retNZ
.isNotDoubleClick_1:

    ; ---- if clicked, select icon

    push    ix, hl, de, bc
        call    _INIT_DESKTOP
    pop     bc, de, hl, ix

    push    ix, bc
        ; ld      ix, Notepad.Header
        ; ld		de, PATTBL + (TILE_BASE_DESKTOP_ICON_0 * 8)		        ; VRAM address (destiny)
        call    _LOAD_ICON_INVERTED_FROM_APP_HEADER
    pop     hl, ix

    ; ld      ix, Notepad.Header
    ; ld      hl, OS.desktop_Tiles
    call    _DRAW_DESKTOP_ICON_NAME_REVERSED

    call    _UPDATE_SCREEN

.retNZ:
    ld      a, 1 ; return NZ (icon clicked)
    or      a
    ret

.not_click_icon:
    xor     a   ; return Z (icon not clicked)
    ret