; Common routines for MSX 2 (some work on MSX 1)
; v.0.1.0 (when changed remember to update file on other projects)

; Fill all RAM with 0x00
; TODO: this can be MUCH improved by using LDIR to fill a 
; range of bytes (e.g. 16 or 256), meaning there is a trade-off between speed and size
; PS. 16x 16 bytes LDIR can be a good solution

ClearRam:
    ld      hl, RamStart        ; RAM start address
    ld      de, RamEnd + 1      ; RAM end address

.loop:
    xor     a                   ; same as ld a, 0, but faster
    ld      (hl), a

    inc     hl
    call    BIOS_DCOMPR         ; Compare Contents Of HL & DE, Set Z-Flag IF (HL == DE), Set CY-Flag IF (HL < DE)
    ret     z
    jp      .loop



; Inputs:
;   HL: address
;   B:  size
ClearRamArea:
    xor     a
.loop:
    ld      (hl), a
    inc     hl
    djnz    .loop

    ret



; Input:
;   A: Color number
;   B: high nibble: red 0-7; low nibble: blue 0-7
;   C: high nibble: 0000; low nibble:  green 0-7
SetPaletteColor:
    push    bc
        ; set palette register number in register R#16 (Color palette address pointer)
        ld      b, a             ; data
        ld      c, 16            ; register #
        call    BIOS_WRTVDP
        ld      c, PORT_2        ; v9938 port #2
    pop     de

    ld      a, d                 ; data 1 (red 0-7; blue 0-7)
    di
    out     (c), a
    ld      a, e                 ; data 2 (0000; green 0-7)
    ei
    out     (c), a

    ret

; Input:
;   A: Color number
;   B: high nibble: red 0-7; low nibble: blue 0-7
;   C: high nibble: 0000; low nibble:  green 0-7
SetPaletteColor_Without_DI_EI:
    push    bc
        ; set palette register number in register R#16 (Color palette address pointer)
        ld      b, a             ; data
        ld      c, 16            ; register #
        call    WRTVDP_without_DI_EI
        ld      c, PORT_2        ; v9938 port #2
    pop     de

    ld      a, d                 ; data 1 (red 0-7; blue 0-7)
    ;di
    out     (c), a
    ld      a, e                 ; data 2 (0000; green 0-7)
    ;ei
    out     (c), a

    ret


; Input:
;   A: Color number
;   HL: address of color palette:
;       first byte:  high nibble: red 0-7; low nibble: blue 0-7
;       second byte: high nibble: 0000; low nibble:  green 0-7
SetPaletteColor_FromAddress:
    ; set palette register number in register R#16 (Color palette address pointer)
    ld      b, a                 ; data
    ld      c, 16                ; register #
    call    BIOS_WRTVDP
    ld      c, PORT_2            ; v9938 port #2

    ld      a, (hl)              ; data 1 (red 0-7; blue 0-7)
    di
    out     (c), a
    inc     hl
    ld      a, (hl)              ; data 2 (0000; green 0-7)
    ei
    out     (c), a

    ret



; Load palette data pointed by HL
LoadPalette:
    ; set palette register number in register R#16 (Color palette address pointer)
    ld      b, 0    ; data
    ld      c, 16   ; register #
    call    BIOS_WRTVDP
    ld      c, PORT_2 ; V9938 port #2

    ld      b, 16
.loop:
    di
        ld    a, (hl)
        out   (c), a
        inc   hl
        ld    a, (hl)
        out   (c), a
    ei
    inc     hl
    djnz    .loop
    
    ret



; Typical routine to select the ROM on page 8000h-BFFFh from page 4000h-7FFFh
EnableRomPage2:
; source: https://www.msx.org/wiki/Develop_a_program_in_cartridge_ROM#Typical_examples_to_make_a_32kB_ROM

	call	BIOS_RSLREG
	rrca
	rrca
	and	    3	;Keep bits corresponding to the page 4000h-7FFFh
	ld	    c,a
	ld	    b,0
	ld	    hl, BIOS_EXPTBL
	add	    hl,bc
	ld	    a,(hl)
	and	    80h
	or	    c
	ld	    c,a
	inc	    hl
	inc	    hl
	inc	    hl
	inc	    hl
	ld	    a,(hl)
	and	    0Ch
	or	    c
	ld	    h,080h
	call	BIOS_ENASLT		; Select the ROM on page 8000h-BFFFh

    ret


