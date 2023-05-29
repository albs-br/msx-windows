; taskbar:
; 5 tiles at left (home, show desktop, plus spaces)
; 7 tiles at right (hh:mm + spaces)
;
; = 20 tiles for buttons
; 5 per button: 4 for name, plus 1 for separator

; Input: nothing
; Output: nothing
_DRAW_TASKBAR:

    ; draw taskbar
    ld		hl, TASKBAR_INIT        ; RAM address (source)
    ld		de, NAMTBL + (32 * 22)  ; VRAM address (destiny)
    ld		bc, 64	                ; Block length
    call 	BIOS_LDIRVM        	    ; Block transfer to VRAM from memory



    call    _DRAW_TASKBAR_BUTTONS


    call    _DRAW_TASKBAR_CLOCK


    ret



_DRAW_TASKBAR_BUTTONS:

    ld      iy, NAMTBL + (32 * 23) + 5

    ; init taskbar_Button_?_Process_addr vars
    ld      hl, 0xffff
    ld      (OS.taskbar_Button_0_Process_addr), hl
    ld      (OS.taskbar_Button_1_Process_addr), hl
    ld      (OS.taskbar_Button_2_Process_addr), hl
    ld      (OS.taskbar_Button_3_Process_addr), hl

    ld      hl, OS.taskbar_Button_0_Process_addr
    ld      (TempWord), hl

    ; loop through process slots deawing taskbar buttons
    ld      hl, OS.processes
    ld      b, MAX_PROCESS_ID + 1
.loop_1:
    ld      a, (hl)
    inc     a
    jp      z, .next ; if (process id == 255) next

    ; TILE_FONT_REVERSED_LOWERCASE_A = 01Eh = 30
    ; TILE_FONT_LOWERCASE_A = 043h = 67

    push    hl ; IX = HL
    pop     ix

    ; link process addr to button for click
    push    de
        ld      de, (TempWord)

        ld      a, l
        ld      (de), a
        inc     de
        ld      a, h
        ld      (de), a
        inc     de

        ld      (TempWord), de
    pop     de

    push    hl, bc
    
        ld      bc, PROCESS_STRUCT_IX.taskbarTitle
        add     hl, bc

        push    hl ; DE = HL
        pop     de

        push    iy ; HL = IY
        pop     hl
        call    BIOS_SETWRT

        ld      c, 4 ; max size of title on button

        .loop_2:
            ld      a, (de)
            cp      33
            jp      z, .end_1

            push    de

                ld      de, (OS.currentProcessAddr)
                
                push    ix  ; HL = IX
                pop     hl

                call    BIOS_DCOMPR

            pop     de

            jp      nz, .printNormal

            ; print black chars on white bg
            ld      a, (de)
            add     TILE_FONT_LOWERCASE_A - TILE_FONT_REVERSED_LOWERCASE_A
            jp      .continue_2
        .printNormal:
            ld      a, (de)
        .continue_2:
            out     (PORT_0), a

            dec     c
            jp      z, .end_1

            inc     de
            jp      .loop_2

        .end_1:
        
        ld      bc, 5
        add     iy, bc ; go to next button

    pop     bc, hl



.next:
    ld      de, Process_struct.size
    add     hl, de

    djnz    .loop_1

    ret



; draw system time on right of taskbar
_DRAW_TASKBAR_CLOCK:

    ; set HL to clock place on taskbar 
    ld		hl, NAMTBL + (32 * 23) + 26 ; VRAM address (destiny)
    call    BIOS_SETWRT
    ld      c, PORT_0


    ld      b, TILE_FONT_REVERSED_NUMBERS_0

    ; tens of hours digit
    ld      a, (OS.currentTime_Hours)
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    or      a
    jp      z, .skipTensOfHours ; if tens of hours == 0 not print 
    add     b ; convert digit in BCD to tile number
    jp      .continue
.skipTensOfHours:
    ld      a, TILE_EMPTY_BLACK
.continue:
    out     (c), a

    ; units of hours digit
    ld      a, (OS.currentTime_Hours)
    and     0000 1111 b
    add     b ; convert digit in BCD to tile number
    out     (c), a

    ; write char ':'
    nop
    nop
    ld      a, TILE_FONT_REVERSED_SYMBOLS + 0 ; char ':'
    out     (c), a

    ; tens of hours digit
    ld      a, (OS.currentTime_Minutes)
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    srl     a ; shift right n, bit 7 = 0, carry = 0
    add     b ; convert digit in BCD to tile number
    out     (c), a
    
    ; units of hours digit
    ld      a, (OS.currentTime_Minutes)
    and     0000 1111 b
    add     b ; convert digit in BCD to tile number
    out     (c), a

    ret



TASKBAR_INIT:
    ; first line
    db TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP
    db TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP
    db TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP
    db TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP
    db TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP
    db TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP
    db TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP
    db TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP, TILE_TASKBAR_TOP

    ; second line
    db TILE_EMPTY_BLACK, TILE_HOME_ICON, TILE_EMPTY_BLACK
    
    db TILE_SHOW_DESKTOP_ICON, TILE_EMPTY_BLACK

    db TILE_EMPTY_BLACK
    db TILE_EMPTY_BLACK, TILE_EMPTY_BLACK, TILE_EMPTY_BLACK, TILE_EMPTY_BLACK
    db TILE_EMPTY_BLACK, TILE_EMPTY_BLACK
    ; ; debug
    ; db TILE_FONT_REVERSED_LOWERCASE_A + 13 ; 'n'
    ; db TILE_FONT_REVERSED_LOWERCASE_A + 14 ; 'o'
    ; db TILE_FONT_REVERSED_LOWERCASE_A + 19 ; 't'
    ; db TILE_FONT_REVERSED_LOWERCASE_A + 4  ; 'e'
    ; db TILE_FONT_REVERSED_LOWERCASE_A + 15 ; 'p'
    ; db TILE_FONT_REVERSED_LOWERCASE_A + 0  ; 'a'
    ; db TILE_FONT_REVERSED_LOWERCASE_A + 3  ; 'd'
    
    db TILE_EMPTY_BLACK
    
    db TILE_EMPTY_BLACK, TILE_EMPTY_BLACK, TILE_EMPTY_BLACK, TILE_EMPTY_BLACK
    ; db TILE_FONT_LOWERCASE_A + 2  ; 'c'
    ; db TILE_FONT_LOWERCASE_A + 0  ; 'a'
    ; db TILE_FONT_LOWERCASE_A + 11 ; 'l'
    ; db TILE_FONT_LOWERCASE_A + 2  ; 'c'
    
    db TILE_EMPTY_BLACK, TILE_EMPTY_BLACK, TILE_EMPTY_BLACK
    db TILE_EMPTY_BLACK, TILE_EMPTY_BLACK, TILE_EMPTY_BLACK, TILE_EMPTY_BLACK
    
    db TILE_EMPTY_BLACK, TILE_EMPTY_BLACK
    
    ; ; debug
    ; db TILE_FONT_REVERSED_NUMBERS_0 + 1, TILE_FONT_REVERSED_NUMBERS_0 + 0 ; hours
    ; db TILE_FONT_REVERSED_SYMBOLS + 0 ; char ':'
    ; db TILE_FONT_REVERSED_NUMBERS_0 + 4, TILE_FONT_REVERSED_NUMBERS_0 + 9 ; minutes
    db TILE_EMPTY_BLACK, TILE_EMPTY_BLACK, TILE_EMPTY_BLACK, TILE_EMPTY_BLACK, TILE_EMPTY_BLACK
    
    db TILE_EMPTY_BLACK
