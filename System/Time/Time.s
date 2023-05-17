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
    ld      (os.timeCounter), a
    cp      SYSTEM_HERTZ_RATE
    ret     nz

    ; reset timeCounter
    xor     a
    ld      (os.timeCounter), a

    ;ld      b, 0x01     ; 1 in BCD format

    ; update clock (add 1 second)
    ld      a, (OS.currentTime_Seconds)
    inc     a ;add     a, b
    daa
    ld      (OS.currentTime_Seconds), a

    ; update minute if seconds == 60
    cp      0x60
    ret     nz
    ld      a, (OS.currentTime_Minutes)
    inc     a ;add     a, b
    daa
    ld      (OS.currentTime_Minutes), a
    ; reset seconds
    xor     a
    ld      (OS.currentTime_Seconds), a

    ; update hour if minutes == 60
    ld      a, (OS.currentTime_Minutes)
    cp      0x60
    ret     nz
    ld      a, (OS.currentTime_Hours)
    inc     a
    daa

    cp      0x13 ; if (Hours == 0x13) hours = 0x00
    jp      nz, .not13Hours
    xor     a
.not13Hours:
    ld      (OS.currentTime_Hours), a
    ; reset minutes
    xor     a
    ld      (OS.currentTime_Minutes), a



    ret