; Input:
;   B: number of VBlanks to wait
; Destroys:
;   A
Wait_B_Vblanks:
	
    push    bc
    
    .loop:

        ld      a, (BIOS_JIFFY)
        ld      c, a
    .waitVBlank:
        ld      a, (BIOS_JIFFY)
        cp      c
        jp      z, .waitVBlank

        djnz    .loop
    
    pop     bc

	ret

Wait_15_Vblanks:
	ld		c, 15

	.loop:
		ld      a, (BIOS_JIFFY)
		ld      b, a
	.waitVBlank:
		ld      a, (BIOS_JIFFY)
		cp      b
		jp      z, .waitVBlank

	dec		c
	jp		nz, .loop

    ret

Wait_Vblank:
.loop:
    ld      a, (BIOS_JIFFY)
    ld      b, a
.waitVBlank:
    ld      a, (BIOS_JIFFY)
    cp      b
    jp      z, .waitVBlank

    ret

;
; Set VDP address counter to write from address AHL (17-bit)
; Enables the interrupts
;
SetVdp_Write:

	; transform address from 
	;
	; |           Register A            |           Register H            |           Register L            |
	; | --- --- --- --- --- --- --- A16 | A15 A14 A13 A12 A11 A10  A9  A8 |  A7  A6  A5  A4  A3  A2  A1  A0 |
	;
	; to
	;
	; |           Register A            |           Register H            |           Register L            |
	; | --- --- --- --- --- A16 A15 A14 | --- --- A13 A12 A11 A10  A9  A8 |  A7  A6  A5  A4  A3  A2  A1  A0 |
    rlc     h
    rla
    rlc     h
    rla
    srl     h
    srl     h

    di
	    ; write bits a14-16 of address to R#14
	    out     (PORT_1), a
	    ld      a, 14 + 128
	    out     (PORT_1), a

	    ; write the other address bits to VDP PORT_1
	    ld      a, l
	    nop
	    out     (PORT_1), a
	    ld      a, h
	    or      64
    ei
    out     (PORT_1),a
    ret

;
; Set VDP address counter to read from address AHL (17-bit)
; Enables the interrupts
;
SetVdp_Read:
    rlc     h
    rla
    rlc     h
    rla
    srl     h
    srl     h
    di
    out     (PORT_1), a
    ld      a, 14 + 128
    out     (PORT_1), a
    ld      a, l
    nop
    out     (PORT_1), a
    ld      a, h
    ei
    out     (PORT_1), a
    ret


; TODO:
; ClearVram_MSX2:
;     ; clear VRAM
;     ; set address counter (bits 16 to 14)
;     ld      b, 0000 0000 b  ; data
;     ld      c, 6            ; register #
;     call    BIOS_WRTVDP

;     ; set address counter (bits 7 to 0)
;     ld      c, PORT_1
;     ld      a, 0000 0000 b
;     di
;     out     (c), a
;     ; set address counter (bits 13 to 8) and operation mode
;     ;           0: read, 1: write
;     ;           |
;     ld      a, 0100 0000 b
;     ei
;     out     (c), a
;     ; write to VRAM
;     xor     a
;     ld      b, 0 ;256 iterations
;     ld      c, PORT_0
; .loop:
;     di
;         out (c), a
;     ei
;     dec     b
;     jp      nz, .loop
	
; 	ret

; ClearVram_MSX2:

; 	ld		d, 7

; .loop:

;     ; set 3 upper bits of VRAM addr (bits 16 to 14)
;     ld      b, 1; d  			; data
;     ld      c, 14           ; register #
;     call    BIOS_WRTVDP

