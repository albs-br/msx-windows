; Update screen (redraw all windows ordered by layer) and screen mapping 
; Input: nothing
; Output: nothing
_UPDATE_SCREEN:

    ; TODO ? (decide if is better keep or change it)
    ; to improve usability (avoid window flickering):
    ; do all the below work on a RAM buffer (32*22 = 704 bytes)
    ; and then spit it out to screen on vblank


    ; ; debug
    ; ld a, 0
    ; ld (Temp), a

    call    Wait_Vblank

    call    _DRAW_DESKTOP



    ; init screen mapping with desktop and taskbar
    call    _INIT_SCREEN_MAPPING

    ; loop through running processes ordered by layer number
    ; updating screenmapping with window info

    ld      c, 0        ; layer number to be searched
    ld      de, Process_struct.size

.outerLoop:
    ld      hl, OS.processes + PROCESS_STRUCT_IX.layer ; HL points to first process layer

    ld      b, MAX_PROCESS_ID + 1
    .innerLoop:
        ; if (process.layer == C) .execute
        ld      a, (hl)
        cp      c
        push    hl, de, bc
            call    z, .execute
        pop     bc, de, hl

        ld      de, Process_struct.size
        add     hl, de

        djnz    .innerLoop

    inc     c
    ld      a, c
    cp      MAX_PROCESS_ID + 1
    ret     z

    jp      .outerLoop

    ; ret

.execute:

    ; return HL to start of process
    ld      de, PROCESS_STRUCT_IX.layer
    xor     a ; clear carry
    sbc     hl, de

    ; ix = hl
    push    hl
    pop     ix

    ; get variables from process
    ld      l, (ix + PROCESS_STRUCT_IX.x) ; process.x
    ld      h, (ix + PROCESS_STRUCT_IX.y) ; process.y
    
    push    ix
        call    _CONVERT_COL_LINE_TO_LINEAR
    pop     ix

    call    _UPDATE_SCREEN_MAPPING_WINDOW

    call    _DRAW_WINDOW

    ret



; Input:
;   IX = addr of process header
;   HL = linear addr (0-767)
_UPDATE_SCREEN_MAPPING_WINDOW:

    ; if (windowState == MINIMIZED) ret
    ld      a, (ix + PROCESS_STRUCT_IX.windowState) ; process.windowState
    cp      WINDOW_STATE.MINIMIZED
    ret     z

    ; if (windowState == MAXIMIZED) update screen mapping for window maximized
    cp      WINDOW_STATE.MAXIMIZED
    jp      z, _UPDATE_SCREEN_MAPPING_WINDOW_MAXIMIZED

    ; HL = OS.screenMapping + HL
    ex      de, hl
    ld      hl, OS.screenMapping
    add     hl, de
    
    ld      de, 32 ; next line

    ; fill all window area
    push    hl
        ld      c, (ix + PROCESS_STRUCT_IX.height) ; process.height
    .outerLoop_1:
            push    hl
                ld      b, (ix + PROCESS_STRUCT_IX.width) ; process.width
            .loop_20:
                
                ; set value of SCREEN_MAPPING_WINDOWS + process id
                ld      a, (ix + PROCESS_STRUCT_IX.processId)
                or      SCREEN_MAPPING_WINDOWS
                
                ld      (hl), a
                inc     hl
                djnz    .loop_20
            pop     hl

        add     hl, de
        dec     c
        jp      nz, .outerLoop_1
    pop     hl

    ; set value of SCREEN_MAPPING_WINDOWS_TITLE_BAR + process id
    ld      a, (ix + PROCESS_STRUCT_IX.processId)
    or      SCREEN_MAPPING_WINDOWS_TITLE_BAR
    ld      c, a

    ; title 1st line
    push    hl
        ld      b, (ix + PROCESS_STRUCT_IX.width) ; process.width
    .loop_21:
        ld      (hl), c
        inc     hl
        djnz    .loop_21
    pop     hl
    ; title 2nd line
    add     hl, de ; go to next line
    push    hl
        ld      a, (ix + PROCESS_STRUCT_IX.width) ; process.width
        sub     4 ; process.width - 4
        ld      b, a
    .loop_22:
        ld      (hl), c
        inc     hl
        djnz    .loop_22

        ld      a, (ix + PROCESS_STRUCT_IX.processId)
        or      SCREEN_MAPPING_WINDOWS_MINIMIZE_BUTTON
        ld      (hl), a
        inc     hl

        ld      a, (ix + PROCESS_STRUCT_IX.processId)
        or      SCREEN_MAPPING_WINDOWS_MAXIMIZE_RESTORE_BUTTON
        ld      (hl), a
        inc     hl

        ld      a, (ix + PROCESS_STRUCT_IX.processId)
        or      SCREEN_MAPPING_WINDOWS_CLOSE_BUTTON
        ld      (hl), a
        inc     hl

    pop     hl

    ; set SCREEN_MAPPING_WINDOWS_RESIZE_CORNER 

    ; L = process.X + (process.width - 1)
    ld      a, (ix + PROCESS_STRUCT_IX.x)
    ld      l, (ix + PROCESS_STRUCT_IX.width)
    dec     l
    add     l
    ld      l, a

    ; H = process.Y + (process.height - 1)
    ld      a, (ix + PROCESS_STRUCT_IX.y)
    ld      h, (ix + PROCESS_STRUCT_IX.height)
    dec     h
    add     h
    ld      h, a
    call    _CONVERT_COL_LINE_TO_LINEAR
    
    ld      de, OS.screenMapping
    add     hl, de

    push    hl ; IY = HL
    pop     iy

    ld      a, (ix + PROCESS_STRUCT_IX.processId)
    or      SCREEN_MAPPING_WINDOWS_RESIZE_CORNER
    
    ; put screen resize corner on the 2x2 tiles at window bottom right 
    ld      (iy), a
    ld      (iy - 1), a
    ld      (iy - 32), a
    ld      (iy - 33), a

    ret



