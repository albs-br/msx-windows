FNAME "msx-windows.rom"      ; output file

PageSize:	    equ	0x4000	        ; 16kB

; Compilation address
    org 0x4000

    INCLUDE "../Include/RomHeader.s"
    INCLUDE "../Include/MsxBios.s"
    INCLUDE "../Include/MsxConstants.s"
    INCLUDE "../Include/CommonRoutines.s"


    INCLUDE "../System/Constants.s"

; Assets
    INCLUDE "../Fonts/Font_Normal.s"


; Apps
    INCLUDE "../Apps/Notepad/Header.s"
    ;INCLUDE "../Apps/Calc/Header.s"



Execute:
    ; define screen colors
    ld 		a, 15      	            ; Foreground color
    ld 		(BIOS_FORCLR), a    
    ld 		a, 1  		            ; Background color
    ld 		(BIOS_BAKCLR), a     
    ld 		a, 1      	            ; Border color
    ld 		(BIOS_BDRCLR), a    
    call 	BIOS_CHGCLR        		; Change Screen Color




    ; code here





    db      "End ROM started at 0x4000"

	ds PageSize - ($ - 0x4000), 255	; Fill the unused area with 0xff



; RAM
	org     0xc000, 0xe5ff

    ;INCLUDE "Ram.s"
