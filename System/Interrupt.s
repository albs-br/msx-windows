_INIT_INTERRUPT:

    ; Setup interrupt hook
    xor     a
    ld      (os.interruptBusy), a

    ld      hl, .storeOldInterruptHook_init
    ld      de, os.storeOldInterruptHook
    ld      bc, 6
    ldir

    ld      hl, BIOS_H_TIMI
    ld      de, os.storeOldInterruptHook
    ld      bc, 5
    ldir

    ld      hl, INTERRUPT
    ld      de, BIOS_H_TIMI
    ld      bc, 3
    ldir

    ret



.storeOldInterruptHook_init:
    db 0, 0, 0, 0, 0
    db 0xc9 ; opcode for RET

INTERRUPT:
    ; This will be copied to interrupt hook
    jp      HANDLER
 
HANDLER:
    ; This is actual interrupt handler routine
    ld      a, (os.interruptBusy)
    and     a
    ret     nz
    ld      a, 255
    ld      (os.interruptBusy), a

    ; update system time
    call    _UPDATE_SYSTEM_TIME
 
    ; ---------------- read mouse ------------
	ld      de, 0x1310 ; mouse on joyport 1
    ;ld      de, 0x6C20  ; mouse on joyport 2
    call    GTMOUS
    ; if (H==255 && H==L) noMouse
    ld      a, h
    cp      255
    jp      nz, .skip
    cp      l
    call    z, .noMouse

.skip:

    ; update mouse buttons state
    ld      a, ixh
    ld      (OS.mouseButton_1), a
    ld      a, ixl
    ld      (OS.mouseButton_2), a


    ; invert delta x
    ld      a, h
    neg
    ld      h, a

    ; invert delta y
	ld      a, l
    neg
    ld      l, a
    
    ld      e, h ; delta X
    ld      d, l ; delta Y
    ld      a, (os.mouseX)
    ld      l, a ; current X
    ld      a, (os.mouseY)
    ld      h, a ; current Y
    call    CLIPADD
    
    ld      a, l
    ld      (os.mouseX), a
    ld      (os.mouseX_1), a
    ld      a, h
    ld      (os.mouseY), a
    ld      (OS.mouseY_1), a

    xor     a
    ld      (os.interruptBusy), a

    jp      os.storeOldInterruptHook

.noMouse:
	;ld     a, 65
    ;call   CHPUT
    call    BIOS_BEEP
    ret

