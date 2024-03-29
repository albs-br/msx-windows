; Default VRAM tables for Screen 2
PATTBL:     equ 0x0000  ; to 0x17ff (6144 bytes)
NAMTBL:     equ 0x1800  ; to 0x1aff (768 bytes)
SPRATR:     equ 0x1b00  ; to 0x1b7f (128 bytes)

NAMTBL_ALT: equ 0x1c00  ; to 0x1eff (768 bytes)

COLTBL:     equ 0x2000  ; to 0x37ff (6144 bytes)
SPRPAT:     equ 0x3800  ; to 0x3fff (2048 bytes)



_INIT_VDP:


    ; define screen colors
    ld 		a, 15      	            ; Foreground color
    ld 		(BIOS_FORCLR), a    
    ld 		a, 1  		            ; Background color
    ld 		(BIOS_BAKCLR), a     
    ld 		a, 4      	            ; Border color
    ld 		(BIOS_BDRCLR), a    
    call 	BIOS_CHGCLR        		; Change Screen Color

    ;call    BIOS_INIGRP             ; screen 2
    ld      a, 2
    call    BIOS_CHGMOD

    call    SetSprites16x16

    ;                   1    1
    ;                   4    0 8 7       0
    ; NAMTBL_A: 0x1800 0001 1000 0000 0000 b
    ; NAMTBL_B: 0x1000 0001 0000 0000 0000 b
    ; set NAMTBL to 0x1800
	ld		c, 2	               		; VDP Register Number (0..27, 32..46)
	ld		b, 0000 0110 b   	        ; Data To Write
    call 	BIOS_WRTVDP        		    ; 


    call    BIOS_DISSCR

    
    ; --------------------- init VRAM -----------

    ; clear VRAM
    xor     a                   ; value
    ld      bc, 1024 * 16       ; size
    ld      hl, 0x0000          ; start VRAM address
    call    BIOS_FILVRM

    ; load PATTBL
    ld		hl, TILE_PATTERNS       ; RAM address (source)
    ld		de, PATTBL		        ; VRAM address (destiny)
    ld		bc, TILE_PATTERNS.size	; Block length
    call 	BIOS_LDIRVM        	    ; Block transfer to VRAM from memory

    ld		hl, TILE_PATTERNS       ; RAM address (source)
    ld		de, PATTBL + (256 * 8)  ; VRAM address (destiny)
    ld		bc, TILE_PATTERNS.size	; Block length
    call 	BIOS_LDIRVM        	    ; Block transfer to VRAM from memory

    ld		hl, TILE_PATTERNS       ; RAM address (source)
    ld		de, PATTBL + (512 * 8)  ; VRAM address (destiny)
    ld		bc, TILE_PATTERNS.size	; Block length
    call 	BIOS_LDIRVM        	    ; Block transfer to VRAM from memory

    ; fill COLTBL with black on white bg
    ld      a, 0x1f             ; value
    ld      bc, 256 * 8 * 3     ; size
    ld      hl, COLTBL          ; start VRAM address
    call    BIOS_FILVRM

    ; fill COLTBL for font reversed (first part)
    ld      a, 0xf1                                         ; value
    ld      bc, TILE_FONT_REVERSED_PATTERNS.size  ; size
    ld      hl, COLTBL + (TILE_FONT_REVERSED_PATTERNS - TILE_PATTERNS)         ; start VRAM address
    call    BIOS_FILVRM
    ; fill COLTBL for font reversed (second part)
    ld      a, 0xf1                                         ; value
    ld      bc, TILE_FONT_REVERSED_PATTERNS.size  ; size
    ld      hl, COLTBL + (256 * 8) + (TILE_FONT_REVERSED_PATTERNS - TILE_PATTERNS)         ; start VRAM address
    call    BIOS_FILVRM
    ; fill COLTBL for font reversed (third part)
    ld      a, 0xf1                                         ; value
    ld      bc, TILE_FONT_REVERSED_PATTERNS.size  ; size
    ld      hl, COLTBL + (512 * 8) + (TILE_FONT_REVERSED_PATTERNS - TILE_PATTERNS)         ; start VRAM address
    call    BIOS_FILVRM

    ; fill COLTBL for tiles filled with colors (first part)
    ld      hl, COLTBL + (TILE_FILLED_COLORS_PATTERNS - TILE_PATTERNS)         ; start VRAM address
    call    .fillTileColor


    ; fill COLTBL for tiles filled with colors (second part)
    ld      hl, COLTBL + (256 * 8) + (TILE_FILLED_COLORS_PATTERNS - TILE_PATTERNS)         ; start VRAM address
    call    .fillTileColor

    ; fill COLTBL for tiles filled with colors (third part)
    ld      hl, COLTBL + (512 * 8) + (TILE_FILLED_COLORS_PATTERNS - TILE_PATTERNS)         ; start VRAM address
    call    .fillTileColor



    ; load SPRPAT
    ld		hl, SPRITE_PATTERNS         ; RAM address (source)
    ld		de, SPRPAT		            ; VRAM address (destiny)
    ld		bc, SPRITE_PATTERNS.size    ; Block length
    call 	BIOS_LDIRVM        	        ; Block transfer to VRAM from memory


    call    BIOS_ENASCR

    ret

.fillTileColor:
    ld      d, 2
.loop_Colors:
    push    hl, de
        ; ld      a, 0x21                                         ; value
        sla     d ; shift left R; bit 7 -> C ; bit 0 -> 0
        sla     d ; shift left R; bit 7 -> C ; bit 0 -> 0
        sla     d ; shift left R; bit 7 -> C ; bit 0 -> 0
        sla     d ; shift left R; bit 7 -> C ; bit 0 -> 0

        ld      a, 0000 0001 b
        or      d

        ld      bc, 8
        call    BIOS_FILVRM
    pop     de, hl

    ld      bc, 8
    add     hl, bc

    inc     d
    ld      a, d
    cp      15
    jp      nz, .loop_Colors

    ret
