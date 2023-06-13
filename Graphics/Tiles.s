TILE_PATTERNS:

;---------------------- system tiles (windows, taskbar, etc) -------------------------

TILE_EMPTY: equ 0
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b

TILE_WINDOW_TITLE_TOP_LEFT: equ 1
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 01111111b
    DB 01111111b

TILE_WINDOW_TITLE_BOTTOM_LEFT: equ 2
    DB 01111111b
    DB 01111111b
    DB 01111111b
    DB 01111111b
    DB 01111111b
    DB 01111111b
    DB 01111111b
    DB 01111111b

TILE_WINDOW_TITLE_MIDDLE_TOP: equ 3
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 11111111b
    DB 11111111b

TILE_EMPTY_BLACK:                equ 4
TILE_WINDOW_TITLE_MIDDLE_BOTTOM: equ 4
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 11111111b

TILE_WINDOW_BORDER_LEFT: equ 5
    DB 01000000b
    DB 01000000b
    DB 01000000b
    DB 01000000b
    DB 01000000b
    DB 01000000b
    DB 01000000b
    DB 01000000b

TILE_WINDOW_BORDER_BOTTOM_LEFT: equ 6
    DB 01000000b
    DB 01000000b
    DB 01000000b
    DB 01111111b
    DB 00001111b
    DB 00001111b
    DB 00001111b
    DB 00000000b

TILE_WINDOW_BORDER_MIDDLE_BOTTOM: equ 7
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 00000000b

TILE_WINDOW_RESIZE_CORNER_LEFT: equ 8
    DB 00000001b
    DB 00000011b
    DB 00000110b
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 00000000b

TILE_WINDOW_RESIZE_CORNER_TOP: equ 9
    DB 00011110b
    DB 00011110b
    DB 00011110b
    DB 00011110b
    DB 00011110b
    DB 00111110b
    DB 01111110b
    DB 11011110b

TILE_WINDOW_RESIZE_CORNER_RIGHT: equ 10
    DB 10111110b
    DB 01111110b
    DB 11011110b
    DB 11111110b
    DB 11111110b
    DB 11111110b
    DB 11111110b
    DB 00000000b


TILE_WINDOW_MINIMIZE_BUTTON_PATTERN:
TILE_WINDOW_MINIMIZE_BUTTON: equ 11
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 11000001b
    DB 11000001b
    DB 11111111b
    DB 11111111b

TILE_WINDOW_MAXIMIZE_BUTTON_PATTERN:
TILE_WINDOW_MAXIMIZE_BUTTON: equ 12
    DB 11111111b
    DB 11000001b
    DB 11000001b
    DB 11011101b
    DB 11011101b
    DB 11000001b
    DB 11111111b
    DB 11111111b

TILE_WINDOW_CLOSE_BUTTON_PATTERN:
TILE_WINDOW_CLOSE_BUTTON: equ 13
    DB 11111111b
    DB 11011101b
    DB 11101011b
    DB 11110111b
    DB 11101011b
    DB 11011101b
    DB 11111111b
    DB 11111111b
    
TILE_WINDOW_TOP_RIGHT_CORNER_TOP: equ 14
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 11110000b
    DB 11110000b

TILE_WINDOW_TOP_RIGHT_CORNER_BOTTOM: equ 15
    DB 11110000b
    DB 11111110b
    DB 11111110b
    DB 11111110b
    DB 11111110b
    DB 11111110b
    DB 11111110b
    DB 11111110b

TILE_WINDOW_BORDER_RIGHT: equ 16
    DB 00011110b
    DB 00011110b
    DB 00011110b
    DB 00011110b
    DB 00011110b
    DB 00011110b
    DB 00011110b
    DB 00011110b

; TILE_WINDOW_TITLE_BOTTOM_LEFT_ACTIVE: equ 17
;     DB 01111111b
;     DB 01010101b
;     DB 01111111b
;     DB 01010101b
;     DB 01111111b
;     DB 01010101b
;     DB 01111111b
;     DB 01111111b