; 	; Set register #14
; 	; DI
; 	; LD    A, 1;d   ; Base adress #4000
; 	; OUT   (PORT_1), A
; 	; LD    A, 14 + 128 ; Write regster #14 (BIT 7 is set for writing)
; 	; OUT   (PORT_1), A
; 	; EI

; 	xor		a
; 	ld		hl, 0
; 	ld		bc, 16384 * 2
; 	call	BIOS_BIGFIL
; 	; dec		d
; 	; jp		nz, .loop


; 	ret


ClearVram_MSX2:
    xor     a           ; set vram write base address
    ld      hl, 0     	; to 1st byte of page 0
    call    SetVDP_Write

;     xor a
; FillL1:
;     ld c, 64          ; fill 1st 8 lines of page 1
; FillL2:
;     ld b, 0        ;
;     out (PORT_0),a     ; could also have been done with
;     djnz FillL2     ; a vdp command (probably faster)
;     dec c           ; (and could also use a fast loop)
;     jp nz,FillL1

	xor		a

    ; TODO: 
    ;   use VDP command (currently is taking almost 1 second)
    ;   disable screen/sprites (should I ??)

    ; clear all 128kb of VRAM
	ld		d, 2		; 2 repetitions
.loop_2:
	ld		c, 0		; 256 repetitions
.loop_1:
	ld		b, 0		; 256 repetitions
.loop:
	out		(PORT_0), a
	djnz	.loop
	dec		c
	jp		nz, .loop_1
	dec		d
	jp		nz, .loop_2

	ret


Screen11:
    ; change to screen 11
    ; it's needed to set screen 8 and change the YJK and YAE bits of R#25 manually
    ld      a, 8
    call    BIOS_CHGMOD

    ld      a, (REG25SAV)
    or      0001 1000 b
    ld      (REG25SAV), a   ; MSX 2+ VDP registers aren't guaranted to be saved by BIOS_WRTVDP routine
    ld      b, a
    ;ld      b, 0001 1000 b  ; data
    ld      c, 25            ; register #
    call    BIOS_WRTVDP
	ret

SetSprites16x16:
    ld      a, (REG1SAV)
    or      0000 0010 b
    ld      (REG1SAV), a
    ld      b, a
    ld      c, 1            ; register #
    call    BIOS_WRTVDP
	ret

Set192Lines:
    ; set 192 lines
    ; ld      b, 0000 0000 b  ; data
    ; ld      c, 9            ; register #
    ; call    BIOS_WRTVDP
    ld      a, (REG9SAV)
    and     0111 1111 b
    ld      (REG9SAV), a
    ld      b, a
    ld      c, 9            ; register #
    call    BIOS_WRTVDP
	ret

SetColor0ToNonTransparent:
    ; Das 16 cores da paleta, a cor 0 é transparente, ou seja, não pode
    ; ser definida uma cor para ela e qualquer objeto desenhado com ela não
    ; será visto. Entretanto, setando o bit 5 de R#8, a função de transparente
    ; será desativada e a cor 0 poderá ser definida por P#0.    
    ; set color 0 to non transparent
    ld      a, (REG8SAV)
    or      0010 0000 b
    ld      b, 0010 1000 b  ; data
    ld      c, 0x08         ; register #
    call    BIOS_WRTVDP
    ret

SetColor0ToTransparent:
    ; set color 0 to transparent
    ; ld      b, 0000 1000 b  ; data
    ; ld      c, 8            ; register #
    ; call    BIOS_WRTVDP
    ld      a, (REG8SAV)
    and     1101 1111 b
    ld      (REG8SAV), a
    ld      b, a
    ld      c, 8            ; register #
    call    BIOS_WRTVDP
	ret

DisableSprites:
    ld      a, (REG8SAV)
    or      0000 0010 b
    ld      b, a
    ld      c, 8            ; register #
    call    BIOS_WRTVDP
	ret

EnableSprites:
    ld      a, (REG8SAV)
    and     1111 1101 b
    ld      b, a
    ld      c, 8            ; register #
    call    BIOS_WRTVDP
	ret

