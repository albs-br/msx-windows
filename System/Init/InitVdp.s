; Default VRAM tables for Screen 2
NAMTBL:     equ 0x1800  ; to 0x1aff (768 bytes)
PATTBL:     equ 0x0000  ; to 0x17ff (6144 bytes)
COLTBL:     equ 0x2000  ; to 0x37ff (6144 bytes)
SPRPAT:     equ 0x3800  ; to 0x3fff (2048 bytes)
SPRATR:     equ 0x1b00  ; to 0x1b7f (128 bytes)


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

    ; fill COLTBL 
    ld      a, 0x1f             ; value
    ld      bc, 256 * 8 * 3     ; size
    ld      hl, COLTBL          ; start VRAM address
    call    BIOS_FILVRM

    ; load NAMTBL
    ld		hl, NAMTBL_TEST       ; RAM address (source)
    ld		de, NAMTBL		        ; VRAM address (destiny)
    ld		bc, NAMTBL_TEST.size	; Block length
    call 	BIOS_LDIRVM        	    ; Block transfer to VRAM from memory

    call    BIOS_ENASCR

    ret

NAMTBL_TEST:
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    
    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_WINDOW_TITLE_TOP_LEFT
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TOP_RIGHT_CORNER_TOP
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_WINDOW_TITLE_BOTTOM_LEFT
    db TILE_WINDOW_TITLE_MIDDLE_BOTTOM
    db TILE_WINDOW_MINIMIZE_BUTTON
    db TILE_WINDOW_MAXIMIZE_BUTTON
    db TILE_WINDOW_CLOSE_BUTTON
    db TILE_WINDOW_TOP_RIGHT_CORNER_BOTTOM
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_WINDOW_BORDER_LEFT
    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_WINDOW_BORDER_RIGHT
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_WINDOW_BORDER_LEFT
    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_WINDOW_BORDER_RIGHT
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_WINDOW_BORDER_LEFT
    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_WINDOW_RESIZE_CORNER_TOP
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    db TILE_EMPTY
    db TILE_EMPTY
    db TILE_WINDOW_BORDER_BOTTOM_LEFT
    db TILE_WINDOW_BORDER_MIDDLE_BOTTOM
    db TILE_WINDOW_BORDER_MIDDLE_BOTTOM
    db TILE_WINDOW_BORDER_MIDDLE_BOTTOM
    db TILE_WINDOW_RESIZE_CORNER_LEFT
    db TILE_WINDOW_RESIZE_CORNER_RIGHT
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.size: equ $ - NAMTBL_TEST