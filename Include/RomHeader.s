; ROM header (Put 0000h as address when unused)
	db "AB"		; ID for auto-executable Rom at MSX start
	dw Execute	; Main program execution address.
	dw 0		; Execution address of a program whose purpose is to add
				; instructions to the MSX-Basic using the CALL statement.
	dw 0		; Execution address of a program used to control a device
				; built into the cartridge.
	dw 0		; Basic program pointer contained in ROM.
	dw 0, 0, 0	; Reserved
 