; Inputs:
; 	HL: source addr in RAM
; 	ADE: 17 bits destiny addr in VRAM
; 	C: number of bytes x 256 (e.g. C=64, total = 64 * 256 = 16384)
LDIRVM_MSX2:
    ;ld      a, 0000 0000 b
    ex		de, hl
	;ld      hl, NAMTBL + (0 * (256 * 64))
    call    SetVdp_Write
    ex		de, hl
    ld      d, c
    ;ld      hl, ImageData_1
    ld      c, PORT_0        ; you can also write ld bc,#nn9B, which is faster
    ld      b, 0
.loop_1:
    otir
    dec     d
    jp      nz, .loop_1
	ret



;Random number generator:
; In: nothing
; Out: A with a random number
; Destroys: nothing
;Author: Ricardo Bittencourt aka RicBit (BrMSX, Tetrinet and several other projects)
; choose a random number in the set [0,255] with uniform distribution
RandomNumber:
    push    hl
        ld      hl, (Seed)
        add     hl, hl
        sbc     a, a
        and     0x83
        xor     l
        ld      l, a
        ld      (Seed), hl
    pop     hl
    ret

    ; The random number generated will be any number from 0 to FFh.
    ; Despite be a random number generator routine, your results will pass in several statistical tests.
    ; Before the first call, the SEED value must be initiated with a value different of 0.
    ; For a deterministic behavior (the sequence of values will be the same if the program was initiated), use a fixed SEED value.
    ; For a somewhat more random sequence, use:
    ; LD A,(JIFFY);MSX BIOS time variable
    ; OR 80H ;A value different of zero is granted
    ; LD A,(SEED)

    ; The values obtained from this method is much more *random* that what you get from LD A,R.



;  Calculates whether a collision occurs between two 16x16 objects
; IN: 
;    B = x1; C = y1
;    D = x2; E = y2
; OUT: Carry set if collision
; CHANGES: AF
CheckCollision_16x16_16x16:

        ld      a, d                        ; get x2
        sub     b                           ; calculate x2 - x1
        jr      c, .x1IsLarger              ; jump if x2 < x1
        sub     16                          ; compare with size 1
        ret     nc                          ; return if no collision
        jp      .checkVerticalCollision
.x1IsLarger:
        neg                                 ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ; ld      b, a
        ; xor     a                           ; same as ld a, 0
        ; sub     a, b
    
        sub     16                          ; compare with size 2
        ret     nc                          ; return if no collision

.checkVerticalCollision:
        ld      a, e                        ; get y2
        sub     c                           ; calculate y2 - y1
        jr      c, .y1IsLarger              ; jump if y2 < y1
        sub     16                          ; compare with size 1
        ret                                 ; return collision or no collision
.y1IsLarger:
        neg                                 ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ; ld      c, a
        ; xor     a                           ; same as ld a, 0
        ; sub     a, c
    
        sub     16                          ; compare with size 2
        ret                                 ; return collision or no collision



;  Calculates whether a collision occurs between a 16x16 object and a 32x16 object
; IN: 
;    B = x1; C = y1
;    D = x2; E = y2
; OUT: Carry set if collision
; CHANGES: AF
CheckCollision_16x16_32x16:

        ld      a, d                        ; get x2
        sub     b                           ; calculate x2 - x1
        jr      c, .x1IsLarger              ; jump if x2 < x1
        sub     16                          ; compare with size 1
        ret     nc                          ; return if no collision
        jp      .checkVerticalCollision
.x1IsLarger:
        neg                                 ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ; ld      b, a
        ; xor     a                           ; same as ld a, 0
        ; sub     a, b
    
        sub     32                          ; compare with size 2
        ret     nc                          ; return if no collision

.checkVerticalCollision:
        ld      a, e                        ; get y2
        sub     c                           ; calculate y2 - y1
        jr      c, .y1IsLarger              ; jump if y2 < y1
        sub     16                          ; compare with size 1
        ret                                 ; return collision or no collision
