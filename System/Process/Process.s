    INCLUDE "System/Process/LoadProcess.s"
    INCLUDE "System/Process/SetCurrentProcess.s"
    INCLUDE "System/Process/CloseProcess.s"
    INCLUDE "System/Process/MinimizeProcess.s"



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
;   HL: addr of process slot, if available, HL = 0xffff if no process slot available
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

    ; if no process slot available return HL = 0xffff
    ld      hl, 0xffff

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


; ------------------------------- logic for ajust layer of processes:

; LoadProcess:
; get number of current processes and make it the layer number (0-3)


; CloseProcess:
; after removing the process from OS process slots decrease layer number of all processes with layer > L


; SetCurrentProcess:
; 
; 2
; 0   <-- new current
; 3
; 1

; 1
; 3
; 2
; 0

; ----

; 2
; 1   <-- new current
; 0
; 3

; 1
; 3
; 0
; 2

; set the new current layer to NUMBER_OF_PROCESSES
; dec layer of all processes with layer > old layer


; ; TODO: test:

; Decrease layer of all processes with layer > C
; Input:
;   C = layer number
_ADJUST_LAYER_OF_PROCESSES:

    ld      hl, OS.processes + PROCESS_STRUCT_IX.layer
    ld      de, Process_struct.size
    ld      b, MAX_PROCESS_ID + 1
.loop:
    ld      a, (hl)
    cp      0xff
    jp      z, .next ; if (A == 255) .next

    cp      c
    jp      c, .next ; if (C > A) .next

    ; if (C <= A) layer --
    dec     a
    ld      (hl), a

.next:
    add     hl, de

    djnz    .loop

    ret

