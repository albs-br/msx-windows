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

    ; set x and y of window and
    ; update OS.nextWindow_x and y to the next
    ; ld      a, (OS.nextWindow_x)
    ; ld      (ix + PROCESS_STRUCT_IX.x), a
    ; add     2
    ; ld      (OS.nextWindow_x), a

    ; ld      a, (OS.nextWindow_y)
    ; ld      (ix + PROCESS_STRUCT_IX.y), a
    ; add     2
    ; ld      (OS.nextWindow_y), a


    ; ld      ix, (OS.currentProcessAddr)
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
