MAX_PROCESS_ID: equ 3 ; max 4 processes available (maybe 6 in the future)


; Input:
;   HL = addr of process header 
_LOAD_PROCESS:

    ; TODO
    ; if ((OS.nextAvailableProcessAddr) == 0xffff) alert('Max process limit exceeded')

    ; copy header from source to next empty process slot
    ;ld      hl, ???                                        ; source
    ld      de, (OS.nextAvailableProcessAddr)               ; destiny
    ld      bc, Process_struct.size                         ; size
    ldir                                                    ; Copy BC bytes from HL to DE

    ; set current process to this
    ld      hl, (OS.nextAvailableProcessAddr)
    ld      (OS.currentProcessAddr), hl


    ; update next empty process slot to the next
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


    ld      hl, (OS.currentProcessAddr)
    call    _DRAW_WINDOW

    ret

.maxProcessLimitReached:
    ; set nextAvailableProcessAddr to 0xffff, meaning no memory space available for new process
    ld      hl, 0xffff
    ld      (OS.nextAvailableProcessAddr), hl

    ret

; Input: nothing
; Output:
;   IDX = next available process id (between 0 and MAX_PROCESS_ID-1), 255 means no process space available
_GET_NEXT_AVAILABLE_PROCESS_ID:
    ; ld ixh, 0xab ; debug
    ; ret

    ; ld      hl, OS.processes
    ; ld      de, Process_struct.size

    ; ld      a, (hl)

    ; add



;     ld      c, MAX_PROCESS_ID

;     ld      hl, OS.processes
;     ld      de, Process_struct.size
;     ld      b, MAX_PROCESS_ID
; .loop:
;     ld      a, (hl)
;     cp      255
;     jp      z, .next

;     ; if (a < c) c = a

; .next:
;     djnz    .loop



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