_UPDATE_SCREEN_MAPPING:

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
    
    call    _CONVERT_COL_LINE_TO_LINEAR

    call    _UPDATE_SCREEN_MAPPING_WINDOW

    ret



; Input:
;   IX = addr of process header
;   HL = linear addr (0-767)
_UPDATE_SCREEN_MAPPING_WINDOW:

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


    ld      a, SCREEN_MAPPING_TASKBAR ; 254
    ld      b, 32 * 2                   ; size of taskbar (2 last lines)
.loop_2:
    ld      (hl), a
    inc     hl
    djnz    .loop_2


    ret