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
    push    hl
        call    z, _SET_CURRENT_PROCESS
    pop     ix

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


    ; --- dragOffset_X = mouseX - window_X
    ld      a, (ix + PROCESS_STRUCT_IX.x) ; get window X in columns (0-31)
    ; multiply by 8 to convert to pixels (0-255)
    ; sla     a ; shift left R; bit 7 -> C ; bit 0 -> 0
    ; sla     a
    ; sla     a   ; convert window X to pixels
    add     a   ; If you use register A you can multiply faster by using the ADD A,A instruction, which is 5 T-states per instruction instead of 8
    add     a
    add     a
    inc     a ; adjust for the empty line on left
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
    add     6 ; adjust for the 6 empty lines on title bar top
    ld      (OS.windowCorner_TopLeft_Y), a
    ld      b, a

    ld      a, (OS.mouseY)

    sub     b

    ld      (OS.dragOffset_Y), a

    call    _ADJUST_WINDOW_DRAG_CORNERS



    ; set other window corners sprites vars
    ld      a, SPRITE_INDEX_WINDOW_TOP_LEFT
    ld      (OS.windowCorner_TopLeft_Pattern), a
    ld      a, SPRITE_INDEX_WINDOW_BOTTOM_LEFT
    ld      (OS.windowCorner_BottomLeft_Pattern), a
    ld      a, SPRITE_INDEX_WINDOW_TOP_RIGHT
    ld      (OS.windowCorner_TopRight_Pattern), a
    ld      a, SPRITE_INDEX_WINDOW_BOTTOM_RIGHT
    ld      (OS.windowCorner_BottomRight_Pattern), a


    ld      a, 15 ; white
    ld      (OS.windowCorner_TopLeft_Color), a
    ld      (OS.windowCorner_BottomLeft_Color), a
    ld      (OS.windowCorner_TopRight_Color), a
    ld      (OS.windowCorner_BottomRight_Color), a


    ret



; Adjust the other three corners based on the position of the top left corner
_ADJUST_WINDOW_DRAG_CORNERS:
    ; 
    ld      a, (ix + PROCESS_STRUCT_IX.width)
    add     a ; mult by 8 to convert to pixels
    add     a
    add     a
    ld      b, a
    ld      a, (OS.windowCorner_TopLeft_X)
    ld      (OS.windowCorner_BottomLeft_X), a
    add     b
    sub     16 + 5 ; sprite width / decrement window shadow
    ld      (OS.windowCorner_TopRight_X), a
    ld      (OS.windowCorner_BottomRight_X), a
    ; 
    ld      a, (ix + PROCESS_STRUCT_IX.height)
    add     a ; mult by 8 to convert to pixels
    add     a
    add     a
    ld      b, a
    ld      a, (OS.windowCorner_TopLeft_Y)
    ld      (OS.windowCorner_TopRight_Y), a
    add     b
    sub     16 + 10; sprite height / decrement window shadow
    ld      (OS.windowCorner_BottomLeft_Y), a
    ld      (OS.windowCorner_BottomRight_Y), a

    ; get color based on JIFFY
    ld      a, (BIOS_JIFFY)
    and     0000 1111 b
    ld      hl, DRAG_WINDOW_SPRITE_COLOR_LUT
    ld      b, 0
    ld      c, a
    add     hl, bc
    ld      a, (hl)
    ld      (OS.windowCorner_TopLeft_Color), a
    ld      (OS.windowCorner_BottomLeft_Color), a
    ld      (OS.windowCorner_TopRight_Color), a
    ld      (OS.windowCorner_BottomRight_Color), a

    ret

; look up table for smooth blinking effetc using a color ramp
DRAG_WINDOW_SPRITE_COLOR_LUT: 
    db 15, 14, 14, 7, 5, 5, 4, 1, 1, 4, 4, 5, 7, 7, 14, 15



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

    call    _ADJUST_WINDOW_DRAG_CORNERS

    ret



_END_DRAG_WINDOW:
    
    ; reset window dragging vars
    xor     a
    ld      (OS.isDraggingWindow), a

    ld      ix, (OS.currentProcessAddr)

    ld      a, (OS.windowCorner_TopLeft_X)
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      (ix + PROCESS_STRUCT_IX.x), a

    ld      a, (OS.windowCorner_TopLeft_Y)
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    ld      (ix + PROCESS_STRUCT_IX.y), a

    call    _UPDATE_SCREEN

    ret