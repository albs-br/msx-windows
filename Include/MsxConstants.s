PORT_0: equ 0x98
PORT_1: equ 0x99
PORT_2: equ 0x9a
PORT_3: equ 0x9b


; PPI (Programmable Peripheral Interface)
PPI.A: equ $a8 ; PPI port A: primary slot selection register
    ; 33221100: number of slot to select on page n
PPI.B: equ $a9 ; PPI port B: read the keyboard matrix row specified via the PPI port C ($AA)
PPI.C: equ $aa ; PPI port C: control keyboard CAP LED, data recorder signals, and keyboard matrix row
    ; bits 0-3: Row number of specified keyboard matrix to read via port B
    ; bit 4: Data recorder motor (reset to turn on)
    ; bit 5: Set to write on tape
    ; bit 6: Keyboard LED CAPS (reset to turn on)
    ; bit 7: 1, then 0 shortly thereafter to make a clicking sound (used for the keyboard)
PPI.R: equ $ab ; PPI ports control register (write only)
    ; bit 0 = Bit status to change
    ; bit 1-3 = Number of the bit to change at port C of the PPI
    ; bit 4-6 = Unused
    ; bit 7 = Must be always reset on MSX


;RG0SAV  equ     0F3DFH     ; from MSX BIOS disassembled source (https://sourceforge.net/projects/msxsyssrc/)
;
; list of VDP registers and corresponding system variables:
; https://www.msx.org/wiki/Category:VDP_Registers
REG0SAV: equ 0xF3DF
REG1SAV: equ 0xF3E0
REG2SAV: equ 0xF3E1
REG3SAV: equ 0xF3E2
REG4SAV: equ 0xF3E3
REG5SAV: equ 0xF3E4
REG6SAV: equ 0xF3E5
REG7SAV: equ 0xF3E6

REG8SAV: equ 0xFFE7
REG9SAV: equ 0xFFE8
REG10SAV: equ 0xFFE9
REG11SAV: equ 0xFFEA
REG12SAV: equ 0xFFEB
REG13SAV: equ 0xFFEC
REG14SAV: equ 0xFFED
REG15SAV: equ 0xFFEE
REG16SAV: equ 0xFFEF
REG17SAV: equ 0xFFF0
REG18SAV: equ 0xFFF1
REG19SAV: equ 0xFFF2
REG20SAV: equ 0xFFF3
REG21SAV: equ 0xFFF4
REG22SAV: equ 0xFFF5
REG23SAV: equ 0xFFF6

;REG24SAV doesn't exist

REG25SAV: equ 0xFFFA
REG26SAV: equ 0xFFFB
REG27SAV: equ 0xFFFC
