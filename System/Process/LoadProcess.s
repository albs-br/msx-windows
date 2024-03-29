; Input:
;   HL = addr of process header (on ROM)
_LOAD_PROCESS:

    ; if ((OS.nextAvailableProcessAddr) == 0xffff) alert('Max process limit exceeded')
    ld      de, (OS.nextAvailableProcessAddr)
    ld      a, 0xff
    cp      d
    jp      nz, .skip_0
    cp      e
    jp      z, .showAlertMaxProcessLimitReached
.skip_0:

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
    ld      bc, Process_struct.size_Header                      ; size
    ldir                                                        ; Copy BC bytes from HL to DE

    ; set current process to this
    ld      hl, (OS.nextAvailableProcessAddr)
    ld      (OS.currentProcessAddr), hl



    ; set processId
    ld      hl, (OS.currentProcessAddr)
    call    _GET_NEXT_AVAILABLE_PROCESS_ID
    ld      a, ixh
    cp      255
    jp      z, .maxProcessLimitReached
    ld      hl, (OS.currentProcessAddr)
    ld      (hl), a ; set ProcessId

    ; update next empty process slot to the next
    call    _GET_NEXT_AVAILABLE_PROCESS_ADDR
    ; inc     a   ; if (A == 255) .maxProcessLimitReached
    ; jp      z, .maxProcessLimitReached
    ld      (OS.nextAvailableProcessAddr), hl



    ld      ix, (OS.currentProcessAddr)

    ; define ramStartAddr and vramStartTile
    push    ix ; HL = IX
    pop     hl

    ld      de, OS.process_slot_0
    call    BIOS_DCOMPR
    jp      z, .isOnProcessSlot_0

    ld      de, OS.process_slot_1
    call    BIOS_DCOMPR
    jp      z, .isOnProcessSlot_1

    ld      de, OS.process_slot_2
    call    BIOS_DCOMPR
    jp      z, .isOnProcessSlot_2

    ld      de, OS.process_slot_3
    call    BIOS_DCOMPR
    jp      z, .isOnProcessSlot_3

    jp      .cont_1001

.isOnProcessSlot_0:
    ld      hl, OS.processesVariablesArea_0
    ld      a, TILE_BASE_INDEX_PROCESS_0
    jp      .saveRamStartAddr

.isOnProcessSlot_1:
    ld      hl, OS.processesVariablesArea_1
    ld      a, TILE_BASE_INDEX_PROCESS_1
    jp      .saveRamStartAddr

.isOnProcessSlot_2:
    ld      hl, OS.processesVariablesArea_2
    ld      a, TILE_BASE_INDEX_PROCESS_2
    jp      .saveRamStartAddr

.isOnProcessSlot_3:
    ld      hl, OS.processesVariablesArea_3
    ld      a, TILE_BASE_INDEX_PROCESS_3
    ; jp      .saveRamStartAddr

.saveRamStartAddr:
    ld      (ix + PROCESS_STRUCT_IX.ramStartAddr), l
    ld      (ix + PROCESS_STRUCT_IX.ramStartAddr + 1), h
    ld      (ix + PROCESS_STRUCT_IX.vramStartTile), a

.cont_1001:

    ; get number of current processes and make it the layer number (0-3)
    call    _GET_NUMBER_OF_PROCESSES_OPENED
    dec     a
    ld      (ix + PROCESS_STRUCT_IX.layer), a

    ld      a, WINDOW_STATE.RESTORED
    ld      (ix + PROCESS_STRUCT_IX.previousWindowState), a

    ; --- set x and y of window and
    ; --- update OS.nextWindow_x and y to the next
    ld      a, (OS.nextWindow_x)
    ; if (OS.nextWindow_x + process.width > 32) process.x = 0
    ld      b, (ix + PROCESS_STRUCT_IX.width)
    add     b
    cp      32 + 1
    jp      nc, .fixWidth
    ld      a, (OS.nextWindow_x)
    jp      .cont_200
.fixWidth:
    xor     a
.cont_200:
    ld      (ix + PROCESS_STRUCT_IX.x), a
    add     2
    ld      (OS.nextWindow_x), a

    ld      a, (OS.nextWindow_y)
    ; if (OS.nextWindow_y + process.height > 22) process.y = 0
    ld      b, (ix + PROCESS_STRUCT_IX.height)
    add     b
    cp      22 + 1
    jp      nc, .fixHeight
    ld      a, (OS.nextWindow_y)
    jp      .cont_100
.fixHeight:
    xor     a
.cont_100:
    ld      (ix + PROCESS_STRUCT_IX.y), a
    add     2
    ld      (OS.nextWindow_y), a
    cp      8
    call    nc, .resetNextWindow_XY ; if (A >= 8) .resetNextWindow_XY


    ; get RAM variables area of this process
    ld      l, (ix + PROCESS_STRUCT_IX.ramStartAddr)
    ld      h, (ix + PROCESS_STRUCT_IX.ramStartAddr + 1)

    push    hl ; IY = HL
    pop     iy

    ; call process "Open" event
    ; ld      hl, (OS.currentProcessAddr)
    ld      ix, (OS.currentProcessAddr)
    ld      e, (ix + PROCESS_STRUCT_IX.openAddr)         ; process.Open addr (low)
    ld      d, (ix + PROCESS_STRUCT_IX.openAddr + 1)     ; process.Open addr (high)
    call    JP_DE



    call    _UPDATE_SCREEN


    call    _DRAW_TASKBAR



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
    ; call BIOS_BEEP
    ; jp .showAlertMaxProcessLimitReached

    ret

.resetNextWindow_XY:
    xor     a
    ld      (OS.nextWindow_x), a
    ld      (OS.nextWindow_y), a

    ret