.y1IsLarger:
        neg                                 ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ; ld      c, a
        ; xor     a                           ; same as ld a, 0
        ; sub     a, c
    
        sub     16                          ; compare with size 2
        ret                                 ; return collision or no collision




;  Calculates whether a collision occurs between a 8x8 and a 16x16 object
; IN: 
;    B = x1; C = y1 (8x8 box)
;    D = x2; E = y2 (16x16 box)
; OUT: Carry set if collision
; CHANGES: AF
CheckCollision_8x8_16x16:

        ld      a, d                        ; get x2
        sub     b                           ; calculate x2 - x1
        jr      c, .x1IsLarger              ; jump if x2 < x1
        sub     8                          ; compare with size 1
        ret     nc                          ; return if no collision
        jp      .checkVerticalCollision
.x1IsLarger:
        neg                                 ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ; ld      b, a
        ; xor     a                           ; same as ld a, 0
        ; sub     a, b
    
        sub     16                          ; compare with size 2
        ret     nc                          ; return if no collision

.checkVerticalCollision:
        ld      a, e                        ; get y2
        sub     c                           ; calculate y2 - y1
        jr      c, .y1IsLarger              ; jump if y2 < y1
        sub     8                          ; compare with size 1
        ret                                 ; return collision or no collision
.y1IsLarger:
        neg                                 ; use negative value (Z80)
        ; emulate neg instruction (Gameboy)
        ; ld      c, a
        ; xor     a                           ; same as ld a, 0
        ; sub     a, c
    
        sub     16                          ; compare with size 2
        ret                                 ; return collision or no collision





; TODO: not working (use Dezog unit tests)

;  Calculates whether a collision occurs between a point and a 16x16 object
; IN: 
;    B = x1; C = y1 (point)
;    D = x2; E = y2 (16x16 box)
; OUT: Carry set if collision
; CHANGES: AF
CheckCollision_Point_16x16:

        ; cp b
        ; if (a >= b) NC
        ; if (a < b) C

        ; check X
        ld      a, d
        cp      b
        ret     nc      ; if (B <= D) ret             if (x1 <= x2) ret

        ld      a, b
        add     16      ; x1 = x1 + width2
        cp      d
        ret     nc      ; if (D <= B) ret             if (x2 <= (x1 + width2)) ret

        ; check Y
        ld      a, e
        cp      c
        ret     nc      ; if (C <= E) ret             if (y1 <= y2) ret

        ; if (a < b) C
        ; if (y1 < (y2 + height2)) C

        ld      a, e
        add     16
        ld      e, a
        ld      a, c
        cp      e
        ret

        ; C = 100 ; E = 98
        ; cp      98, 100         carry true
        ; cp      100, 98+16      carry true

        ; C = 120 ; E = 98
        ; cp      98, 120         carry true
        ; cp      120, 98+16      carry false

        ; C = 30 ; E = 32
        ; cp      32, 30         carry false

        ; C = 50 ; E = 32
        ; cp      32, 50         carry true
        ; cp      50, 32+16      carry false



; ; Fade from black screen to palette pointed by HL
; ; PS: early try, it's a bit strange, but I prefer to keep
; ; Official FadeIn routine is below
; FadeIn_Strange:

;     ; save destiny palette
;     ld      (FadeInDestinyPaletteAddr), hl

;     ; reset temp palette
;     ld      de, FadeInTempPalette
;     ld      b, FadeInTempPalette.size
;     xor     a
; .loop_ResetPalette:
;     ld      (de), a
;     inc     de
;     djnz    .loop_ResetPalette


;     ld      b, 7
; .loopPalette:
;     push    bc

;         ld      de, FadeInTempPalette
;         ld      b, 0 + (FadeInTempPalette.size / 2)

;         ; restore destiny palette
;         ld      hl, (FadeInDestinyPaletteAddr)

;         push    hl
;             push    de
;                 push    bc
;                     ex      de, hl
;                     call    LoadPalette
                    
;                     call    BIOS_ENASCR

;                     ld      b, 5
;                     call    Wait_B_Vblanks
;                 pop     bc
;             pop     de
;         pop     hl