; -----------------

TILE_TASKBAR_TOP: equ 17
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 11111111 b
    DB 11111111 b

TILE_HOME_ICON: equ 18
    DB 11100111 b
    DB 11011011 b
    DB 10111101 b
    DB 01100110 b
    DB 11000011 b
    DB 10000001 b
    DB 10011001 b
    DB 10011001 b

TILE_SHOW_DESKTOP_ICON: equ 19
    DB 10011001 b
    DB 10111101 b
    DB 11111111 b
    DB 11111111 b
    DB 11111111 b
    DB 10111101 b
    DB 10011001 b
    DB 11111111 b

; -----------------

TILE_LINE_TOP_LEFT: equ 20
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00011111 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b

TILE_LINE_TOP_RIGHT: equ 21
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 11110000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b

TILE_LINE_MID_RIGHT: equ 22
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 11110000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b

TILE_LINE_BOTTOM_RIGHT: equ 23
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 11110000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b

TILE_LINE_BOTTOM_LEFT: equ 24
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00011111 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b

TILE_LINE_BOTTOM_MID: equ 25
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 11111111 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b

TILE_LINE_TOP_MID: equ 26
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 11111111 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b

TILE_LINE_MID_LEFT: equ 27
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00011111 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b

TILE_LINE_VERTICAL: equ 28
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b

TILE_LINE_MID_BOTTOM: equ 29
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 11111111 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b

TILE_LINE_HORIZONTAL: equ 30
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 11111111 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b

    ; ; 
    ; ; --- Slot 3
    ; ; color 1
    ; DB 00000000b
    ; DB 00000000b
    ; DB 00001000b
    ; DB 00011100b
    ; DB 00111110b
    ; DB 00000000b
    ; DB 00000000b
    ; DB 00000000b
    ; DB 00000000b
    ; DB 00000000b
    ; DB 00000000b
    ; DB 00111110b
    ; DB 00011100b
    ; DB 00001000b
    ; DB 00000000b
    ; DB 00000000b
    ; DB 00000000b
    ; DB 00001000b
    ; DB 00000000b
    ; DB 00000000b
    ; DB 00000000b
    ; DB 00001000b
    ; DB 00000000b
    ; DB 00000000b
    ; DB 00000000b
    ; DB 01111111b
    ; DB 01111111b
    ; DB 01111111b
    ; DB 01111111b
    ; DB 01111111b
    ; DB 01111111b
    ; DB 01111111b

; ------------------------ font ------------------------

BASE_INDEX_TILE_FONT: equ 31

TILE_FONT_REVERSED_PATTERNS:

; --- numbers reversed

TILE_FONT_REVERSED_NUMBERS_PATTERNS:

TILE_FONT_REVERSED_NUMBERS_0: equ BASE_INDEX_TILE_FONT + 0

    ; -------------------- char #16
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 01101110 b
    db 01110110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #17
    db 00000000 b
    db 00011000 b
    db 00111000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 01111110 b
    db 00000000 b
    ; -------------------- char #18
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 00001100 b
    db 00011000 b
    db 00110000 b
    db 01111110 b
    db 00000000 b
    ; -------------------- char #19
    db 00000000 b
    db 01111110 b
    db 00001100 b
    db 00011000 b
    db 00001100 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #20
    db 00000000 b
    db 00001100 b
    db 00011100 b
    db 00111100 b
    db 01101100 b
    db 01111110 b
    db 00001100 b
    db 00000000 b
    ; -------------------- char #21
    db 00000000 b
    db 01111110 b
    db 01100000 b
    db 01111100 b
    db 00000110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #22
    db 00000000 b
    db 00111100 b
    db 01100000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #23
    db 00000000 b
    db 01111110 b
    db 00000110 b
    db 00001100 b
    db 00011000 b
    db 00110000 b
    db 00110000 b
    db 00000000 b
    ; -------------------- char #24
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 00111100 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #25
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 00111110 b
    db 00000110 b
    db 00001100 b
    db 00111000 b
    db 00000000 b


