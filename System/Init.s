_INIT:
    ; define screen colors
    ld 		a, 15      	            ; Foreground color
    ld 		(BIOS_FORCLR), a    
    ld 		a, 10  		            ; Background color
    ld 		(BIOS_BAKCLR), a     
    ld 		a, 13      	            ; Border color
    ld 		(BIOS_BDRCLR), a    
    call 	BIOS_CHGCLR        		; Change Screen Color

    call    BIOS_INIGRP
    

    call    BIOS_DISSCR
    
    ; --------------------- init VRAM -----------

    ; load PATTBL
    ; load COLTBL
    ; load NAMTBL

    call    BIOS_ENASCR

    ret