_UPDATE_SCREEN_MAPPING_WINDOW_MAXIMIZED:

    ; ---- fill all window area
    ld      hl, OS.screenMapping
    
    push    hl
        ; set value of SCREEN_MAPPING_WINDOWS + process id
        ld      a, (ix + PROCESS_STRUCT_IX.processId)
        or      SCREEN_MAPPING_WINDOWS

        ld      (hl), a
        ld      de, OS.screenMapping + 1
        ld      bc, 0 + (32 * 22) - 1
        ldir
    pop     hl



    ; set value of SCREEN_MAPPING_WINDOWS_TITLE_BAR + process id
    ld      a, (ix + PROCESS_STRUCT_IX.processId)
    or      SCREEN_MAPPING_WINDOWS_TITLE_BAR

    ; title 1st line
    ; push    hl
        ld      b, 32 - 3 ; width of window maximized, minus buttons
    .loop_21:
        ld      (hl), a
        inc     hl
        djnz    .loop_21
    ; pop     hl


    ld      a, (ix + PROCESS_STRUCT_IX.processId)
    or      SCREEN_MAPPING_WINDOWS_MINIMIZE_BUTTON
    ld      (hl), a
    inc     hl

    ld      a, (ix + PROCESS_STRUCT_IX.processId)
    or      SCREEN_MAPPING_WINDOWS_MAXIMIZE_RESTORE_BUTTON
    ld      (hl), a
    inc     hl

    ld      a, (ix + PROCESS_STRUCT_IX.processId)
    or      SCREEN_MAPPING_WINDOWS_CLOSE_BUTTON
    ld      (hl), a
    ; inc     hl


    ret



; Input: nothing
_INIT_SCREEN_MAPPING:

    ; ------- init OS.screenMapping
    ld      hl, OS.screenMapping
    push    hl ; de = hl
    pop     de
    inc     de
    ld      bc, 0 + (32 * 22) - 1            ; size of desktop (22 lines)
    ld      a, SCREEN_MAPPING_DESKTOP ; 255
    ld      (hl), a
    ldir

;     ld      hl, OS.screenMapping
;     ld      bc, 32 * 22             ; size of desktop (22 lines)
; .loop_1:
;     ld      a, SCREEN_MAPPING_DESKTOP ; 255
;     ld      (hl), a
    
;     inc     hl
    
;     dec     bc
;     ld      a, c
;     or      b
;     jp      nz, .loop_1


    ld      hl, OS.screenMapping + (32*22)

    ld      a, SCREEN_MAPPING_TASKBAR ; 254
    ld      b, 32 * 2                   ; size of taskbar (2 last lines)
.loop_2:
    ld      (hl), a
    inc     hl
    djnz    .loop_2


    ret