; --- text lowercase reversed


TILE_FONT_REVERSED_LOWERCASE_PATTERNS:

TILE_FONT_REVERSED_LOWERCASE_A: equ TILE_FONT_REVERSED_NUMBERS_0 + 10

    ; -------------------- char #97
    db 00000000 b
    db 00000000 b
    db 00111100 b
    db 00000110 b
    db 00111110 b
    db 01100110 b
    db 00111110 b
    db 00000000 b
    ; -------------------- char #98
    db 00000000 b
    db 01100000 b
    db 01100000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 01111100 b
    db 00000000 b
    ; -------------------- char #99
    db 00000000 b
    db 00000000 b
    db 00111100 b
    db 01100000 b
    db 01100000 b
    db 01100000 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #100
    db 00000000 b
    db 00000110 b
    db 00000110 b
    db 00111110 b
    db 01100110 b
    db 01100110 b
    db 00111110 b
    db 00000000 b
    ; -------------------- char #101
    db 00000000 b
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 01111110 b
    db 01100000 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #102
    db 00000000 b
    db 00001110 b
    db 00011000 b
    db 00111110 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b
    ; -------------------- char #103
    db 00000000 b
    db 00000000 b
    db 00111110 b
    db 01100110 b
    db 01100110 b
    db 00111110 b
    db 00000110 b
    db 01111100 b
    ; -------------------- char #104
    db 00000000 b
    db 01100000 b
    db 01100000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #105
    db 00000000 b
    db 00011000 b
    db 00000000 b
    db 00111000 b
    db 00011000 b
    db 00011000 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #106
    db 00000000 b
    db 00000110 b
    db 00000000 b
    db 00000110 b
    db 00000110 b
    db 00000110 b
    db 00000110 b
    db 00111100 b
    ; -------------------- char #107
    db 00000000 b
    db 01100000 b
    db 01100000 b
    db 01101100 b
    db 01111000 b
    db 01101100 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #108
    db 00000000 b
    db 00111000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #109
    db 00000000 b
    db 00000000 b
    db 01100110 b
    db 01111111 b
    db 01111111 b
    db 01101011 b
    db 01100011 b
    db 00000000 b
    ; -------------------- char #110
    db 00000000 b
    db 00000000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #111
    db 00000000 b
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #112
    db 00000000 b
    db 00000000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 01111100 b
    db 01100000 b
    db 01100000 b
    ; -------------------- char #113
    db 00000000 b
    db 00000000 b
    db 00111110 b
    db 01100110 b
    db 01100110 b
    db 00111110 b
    db 00000110 b
    db 00000110 b
    ; -------------------- char #114
    db 00000000 b
    db 00000000 b
    db 01111100 b
    db 01100110 b
    db 01100000 b
    db 01100000 b
    db 01100000 b
    db 00000000 b
    ; -------------------- char #115
    db 00000000 b
    db 00000000 b
    db 00111110 b
    db 01100000 b
    db 00111100 b
    db 00000110 b
    db 01111100 b
    db 00000000 b
    ; -------------------- char #116
    db 00000000 b
    db 00011000 b
    db 01111110 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00001110 b
    db 00000000 b
    ; -------------------- char #117
    db 00000000 b
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00111110 b
    db 00000000 b
    ; -------------------- char #118
    db 00000000 b
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00011000 b
    db 00000000 b
    ; -------------------- char #119
    db 00000000 b
    db 00000000 b
    db 01100011 b
    db 01101011 b
    db 01111111 b
    db 00111110 b
    db 00110110 b
    db 00000000 b
    ; -------------------- char #120
    db 00000000 b
    db 00000000 b
    db 01100110 b
    db 00111100 b
    db 00011000 b
    db 00111100 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #121
    db 00000000 b
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00111110 b
    db 00001100 b
    db 01111000 b
    ; -------------------- char #122
    db 00000000 b
    db 00000000 b
    db 01111110 b
    db 00001100 b
    db 00011000 b
    db 00110000 b
    db 01111110 b
    db 00000000 b