;     ; loop through all temp palette incrementing each component (RGB) of each color
;     .loopColors:
;         push    bc

;             ;ld      ixh, b

;             push    hl
;                 push    de
;                     ; read from temp palette
;                     ld      a, (de)
;                     ld      b, a
;                     inc     de
;                     ld      a, (de)
;                     ld      c, a
                    
;                     ; ; set palette
;                     ; push    de
;                     ;     push    bc
;                     ;         ld      a, ixh
;                     ;         call    SetPaletteColor
;                     ;     pop     bc
;                     ; pop     de

;                     ; IYH = Red (0rrr 0000)
;                     ; get RED component
;                     ld      a, b
;                     and     0111 0000b
;                     ld      iyh, a

;                     ; compare with destiny palette
;                     ld      a, (hl)
;                     and     0111 0000b
;                     cp      iyh                       ; if (a >= n) NC      ; if (a < n) C
;                     ;ld      a, 
;                     jp      z, .dontIncrementRed

;                     ; increment RED
;                     ld      a, iyh
;                     ld      b, 0x10
;                     add     a, b
;                     ld      iyh, a

; .dontIncrementRed:


;                     ; IYL = Blue (0000 0bbb)
;                     ; get BLUE component
;                     dec     de
;                     ld      a, (de)
;                     and     0000 0111b
;                     ld      iyl, a

;                     ; compare with destiny palette
;                     ld      a, (hl)
;                     and     0000 0111b
;                     cp      iyl                       ; if (a >= n) NC      ; if (a < n) C
;                     jp      z, .dontIncrementBlue

;                     ; increment BLUE
;                     ;ld      a, iyl
;                     ; ld      b, 0x01
;                     ; add     a, b
;                     inc     iyl
;                     ;ld      iyh, a


; .dontIncrementBlue:

;                     ; save updated RED (IYH) and BLUE (IYL)
;                     ld      a, iyh
;                     or      iyl
;                     ld      (de), a




;                     ; B = Green
;                     ; get GREEN component
;                     inc     de
;                     ld      a, (de)
;                     and     0000 0111b
;                     ld      b, a

;                     ; compare with destiny palette
;                     inc     hl
;                     ld      a, (hl)
;                     and     0000 0111b
;                     cp      b                       ; if (a >= n) NC      ; if (a < n) C
;                     jp      z, .dontIncrementGreen

;                     ; increment GREEN
;                     inc     b

; .dontIncrementGreen:
;                     ; save updated GREEN
;                     ld      a, b
;                     ld      (de), a


;                 pop     de
;             pop     hl
            

;             ; increment pointers by 2
;             inc     hl
;             inc     hl
;             inc     de
;             inc     de



;         pop     bc
;         djnz    .loopColors



;     pop     bc
;     djnz    .loopPalette



;     ret



; CreateFadeInOutPalette:


;     ; reset 8 temp palettes
;     ld      de, FadeInTemp_8_Palettes
;     ld      b, 0 ; FadeInTemp_8_Palettes.size        ; B=0 for 256 iterations
;     xor     a
; .loop_ResetPalettes:
;     ld      (de), a
;     inc     de
;     djnz    .loop_ResetPalettes



;     ; copy game palette to first position in FadeInTemp_8_Palettes
;     ld      hl, GamePalette
;     ld      de, FadeInTemp_8_Palettes
;     ld      bc, 32
;     ldir


;     ld      hl, FadeInTemp_8_Palettes
;     ld      de, FadeInTemp_8_Palettes + 32



;     ld      b, 7
; .loop_Palettes:
;     push    bc


;         ld      b, 32
;     .loop_Colors:

;         ; high nibble
;         ld      c, 0
;         ld      a, (hl)
;         and     0111 0000b
;         or      a
;         jp      z, .skipHighNibble

;         ; decrement and save it to C
;         ld      c, 0x10
;         sub     a, c
;         ld      c, a

;     .skipHighNibble:

;         ; low nibble
;         ld      a, (hl)
;         and     0000 0111b
;         or      a
;         jp      z, .skipLowNibble

