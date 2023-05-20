MAX_PROCESS_ID: equ 3 ; max 4 processes available (maybe 6 in the future)


; Input:
;   HL = addr of process header (on ROM)
_LOAD_PROCESS:

; TODO
;     ; if ((OS.nextAvailableProcessAddr) == 0xffff) alert('Max process limit exceeded')
;     ld      de, (OS.nextAvailableProcessAddr)
;     ld      a, 0xff
;     cp      d
;     jp      nz, .skip_0
;     cp      e
;     jp      z, .showAlertMaxProcessLimitReached
; .skip_0:

    ; clear this process slot (fill with 0xff)
    push    hl

            ld      a, 0xff
            ld      hl, (OS.nextAvailableProcessAddr)
            ld      (hl), a
            
            push    hl ; DE = HL
            pop     de

            inc     de

            ; ld      hl, ?
            ; ld      de, ?
            ld      bc, Process_struct.size - 1
            ldir
    pop     hl

    ; copy header from source to next empty process slot
    ;ld      hl, ???                                            ; source
    ld      de, (OS.nextAvailableProcessAddr)                   ; destiny
    ld      bc, Process_struct.size_without_screenTilesBehind   ; size
    ldir                                                        ; Copy BC bytes from HL to DE

    ; set current process to this
    ld      hl, (OS.nextAvailableProcessAddr)
    ld      (OS.currentProcessAddr), hl


    ; update next empty process slot to the next
    ; TODO: change by _GET_NEXT_AVAILABLE_PROCESS_ADDR
    ld      hl, (OS.nextAvailableProcessAddr)
    ld      bc, Process_struct.size
    add     hl, bc
    ; TODO: check if it exceeded process.size space
    ; if so, set OS.nextAvailableProcessAddr to 0xffff
    ld      (OS.nextAvailableProcessAddr), hl




    ; ; -----debug (set some fake process ids)
    ; ld      bc, Process_struct.size
    
    ; ld      hl, OS.processes
    ; ld      a, 3
    ; ld      (hl), a
    
    ; add     hl, bc
    ; ld      a, 0
    ; ld      (hl), a

    ; add     hl, bc
    ; ld      a, 1
    ; ld      (hl), a

    ; add     hl, bc
    ; ld      a, 2
    ; ld      (hl), a

    ; ; -----


    ; set processId
    ld      hl, (OS.currentProcessAddr)
    call    _GET_NEXT_AVAILABLE_PROCESS_ID
    ld      a, ixh
    cp      255
    jp      z, .maxProcessLimitReached
    ld      hl, (OS.currentProcessAddr)
    ld      (hl), a ; set ProcessId

    ; TODO
    ; define ramStartAddr and vramStartTileAddr


    ld      ix, (OS.currentProcessAddr)
    call    _DRAW_WINDOW

    ; call process.Open event
    ; ld      hl, (OS.currentProcessAddr)
    ld      ix, (OS.currentProcessAddr)
    ld      e, (ix + PROCESS_STRUCT_IX.openAddr)         ; process.Open addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.openAddr + 1)     ; process.Open addr (high)
    call    JP_DE



    ; ld        l, (ix + n)    ; process.Open addr
    ; ld        h, (ix + n + 1)    ; process.Open addr + 1
    ; ; simulate call      (hl)
    ; push      hl
    ; jp        (hl)

    ; other method to emulate call (hl):
    
    ; ; Simply "jp [hl]", but can be used to emulate the instruction "call [hl]"
    ; ; param hl: address
    ; JP_HL:
	;     jp	[hl]



    ret

.maxProcessLimitReached:
    ; set nextAvailableProcessAddr to 0xffff, meaning no memory space available for new process
    ld      hl, 0xffff
    ld      (OS.nextAvailableProcessAddr), hl

    ret

.showAlertMaxProcessLimitReached:

    ; debug
    call BIOS_BEEP
    jp .showAlertMaxProcessLimitReached

    ret



; Input: nothing
; Output:
;   IXH = next available process id (between 0 and MAX_PROCESS_ID-1), 255 means no process space available
_GET_NEXT_AVAILABLE_PROCESS_ID:
    ld      ixh, 0          ; first process id to be searched

.outerLoop:
    ld      hl, OS.processes

.loop:
    ld      a, (hl)
    cp      ixh
    jp      z, .goToNext               ; process id found

    ld      bc, Process_struct.size
    add     hl, bc          ; go to next process slot on memory

    ; check if process space ended
    ld      de, OS.processes_end
    call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jp      nz, .loop

    ; if processes id on ixh wasn't found, it is the next available
    ret

.goToNext:
    inc     ixh
    ld      a, ixh
    cp      MAX_PROCESS_ID + 1
    jp      nz, .outerLoop

    ; if searched for each possible process id on each processes slot, then OS max process limit was reached
    ld      ixh, 255

    ret


; TODO: test:
; Input: nothing
; Output:
;   HL: addr of process slot, if available
;   A = 0, process slot found
;   A = 255, no process slot available
_GET_NEXT_AVAILABLE_PROCESS_ADDR:

    ld      hl, OS.processes
    ld      de, Process_struct.size
    ld      b, MAX_PROCESS_ID + 1
.loop:
    ld      a, (hl)
    ; process id = 255 means that this process slot is available
    inc     a       ; if (A == 255) return
    ret     z

    add     hl, de

    djnz    .loop

    ; if no process slot available return A = 255
    ld      a, 255

    ret



; Input:
;   HL = addr of process header
_SET_CURRENT_PROCESS:
    ; set curr proc to process
    ld      (OS.currentProcessAddr), hl

    ; ; TODO
    ; push    hl ; ix = hl
    ; pop     ix
    ; call    _DRAW_WINDOW

    ; TODO
    ; place green led sprite on window title to show it is the active window
    ret



; Input:
;   C = process id
; Output
;   z = process found
;   nz = process not found
;   HL = addr of process; 0x0000 if not found
_GET_PROCESS_BY_ID:
    ; loop through process slots looking for this process id
    ld      hl, OS.processes
    ld      de, Process_struct.size
    ld      b, MAX_PROCESS_ID + 1
.loop_1:
    ld      a, (hl)
    cp      c
    ret     z
    add     hl, de
    djnz    .loop_1

    ; not found
    ld      hl, 0x0000

    ret