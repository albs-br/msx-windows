MAX_PROCESS_ID: equ 3 ; max 4 processes available (maybe 6 in the future)


; Input:
;   HL = addr of process header 
_LOAD_PROCESS:

    ; TODO
    ; if ((OS.nextAvailableProcessAddr) == 0xffff) alert('Max process limit exceeded')

    ; TODO
    ; set processId
    ;call    _GET_NEXT_AVAILABLE_PROCESS_ID
    ; ld    a, idx
    ; cp    255
    ; jp    z, .maxProcessLimitReached
    ; ld    (hl), a ; set ProcessId

    ; copy header from source to next empty process slot
    ;ld      hl, ???                                        ; source
    ld      de, (OS.nextAvailableProcessAddr)               ; destiny
    ld      bc, Process_struct.size                         ; size
    ldir                                                    ; Copy BC bytes from HL to DE

    ; TODO
    ; define ramStartAddr and vramStartTileAddr

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


    ld      hl, (OS.currentProcessAddr)
    call    _DRAW_WINDOW

    ret

.maxProcessLimitReached:
    ; set nextAvailableProcessAddr to 0xffff, meaning no memory space available for new process
    ld      hl, 0xffff
    ld      (OS.nextAvailableProcessAddr), hl

    ret

; Input: nothing
; Output: nothing
;   IDX = next available process id (0 - MAX_PROCESS_ID-1), 255 means no process space available
_GET_NEXT_AVAILABLE_PROCESS_ID:

    ld      de, OS.processes_end
    ld      bc, Process_struct.size

    ld      ixh, 0          ; first process id to be searched

.outerLoop:
    ld      hl, OS.processes

.loop:
    ld      a, (hl)
    cp      ixh
    jp      z, .goToNext               ; process id found

    add     hl, bc          ; go to next process slot on memory

    ; check if process space ended
    call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    jp      c, .loop

    ; if processes id on ixh wasn't found, it is the next available
    ret

.goToNext:
    inc     ixh
    cp      MAX_PROCESS_ID + 1
    jp      nz, .outerLoop

    ; if searched for each possible process id on each processes slot, then OS max process limit was reached
    ld      idx, 255

    ret