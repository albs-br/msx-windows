    INCLUDE "System/Process/LoadProcess.s"
    INCLUDE "System/Process/CloseProcess.s"



MAX_PROCESS_ID: equ 3 ; max 4 processes available (maybe 6 in the future)



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



; Input: nothing
; Output:
;   A: number of processes currently opened
_GET_NUMBER_OF_PROCESSES_OPENED:

    ld      hl, OS.processes
    ld      de, Process_struct.size
    ld      b, MAX_PROCESS_ID + 1
    xor     a ; number of processes counter
.loop:
    ld      c, (hl)
    ; process id = 255 means that this process slot is available
    inc     c       ; if (C == 255) next
    jp      z, .next

    ; process found, increment counter
    inc     a

.next:
    add     hl, de

    djnz    .loop

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
    ; place tile on window title to show it is the active window

    ; TODO
    ; call "Draw" event of the process

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