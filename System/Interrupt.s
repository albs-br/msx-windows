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
 
    ; OS.ticksSinceLastInput ++
    ld      hl, (OS.ticksSinceLastInput)
    inc     hl
    ld      (OS.ticksSinceLastInput), hl

    ; ; if (OS.ticksSinceLastInput == 3600) .triggerScreenSaver
    ; ld      de, 3600            ; 60 seconds (on NTSC machines...)
    ; call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    ; call    z, .triggerScreenSaver

    ; ---------------- read mouse ------------
	; ld      de, 0x1310 ; mouse on joyport 1
    ; ;ld      de, 0x6C20  ; mouse on joyport 2
    ld      de, MOUSE_PORT
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


    ; TODO: evaluate the possibility of saving mouse deltas and button states to OS vars and
    ; doing below processing outside interrupt (to keep interrupt as quick as possible)


    ; invert delta x
    ld      a, h
    neg
    ld      h, a

    ; invert delta y
	ld      a, l
    neg
    ld      l, a

    ; reset OS.ticksSinceLastInput if mouse moved or button clicked
    xor     a
    or      ixh ; mouse button 1
    or      ixl ; mouse button 2
    or      h   ; mouse delta x
    or      l   ; mouse delta y
    jp      z, .skip_1
    ld      de, 0
    ld      (OS.ticksSinceLastInput), de
.skip_1:
    
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

; TODO: show alert message "No mouse detected"
.noMouse:
    ; call    BIOS_BEEP
    ret

; .triggerScreenSaver:
;     ld      hl, NAMTBL
;     call    BIOS_SETWRT
;     ld      a, TILE_FONT_NUMBERS_0 + 0
;     out     (PORT_0), a
    
;     jp      $