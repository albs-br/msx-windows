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

    ; TODO
    ; set processId

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