TILE_FONT_REVERSED_LOWERCASE_PATTERNS.size: equ $ - TILE_FONT_REVERSED_LOWERCASE_PATTERNS


; ------ symbols reversed

TILE_FONT_REVERSED_SYMBOLS_PATTERNS:

TILE_FONT_REVERSED_SYMBOLS: equ TILE_FONT_REVERSED_LOWERCASE_A + 26

    ; -------------------- char #26
    db 00000000 b
    db 00000000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b

; -----


TILE_FONT_REVERSED_PATTERNS.SIZE: equ $ - TILE_FONT_REVERSED_PATTERNS


; -------------------------------

; --- numbers

TILE_FONT_NUMBERS_PATTERNS:

TILE_FONT_NUMBERS_0: equ TILE_FONT_REVERSED_SYMBOLS + 1

    ; -------------------- char #16
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 01101110 b
    db 01110110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #17
    db 00000000 b
    db 00011000 b
    db 00111000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 01111110 b
    db 00000000 b
    ; -------------------- char #18
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 00001100 b
    db 00011000 b
    db 00110000 b
    db 01111110 b
    db 00000000 b
    ; -------------------- char #19
    db 00000000 b
    db 01111110 b
    db 00001100 b
    db 00011000 b
    db 00001100 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #20
    db 00000000 b
    db 00001100 b
    db 00011100 b
    db 00111100 b
    db 01101100 b
    db 01111110 b
    db 00001100 b
    db 00000000 b
    ; -------------------- char #21
    db 00000000 b
    db 01111110 b
    db 01100000 b
    db 01111100 b
    db 00000110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #22
    db 00000000 b
    db 00111100 b
    db 01100000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #23
    db 00000000 b
    db 01111110 b
    db 00000110 b
    db 00001100 b
    db 00011000 b
    db 00110000 b
    db 00110000 b
    db 00000000 b
    ; -------------------- char #24
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 00111100 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #25
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 00111110 b
    db 00000110 b
    db 00001100 b
    db 00111000 b
    db 00000000 b



; --- text lowercase


TILE_FONT_LOWERCASE_PATTERNS:

TILE_FONT_LOWERCASE_A: equ TILE_FONT_NUMBERS_0 + 10

    ; -------------------- char #97
    db 00000000 b
    db 00000000 b
    db 00111100 b
    db 00000110 b
    db 00111110 b
    db 01100110 b
    db 00111110 b
    db 00000000 b
    ; -------------------- char #98
    db 00000000 b
    db 01100000 b
    db 01100000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 01111100 b
    db 00000000 b
    ; -------------------- char #99
    db 00000000 b
    db 00000000 b
    db 00111100 b
    db 01100000 b
    db 01100000 b
    db 01100000 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #100
    db 00000000 b
    db 00000110 b
    db 00000110 b
    db 00111110 b
    db 01100110 b
    db 01100110 b
    db 00111110 b
    db 00000000 b
    ; -------------------- char #101
    db 00000000 b
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 01111110 b
    db 01100000 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #102
    db 00000000 b
    db 00001110 b
    db 00011000 b
    db 00111110 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b
    ; -------------------- char #103
    db 00000000 b
    db 00000000 b
    db 00111110 b
    db 01100110 b
    db 01100110 b
    db 00111110 b
    db 00000110 b
    db 01111100 b
    ; -------------------- char #104
    db 00000000 b
    db 01100000 b
    db 01100000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #105
    db 00000000 b
    db 00011000 b
    db 00000000 b
    db 00111000 b
    db 00011000 b
    db 00011000 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #106
    db 00000000 b
    db 00000110 b
    db 00000000 b
    db 00000110 b
    db 00000110 b
    db 00000110 b
    db 00000110 b
    db 00111100 b
    ; -------------------- char #107
    db 00000000 b
    db 01100000 b
    db 01100000 b
    db 01101100 b
    db 01111000 b
    db 01101100 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #108
    db 00000000 b
    db 00111000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #109
    db 00000000 b
    db 00000000 b
    db 01100110 b
    db 01111111 b
    db 01111111 b
    db 01101011 b
    db 01100011 b
    db 00000000 b
    ; -------------------- char #110
    db 00000000 b
    db 00000000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #111
    db 00000000 b
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #112
    db 00000000 b
    db 00000000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 01111100 b
    db 01100000 b
    db 01100000 b
    ; -------------------- char #113
    db 00000000 b
    db 00000000 b
    db 00111110 b
    db 01100110 b
    db 01100110 b
    db 00111110 b
    db 00000110 b
    db 00000110 b
    ; -------------------- char #114
    db 00000000 b
    db 00000000 b
    db 01111100 b
    db 01100110 b
    db 01100000 b
    db 01100000 b
    db 01100000 b
    db 00000000 b
    ; -------------------- char #115
    db 00000000 b
    db 00000000 b
    db 00111110 b
    db 01100000 b
    db 00111100 b
    db 00000110 b
    db 01111100 b
    db 00000000 b
    ; -------------------- char #116
    db 00000000 b
    db 00011000 b
    db 01111110 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00001110 b
    db 00000000 b
    ; -------------------- char #117
    db 00000000 b
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00111110 b
    db 00000000 b
    ; -------------------- char #118
    db 00000000 b
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00011000 b
    db 00000000 b
    ; -------------------- char #119
    db 00000000 b
    db 00000000 b
    db 01100011 b
    db 01101011 b
    db 01111111 b
    db 00111110 b
    db 00110110 b
    db 00000000 b
    ; -------------------- char #120
    db 00000000 b
    db 00000000 b
    db 01100110 b
    db 00111100 b
    db 00011000 b
    db 00111100 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #121
    db 00000000 b
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00111110 b
    db 00001100 b
    db 01111000 b
    ; -------------------- char #122
    db 00000000 b
    db 00000000 b
    db 01111110 b
    db 00001100 b
    db 00011000 b
    db 00110000 b
    db 01111110 b
    db 00000000 b

;TILE_FONT_LOWERCASE_PATTERNS.size: equ $ - TILE_FONT_LOWERCASE_PATTERNS

; ------- text uppercase

TILE_FONT_UPPERCASE_PATTERNS:

TILE_FONT_UPPERCASE_A: equ TILE_FONT_LOWERCASE_A + 26

    ; -------------------- char #33
    db 00000000 b
    db 00011000 b
    db 00111100 b
    db 01100110 b
    db 01100110 b
    db 01111110 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #34
    db 00000000 b
    db 01111100 b
    db 01100110 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 01111100 b
    db 00000000 b
    ; -------------------- char #35
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 01100000 b
    db 01100000 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #36
    db 00000000 b
    db 01111000 b
    db 01101100 b
    db 01100110 b
    db 01100110 b
    db 01101100 b
    db 01111000 b
    db 00000000 b
    ; -------------------- char #37
    db 00000000 b
    db 01111110 b
    db 01100000 b
    db 01111100 b
    db 01100000 b
    db 01100000 b
    db 01111110 b
    db 00000000 b
    ; -------------------- char #38
    db 00000000 b
    db 01111110 b
    db 01100000 b
    db 01111100 b
    db 01100000 b
    db 01100000 b
    db 01100000 b
    db 00000000 b
    ; -------------------- char #39
    db 00000000 b
    db 00111110 b
    db 01100000 b
    db 01100000 b
    db 01101110 b
    db 01100110 b
    db 00111110 b
    db 00000000 b
    ; -------------------- char #40
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 01111110 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #41
    db 00000000 b
    db 01111110 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 01111110 b
    db 00000000 b
    ; -------------------- char #42
    db 00000000 b
    db 00000110 b
    db 00000110 b
    db 00000110 b
    db 00000110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #43
    db 00000000 b
    db 01100110 b
    db 01101100 b
    db 01111000 b
    db 01111000 b
    db 01101100 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #44
    db 00000000 b
    db 01100000 b
    db 01100000 b
    db 01100000 b
    db 01100000 b
    db 01100000 b
    db 01111110 b
    db 00000000 b
    ; -------------------- char #45
    db 00000000 b
    db 01100011 b
    db 01110111 b
    db 01111111 b
    db 01101011 b
    db 01100011 b
    db 01100011 b
    db 00000000 b
    ; -------------------- char #46
    db 00000000 b
    db 01100110 b
    db 01110110 b
    db 01111110 b
    db 01111110 b
    db 01101110 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #47
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #48
    db 00000000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 01111100 b
    db 01100000 b
    db 01100000 b
    db 00000000 b
    ; -------------------- char #49
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 01101100 b
    db 00110110 b
    db 00000000 b
    ; -------------------- char #50
    db 00000000 b
    db 01111100 b
    db 01100110 b
    db 01100110 b
    db 01111100 b
    db 01101100 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #51
    db 00000000 b
    db 00111100 b
    db 01100000 b
    db 00111100 b
    db 00000110 b
    db 00000110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #52
    db 00000000 b
    db 01111110 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b
    ; -------------------- char #53
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 01111110 b
    db 00000000 b
    ; -------------------- char #54
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00011000 b
    db 00000000 b
    ; -------------------- char #55
    db 00000000 b
    db 01100011 b
    db 01100011 b
    db 01101011 b
    db 01111111 b
    db 01110111 b
    db 01100011 b
    db 00000000 b
    ; -------------------- char #56
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00111100 b
    db 01100110 b
    db 01100110 b
    db 00000000 b
    ; -------------------- char #57
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 00111100 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b
    ; -------------------- char #58
    db 00000000 b
    db 01111110 b
    db 00001100 b
    db 00011000 b
    db 00110000 b
    db 01100000 b
    db 01111110 b
    db 00000000 b


TILE_PATTERNS.size: equ $ - TILE_PATTERNS

; TILE_PATTERNS.size: 0x410 (130 tiles)

; ----------------------------

; tile #: 189

TILE_MOUSE_OVER: equ TILE_BASE_DESKTOP_ICONS - 1

; ----------------------------

; tile #: 190-207

NUMBER_OF_TILES_PER_ICON: equ 9

TILE_BASE_DESKTOP_ICONS:    equ 190 ; TILE_BASE_INDEX_PROCESSES - (NUMBER_OF_TILES_PER_ICON * 2)

    TILE_BASE_DESKTOP_ICON_0:       equ TILE_BASE_DESKTOP_ICONS + (NUMBER_OF_TILES_PER_ICON * 0)
    TILE_BASE_DESKTOP_ICON_1:       equ TILE_BASE_DESKTOP_ICONS + (NUMBER_OF_TILES_PER_ICON * 1)

; ----------------------------

; tile #: 208-255

NUMBER_OF_TILES_RESERVED_PER_PROCESS: equ 12

TILE_BASE_INDEX_PROCESSES:      equ 208 ; 255 - ((MAX_PROCESS_ID + 1) * NUMBER_OF_TILES_RESERVED_PER_PROCESS)

    TILE_BASE_INDEX_PROCESS_0:      equ TILE_BASE_INDEX_PROCESSES + (NUMBER_OF_TILES_RESERVED_PER_PROCESS * 0)
    TILE_BASE_INDEX_PROCESS_1:      equ TILE_BASE_INDEX_PROCESSES + (NUMBER_OF_TILES_RESERVED_PER_PROCESS * 1)
    TILE_BASE_INDEX_PROCESS_2:      equ TILE_BASE_INDEX_PROCESSES + (NUMBER_OF_TILES_RESERVED_PER_PROCESS * 2)
    TILE_BASE_INDEX_PROCESS_3:      equ TILE_BASE_INDEX_PROCESSES + (NUMBER_OF_TILES_RESERVED_PER_PROCESS * 3)