;         ; decrement and keep it in A
;         dec     a

;     .skipLowNibble:

;         ; join high and low nibbles and save it to destiny
;         or      c
;         ld      (de), a

;         ; next byte
;         inc     hl
;         inc     de

;         djnz    .loop_Colors

;     pop     bc
;     djnz    .loop_Palettes

;     ret


; FadeIn:
;     ld      hl, FadeInTemp_8_Palettes + (7 * 32)

;     ld      b, 8
; .loop:
;     push    bc
;         push    hl
;             call    LoadPalette
        
;             call    BIOS_ENASCR
;         pop    hl

;         ld      de, 32
;         or      a       ;clear carry flag
;         sbc     hl, de
        
;         ld      b, 5
;         call    Wait_B_Vblanks
;     pop     bc
;     djnz    .loop

;     ret



; FadeOut:
;     ld      hl, FadeInTemp_8_Palettes

;     ld      b, 8
; .loop:
;     push    bc
;         push    hl
;             call    LoadPalette
        
;             call    BIOS_ENASCR
;         pop    hl

;         ld      de, 32
;         add     hl, de
        
;         ld      b, 5
;         call    Wait_B_Vblanks
;     pop     bc
;     djnz    .loop

;     ret



; Fast DoCopy, by Grauw
;   Input:  HL = pointer to 15-byte VDP command data
;   Output: HL = updated
;   Destroys: A, B, C
Execute_VDP_LMMM:
Execute_VDP_HMMM:
    ld      a, 32           ; number of first register
    di
    out     (PORT_1), a
    ld      a, 17 + 128
    out     (PORT_1), a
    ld      c, 0x9B
.vdpReady:
    ld      a, 2
    di
    out     (PORT_1), a     ; select s#2
    ld      a, 15 + 128
    out     (PORT_1), a
    in      a, (PORT_1)
    rra
    ld      a, 0          ; back to s#0, enable ints
    out     (PORT_1), a
    ld      a, 15 + 128
    ei
    out     (PORT_1), a     ; loop if vdp not ready (CE)
    jp      c, .vdpReady
    outi            ; 15x OUTI
    outi            ; (faster than OTIR)
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    ret

;   Input:  HL = pointer to 11-byte VDP command data
;   Output: HL = updated
;   Destroys: A, B, C

Execute_VDP_PSET:
Execute_VDP_LINE:
Execute_VDP_HMMV:
    ld      a, 36           ; number of first register
    di
    out     (PORT_1), a
    ld      a, 17 + 128
    out     (PORT_1), a
    ld      c, 0x9B
.vdpReady:
    ld      a, 2
    di
    out     (PORT_1), a     ; select s#2
    ld      a, 15 + 128
    out     (PORT_1), a
    in      a, (PORT_1)
    rra
    ld      a, 0          ; back to s#0, enable ints
    out     (PORT_1), a
    ld      a, 15 + 128
    ei
    out     (PORT_1), a     ; loop if vdp not ready (CE)
    jp      c, .vdpReady
    outi            ; 11x OUTI
    outi            ; (faster than OTIR)
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    ret


;   Input:  HL = pointer to 13-byte VDP command data
;   Output: HL = updated
;   Destroys: A, B, C
Execute_VDP_YMMM:
    ld      a, 34           ; number of first register
    di
    out     (PORT_1), a
    ld      a, 17 + 128
    out     (PORT_1), a
    ld      c, 0x9B
.vdpReady:
    ld      a, 2
    di
    out     (PORT_1), a     ; select s#2
    ld      a, 15 + 128
    out     (PORT_1), a
    in      a, (PORT_1)
    rra
    ld      a, 0          ; back to s#0, enable ints
    out     (PORT_1), a
    ld      a, 15 + 128
    ei
    out     (PORT_1), a     ; loop if vdp not ready (CE)
    jp      c, .vdpReady
    outi            ; 13x OUTI
    outi            ; (faster than OTIR)
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    ret

