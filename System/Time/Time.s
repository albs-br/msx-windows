_INIT_SYSTEM_TIME:

    xor     a

    ld      (os.timeCounter), a

    ; reset system clock (3 bytes)
    ld      hl, os.currentTime
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a

    ; reset system date (3 bytes)
    ld      hl, OS.currentDate
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a

    ret



SYSTEM_HERTZ_RATE: equ 60 ; or 50

_UPDATE_SYSTEM_TIME:

    ld      a, (os.timeCounter)
    inc     a
    cp      SYSTEM_HERTZ_RATE
    jp      nz, .dontUpdate



    ; update clock (add 1 second)
    ld      b, 0x01     ; 1 second in BCD format
    ld      a, (OS.currentTime_Seconds)
    add     a, b
    daa
    ld      (OS.currentTime_Seconds), a

    ; update minute
    ;cp      0x60

    ; reset timeCounter
    xor     a

.dontUpdate:
    ld      (os.timeCounter), a

    ret