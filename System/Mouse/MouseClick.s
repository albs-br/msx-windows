_MOUSE_CLICK:

    ; if(isDraggingWindow)
    ld      a, (OS.isDraggingWindow)
    or      a
    jp      z, .skip_1
    ; (mouseButton_1 == false) _END_DRAG_WINDOW else _DO_DRAG_WINDOW
    ld      a, (OS.mouseButton_1) ; check if button is pressed
    or      a
    jp      z, _END_DRAG_WINDOW
    jp      _DO_DRAG_WINDOW

.skip_1:
    ; ----- get only positive transition of click

    ld      a, (OS.mouseButton_1) ; check if button is pressed
    ld      b, a
    or      a
    jp      z, .return ; ret     z


    ld      a, (OS.oldMouseButton_1) ; check if button was previously released
    or      a
    jp      nz, .return ; ret     nz


    ; update old mouse button state
    ld      a, b
    ld      (OS.oldMouseButton_1), a

;    ret     nz    

    ; ----- 

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

    cp      SCREEN_MAPPING_WINDOWS_MINIMIZE_BUTTON
    jp      z, .click_WindowMinimizeButton

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
    call    z, _SET_CURRENT_PROCESS
    ret     nz

    ; TODO
    ; call "Click" event of the process

    ret

; ---------------------------------------

.click_WindowTitleBar:

    ; TODO:
    ; ignore click on the first 6 lines of title

    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    call    z, _SET_CURRENT_PROCESS

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

.click_Desktop:
    ret

; --------------------------------------

.click_Taskbar:

    ; avoid first 6 lines of taskbar
    ; if (mouseY < 182) ret
    ld      a, (OS.mouseY)
    cp      191 + 1 - 10 ; 191: screen last line ; 10: height of taskbar
    ret     c



    ld      a, (OS.mouseX)
    
    ; if (mouseX >= 20*8)
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

    ; loop through all process minimizing them
    ld      hl, OS.processes
    ld      de, Process_struct.size
    ld      b, MAX_PROCESS_ID + 1
.loop_1:
    ld      a, (hl)
    cp      0xff ; if process slot empty go to the next
    jp      z, .next_1

    push    hl, de, bc
        ld      c, a
        call    _GET_PROCESS_BY_ID

        call    _MINIMIZE_PROCESS
    pop     bc, de, hl

.next_1:
    add     hl, de
    djnz    .loop_1
    
    ret



.click_Taskbar_button:

    ; if (taskbar_Button_?_Process_addr == 0xffff) ret:
    push    hl
        inc     hl
        ld      a, l
        or      h
    pop     hl
    ret     z

    call    _SET_CURRENT_PROCESS

    ret



_START_DRAG_WINDOW:
    ; set vars for window dragging
    ld      a, 1
    ld      (OS.isDraggingWindow), a


    push    hl
    pop     ix

    ; TODO (test):
    ; --- dragOffset_X = mouseX - window_X
    ld      a, (ix + PROCESS_STRUCT_IX.x) ; get window X in columns (0-31)
    ; multiply by 8 to convert to pixels (0-255)
    ; sla     a ; shift left R; bit 7 -> C ; bit 0 -> 0
    ; sla     a
    ; sla     a   ; convert window X to pixels
    add     a   ; If you use register A you can multiply faster by using the ADD A,A instruction, which is 5 T-states per instruction instead of 8
    add     a
    add     a
    ld      (OS.windowCorner_TopLeft_X), a
    ld      b, a

    ld      a, (OS.mouseX)

    sub     b

    ld      (OS.dragOffset_X), a



    ; --- dragOffset_Y = window_Y - mouseY
    ld      a, (ix + PROCESS_STRUCT_IX.y) ; get window Y in columns (0-31)
    ; multiply by 8 to convert to pixels (0-255)
    ; sla     a ; shift left R; bit 7 -> C ; bit 0 -> 0
    ; sla     a
    ; sla     a   ; convert window X to pixels
    add     a   ; If you use register A you can multiply faster by using the ADD A,A instruction, which is 5 T-states per instruction instead of 8
    add     a
    add     a
    ld      (OS.windowCorner_TopLeft_Y), a
    ld      b, a

    ld      a, (OS.mouseY)

    sub     b

    ld      (OS.dragOffset_Y), a



    ; set other window corners sprites vars
    ld      a, SPRITE_INDEX_WINDOW_TOP_LEFT
    ld      (OS.windowCorner_TopLeft_Pattern), a
    ld      a, 4 ; blue
    ld      (OS.windowCorner_TopLeft_Color), a
    ; TODO: complete here

    ret



_DO_DRAG_WINDOW:
    ; windowCorner_TopLeft_X = mouseX - dragOffset_X
    ld      a, (OS.dragOffset_X)
    ld      b, a
    ld      a, (OS.mouseX)
    sub     b
    ld      (OS.windowCorner_TopLeft_X), a

    ; windowCorner_TopLeft_Y = mouseY - dragOffset_Y
    ld      a, (OS.dragOffset_Y)
    ld      b, a
    ld      a, (OS.mouseY)
    sub     b
    ld      (OS.windowCorner_TopLeft_Y), a

    ret



_END_DRAG_WINDOW:
    
    ; reset window dragging vars
    xor     a
    ld      (OS.isDraggingWindow), a

    ret