VDP_COMMAND_HMMC:       equ 1111 0000 b	; High speed move CPU to VRAM (copies data from your ram to the vram)
VDP_COMMAND_YMMM:       equ 1110 0000 b	; High speed move VRAM to VRAM, Y coordinate only
VDP_COMMAND_HMMM:       equ 1101 0000 b	; High speed move VRAM to VRAM
VDP_COMMAND_HMMV:       equ 1100 0000 b	; High speed move VDP to VRAM (fills an area with one single color)

; Logical commands (four lower bits specifies logic operation)
VDP_COMMAND_LMMC:       equ 1011 0000 b	; Logical move CPU to VRAM (copies data from your ram to the vram)
VDP_COMMAND_LMCM:       equ 1010 0000 b	; Logical move VRAM to CPU
VDP_COMMAND_LMMM:       equ 1001 0000 b	; Logical move VRAM to VRAM
VDP_COMMAND_LMMV:       equ 1000 0000 b	; Logical move VDP to VRAM (fills an area with one single color)

VDP_COMMAND_LINE:       equ 0111 0000 b
VDP_COMMAND_SRCH:       equ 0110 0000 b
VDP_COMMAND_PSET:       equ 0101 0000 b
VDP_COMMAND_POINT:      equ 0100 0000 b

VDP_COMMAND_STOP:       equ 0000 0000 b


; Logical operations:
VDP_LOGIC_OPERATION_IMP:    equ 0000 b
VDP_LOGIC_OPERATION_AND:    equ 0001 b
VDP_LOGIC_OPERATION_OR:     equ 0010 b
VDP_LOGIC_OPERATION_XOR:    equ 0011 b
VDP_LOGIC_OPERATION_NOT:    equ 0100 b

VDP_LOGIC_OPERATION_TIMP:   equ 1000 b
VDP_LOGIC_OPERATION_TAND:   equ 1001 b
VDP_LOGIC_OPERATION_TOR:    equ 1010 b
VDP_LOGIC_OPERATION_TXOR:   equ 1011 b
VDP_LOGIC_OPERATION_TNOT:   equ 1100 b




; Routine to read a status register
  ; Input: B = Status register number to read (MSX2~)
  ; Output: B = Read value from the status register
  ; Modify: AF, BC
ReadStatusReg:
; -> Write the registre number in the r#15 (these 7 lines are specific MSX2 or newer)
	ld	a,(0007h)	; Main-ROM must be selected on page 0000h-3FFFh
	inc	a
	ld	c,a		; C = CPU port #99h (VDP writing port#1)
	;di		; Interrupts must be disabled here
	out	(c),b
	ld	a,080h+15
	out	(c),a
; <-
 
	ld	a,(0006h)	; Main-ROM must be selected on page 0000h-3FFFh
	inc	a
	ld	c,a		; C = CPU port #99h (VDP reading port#1)
	in	b,(c)	; read the value to the port#1
 
; -> Rewrite the registre number 0 in the r#15 (these 8 lines are specific MSX2 or newer)
	ld	a,(0007h)	; Main-ROM must be selected on page 0000h-3FFFh
	inc	a
	ld	c,a		; C = CPU port #99h (VDP writing port#1)
	xor	a
	out	(c),a
	ld	a,080h+15
	out	(c),a
	;ei		; Interrupts can be enabled here
; <-
	ret


; Write B value to C register
WRTVDP_without_DI_EI:
    ld 		a, b
    ;di
    out 	(PORT_1),a
    ld  	a, c
    or  	128
    ;ld 	a, regnr + 128
    ;ei
    out 	(PORT_1), a
    ret



; Alternative implementation of BIOS' SNSMAT without DI and EI
; param a/c: the keyboard matrix row to be read
; ret a: the keyboard matrix row read
SNSMAT_NO_DI_EI:
	ld	c, a
.C_OK:
; Initializes PPI.C value
	in	a, (PPI.C)
	and	0xf0 ; (keep bits 4-7)
	or	c
; Reads the keyboard matrix row
	out	(PPI.C), a
	in	a, (PPI.B)
	ret
