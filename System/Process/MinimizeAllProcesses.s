_MINIMIZE_ALL_PROCESSES:

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