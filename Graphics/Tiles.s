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

TILE_LINE_CROSS: equ 31
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 11111111 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b
    DB 00010000 b

TILE_LINE_BOTTOM_RIGHT_SHADOW: equ 32
    DB 00011110 b
    DB 00011110 b
    DB 00011110 b
    DB 11111110 b
    DB 11111110 b
    DB 11111110 b
    DB 11111110 b
    DB 00000000 b

TILE_ARROW_UP: equ 33
    DB 00000000b
    DB 00000000b
    DB 00001000b
    DB 00011100b
    DB 00111110b
    DB 00000000b
    DB 00000000b
    DB 00000000b

TILE_ARROW_DOWN: equ 34
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00111110b
    DB 00011100b
    DB 00001000b
    DB 00000000b
    DB 00000000b

TILE_DOTS_VERTICAL: equ 35
    DB 00000000b
    DB 00001000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00001000b
    DB 00000000b
    DB 00000000b

TILE_ARROW_RIGHT: equ 36
    DB 00000000b
    DB 00000000b
    DB 00010000b
    DB 00011000b
    DB 00011100b
    DB 00011000b
    DB 00010000b
    DB 00000000b

TILE_ARROW_LEFT: equ 37
    DB 00000000b
    DB 00000000b
    DB 00001000b
    DB 00011000b
    DB 00111000b
    DB 00011000b
    DB 00001000b
    DB 00000000b

TILE_DOTS_HORIZONTAL: equ 38
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00100010b
    DB 00000000b
    DB 00000000b
    DB 00000000b

    ; DB 00000000b
    ; DB 01111111b
    ; DB 01111111b
    ; DB 01111111b
    ; DB 01111111b
    ; DB 01111111b
    ; DB 01111111b
    ; DB 01111111b

TILE_CHECKBOX_UNCHECKED: equ 39
    DB 11111110 b
    DB 10000010 b
    DB 10000010 b
    DB 10000010 b
    DB 10000010 b
    DB 10000010 b
    DB 11111110 b
    DB 00000000 b

TILE_CHECKBOX_CHECKED: equ 40
    DB 11111110 b
    DB 11111010 b
    DB 11111010 b
    DB 10110110 b
    DB 11010110 b
    DB 11101110 b
    DB 11111110 b
    DB 00000000 b

; ------------------------ font ------------------------

BASE_INDEX_TILE_FONT: equ 41

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

TILE_FONT_REVERSED_LOWERCASE_B: equ TILE_FONT_REVERSED_LOWERCASE_A + 1
TILE_FONT_REVERSED_LOWERCASE_C: equ TILE_FONT_REVERSED_LOWERCASE_A + 2
TILE_FONT_REVERSED_LOWERCASE_D: equ TILE_FONT_REVERSED_LOWERCASE_A + 3
TILE_FONT_REVERSED_LOWERCASE_E: equ TILE_FONT_REVERSED_LOWERCASE_A + 4
TILE_FONT_REVERSED_LOWERCASE_F: equ TILE_FONT_REVERSED_LOWERCASE_A + 5
TILE_FONT_REVERSED_LOWERCASE_G: equ TILE_FONT_REVERSED_LOWERCASE_A + 6
TILE_FONT_REVERSED_LOWERCASE_H: equ TILE_FONT_REVERSED_LOWERCASE_A + 7
TILE_FONT_REVERSED_LOWERCASE_I: equ TILE_FONT_REVERSED_LOWERCASE_A + 8
TILE_FONT_REVERSED_LOWERCASE_J: equ TILE_FONT_REVERSED_LOWERCASE_A + 9
TILE_FONT_REVERSED_LOWERCASE_K: equ TILE_FONT_REVERSED_LOWERCASE_A + 10
TILE_FONT_REVERSED_LOWERCASE_L: equ TILE_FONT_REVERSED_LOWERCASE_A + 11
TILE_FONT_REVERSED_LOWERCASE_M: equ TILE_FONT_REVERSED_LOWERCASE_A + 12
TILE_FONT_REVERSED_LOWERCASE_N: equ TILE_FONT_REVERSED_LOWERCASE_A + 13
TILE_FONT_REVERSED_LOWERCASE_O: equ TILE_FONT_REVERSED_LOWERCASE_A + 14
TILE_FONT_REVERSED_LOWERCASE_P: equ TILE_FONT_REVERSED_LOWERCASE_A + 15
TILE_FONT_REVERSED_LOWERCASE_Q: equ TILE_FONT_REVERSED_LOWERCASE_A + 16
TILE_FONT_REVERSED_LOWERCASE_R: equ TILE_FONT_REVERSED_LOWERCASE_A + 17
TILE_FONT_REVERSED_LOWERCASE_S: equ TILE_FONT_REVERSED_LOWERCASE_A + 18
TILE_FONT_REVERSED_LOWERCASE_T: equ TILE_FONT_REVERSED_LOWERCASE_A + 19
TILE_FONT_REVERSED_LOWERCASE_U: equ TILE_FONT_REVERSED_LOWERCASE_A + 20
TILE_FONT_REVERSED_LOWERCASE_V: equ TILE_FONT_REVERSED_LOWERCASE_A + 21
TILE_FONT_REVERSED_LOWERCASE_W: equ TILE_FONT_REVERSED_LOWERCASE_A + 22
TILE_FONT_REVERSED_LOWERCASE_X: equ TILE_FONT_REVERSED_LOWERCASE_A + 23
TILE_FONT_REVERSED_LOWERCASE_Y: equ TILE_FONT_REVERSED_LOWERCASE_A + 24
TILE_FONT_REVERSED_LOWERCASE_Z: equ TILE_FONT_REVERSED_LOWERCASE_A + 25

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

TILE_FONT_LOWERCASE_B: equ TILE_FONT_LOWERCASE_A + 1
TILE_FONT_LOWERCASE_C: equ TILE_FONT_LOWERCASE_A + 2
TILE_FONT_LOWERCASE_D: equ TILE_FONT_LOWERCASE_A + 3
TILE_FONT_LOWERCASE_E: equ TILE_FONT_LOWERCASE_A + 4
TILE_FONT_LOWERCASE_F: equ TILE_FONT_LOWERCASE_A + 5
TILE_FONT_LOWERCASE_G: equ TILE_FONT_LOWERCASE_A + 6
TILE_FONT_LOWERCASE_H: equ TILE_FONT_LOWERCASE_A + 7
TILE_FONT_LOWERCASE_I: equ TILE_FONT_LOWERCASE_A + 8
TILE_FONT_LOWERCASE_J: equ TILE_FONT_LOWERCASE_A + 9
TILE_FONT_LOWERCASE_K: equ TILE_FONT_LOWERCASE_A + 10
TILE_FONT_LOWERCASE_L: equ TILE_FONT_LOWERCASE_A + 11
TILE_FONT_LOWERCASE_M: equ TILE_FONT_LOWERCASE_A + 12
TILE_FONT_LOWERCASE_N: equ TILE_FONT_LOWERCASE_A + 13
TILE_FONT_LOWERCASE_O: equ TILE_FONT_LOWERCASE_A + 14
TILE_FONT_LOWERCASE_P: equ TILE_FONT_LOWERCASE_A + 15
TILE_FONT_LOWERCASE_Q: equ TILE_FONT_LOWERCASE_A + 16
TILE_FONT_LOWERCASE_R: equ TILE_FONT_LOWERCASE_A + 17
TILE_FONT_LOWERCASE_S: equ TILE_FONT_LOWERCASE_A + 18
TILE_FONT_LOWERCASE_T: equ TILE_FONT_LOWERCASE_A + 19
TILE_FONT_LOWERCASE_U: equ TILE_FONT_LOWERCASE_A + 20
TILE_FONT_LOWERCASE_V: equ TILE_FONT_LOWERCASE_A + 21
TILE_FONT_LOWERCASE_W: equ TILE_FONT_LOWERCASE_A + 22
TILE_FONT_LOWERCASE_X: equ TILE_FONT_LOWERCASE_A + 23
TILE_FONT_LOWERCASE_Y: equ TILE_FONT_LOWERCASE_A + 24
TILE_FONT_LOWERCASE_Z: equ TILE_FONT_LOWERCASE_A + 25

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

TILE_FONT_UPPERCASE_B: equ TILE_FONT_UPPERCASE_A + 1
TILE_FONT_UPPERCASE_C: equ TILE_FONT_UPPERCASE_A + 2
TILE_FONT_UPPERCASE_D: equ TILE_FONT_UPPERCASE_A + 3
TILE_FONT_UPPERCASE_E: equ TILE_FONT_UPPERCASE_A + 4
TILE_FONT_UPPERCASE_F: equ TILE_FONT_UPPERCASE_A + 5
TILE_FONT_UPPERCASE_G: equ TILE_FONT_UPPERCASE_A + 6
TILE_FONT_UPPERCASE_H: equ TILE_FONT_UPPERCASE_A + 7
TILE_FONT_UPPERCASE_I: equ TILE_FONT_UPPERCASE_A + 8
TILE_FONT_UPPERCASE_J: equ TILE_FONT_UPPERCASE_A + 9
TILE_FONT_UPPERCASE_K: equ TILE_FONT_UPPERCASE_A + 10
TILE_FONT_UPPERCASE_L: equ TILE_FONT_UPPERCASE_A + 11
TILE_FONT_UPPERCASE_M: equ TILE_FONT_UPPERCASE_A + 12
TILE_FONT_UPPERCASE_N: equ TILE_FONT_UPPERCASE_A + 13
TILE_FONT_UPPERCASE_O: equ TILE_FONT_UPPERCASE_A + 14
TILE_FONT_UPPERCASE_P: equ TILE_FONT_UPPERCASE_A + 15
TILE_FONT_UPPERCASE_Q: equ TILE_FONT_UPPERCASE_A + 16
TILE_FONT_UPPERCASE_R: equ TILE_FONT_UPPERCASE_A + 17
TILE_FONT_UPPERCASE_S: equ TILE_FONT_UPPERCASE_A + 18
TILE_FONT_UPPERCASE_T: equ TILE_FONT_UPPERCASE_A + 19
TILE_FONT_UPPERCASE_U: equ TILE_FONT_UPPERCASE_A + 20
TILE_FONT_UPPERCASE_V: equ TILE_FONT_UPPERCASE_A + 21
TILE_FONT_UPPERCASE_W: equ TILE_FONT_UPPERCASE_A + 22
TILE_FONT_UPPERCASE_X: equ TILE_FONT_UPPERCASE_A + 23
TILE_FONT_UPPERCASE_Y: equ TILE_FONT_UPPERCASE_A + 24
TILE_FONT_UPPERCASE_Z: equ TILE_FONT_UPPERCASE_A + 25

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

; ------ symbols

TILE_FONT_SYMBOLS_PATTERNS:

TILE_FONT_SYMBOLS: equ TILE_FONT_UPPERCASE_A + 26

TILE_EXCLAMATION: equ TILE_FONT_SYMBOLS + 0
    db 00000000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b
    db 00011000 b
    db 00000000 b

TILE_DOUBLE_QUOTE: equ TILE_FONT_SYMBOLS + 1
    db 00000000 b
    db 01100110 b
    db 01100110 b
    db 01100110 b
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00000000 b

TILE_PERCENT: equ TILE_FONT_SYMBOLS + 2
    db 00000000 b
    db 01100110 b
    db 01101100 b
    db 00011000 b
    db 00110000 b
    db 01100110 b
    db 01000110 b
    db 00000000 b

TILE_SINGLE_QUOTE: equ TILE_FONT_SYMBOLS + 3
    db 00000000 b
    db 00011000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00000000 b

TILE_OPEN_ROUND_BRACKETS: equ TILE_FONT_SYMBOLS + 4
    db 00000000 b
    db 00001110 b
    db 00011100 b
    db 00011000 b
    db 00011000 b
    db 00011100 b
    db 00001110 b
    db 00000000 b

TILE_CLOSE_ROUND_BRACKETS: equ TILE_FONT_SYMBOLS + 5
    db 00000000 b
    db 01110000 b
    db 00111000 b
    db 00011000 b
    db 00011000 b
    db 00111000 b
    db 01110000 b
    db 00000000 b

TILE_STAR: equ TILE_FONT_SYMBOLS + 6
    db 00000000 b
    db 01100110 b
    db 00111100 b
    db 11111111 b
    db 00111100 b
    db 01100110 b
    db 00000000 b
    db 00000000 b

TILE_PLUS: equ TILE_FONT_SYMBOLS + 7
    db 00000000 b
    db 00011000 b
    db 00011000 b
    db 01111110 b
    db 00011000 b
    db 00011000 b
    db 00000000 b
    db 00000000 b

TILE_COMMA: equ TILE_FONT_SYMBOLS + 8
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00011000 b
    db 00011000 b
    db 00110000 b

TILE_MINUS: equ TILE_FONT_SYMBOLS + 9
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 01111110 b
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00000000 b

TILE_DOT: equ TILE_FONT_SYMBOLS + 10
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b

TILE_SLASH: equ TILE_FONT_SYMBOLS + 11
    db 00000000 b
    db 00000110 b
    db 00001100 b
    db 00011000 b
    db 00110000 b
    db 01100000 b
    db 01000000 b
    db 00000000 b

TILE_COLON: equ TILE_FONT_SYMBOLS + 12
    db 00000000 b
    db 00000000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b

TILE_SEMICOLON: equ TILE_FONT_SYMBOLS + 13
    db 00000000 b
    db 00000000 b
    db 00011000 b
    db 00011000 b
    db 00000000 b
    db 00011000 b
    db 00011000 b
    db 00110000 b
    ; -------------------- char #28
    db 00000110 b
    db 00001100 b
    db 00011000 b
    db 00110000 b
    db 00011000 b
    db 00001100 b
    db 00000110 b
    db 00000000 b

TILE_EQUAL: equ TILE_FONT_SYMBOLS + 15
    db 00000000 b
    db 00000000 b
    db 01111110 b
    db 00000000 b
    db 00000000 b
    db 01111110 b
    db 00000000 b
    db 00000000 b
    ; -------------------- char #30
    db 01100000 b
    db 00110000 b
    db 00011000 b
    db 00001100 b
    db 00011000 b
    db 00110000 b
    db 01100000 b
    db 00000000 b
    ; -------------------- char #31
    db 00000000 b
    db 00111100 b
    db 01100110 b
    db 00001100 b
    db 00011000 b
    db 00000000 b
    db 00011000 b
    db 00000000 b
    ; -------------------- char #32
    db 00011000 b
    db 00111100 b
    db 01100000 b
    db 00111100 b
    db 00000110 b
    db 00000110 b
    db 00111100 b
    db 00000000 b
    ; -------------------- char #60
    db 00000000 b
    db 01000000 b
    db 01100000 b
    db 00110000 b
    db 00011000 b
    db 00001100 b
    db 00000110 b
    db 00000000 b
    ; -------------------- char #62
    db 00000000 b
    db 00001000 b
    db 00011100 b
    db 00110110 b
    db 01100011 b
    db 00000000 b
    db 00000000 b
    db 00000000 b
    ; -------------------- char #63
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 00000000 b
    db 11111111 b
    db 00000000 b

; ------ coloured tiles filled

TILE_FILLED_COLORS_PATTERNS:

TILE_FILLED_COLORS: equ TILE_FONT_SYMBOLS + 22

TILE_COLOR_1: equ TILE_EMPTY_BLACK

TILE_COLOR_2: equ TILE_FILLED_COLORS + 0
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_3: equ TILE_FILLED_COLORS + 1
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_4: equ TILE_FILLED_COLORS + 2
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_5: equ TILE_FILLED_COLORS + 3
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_6: equ TILE_FILLED_COLORS + 4
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_7: equ TILE_FILLED_COLORS + 5
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_8: equ TILE_FILLED_COLORS + 6
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_9: equ TILE_FILLED_COLORS + 7
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_10: equ TILE_FILLED_COLORS + 8
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_11: equ TILE_FILLED_COLORS + 9
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_12: equ TILE_FILLED_COLORS + 10
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_13: equ TILE_FILLED_COLORS + 11
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_14: equ TILE_FILLED_COLORS + 12
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b
    db 11111111 b

TILE_COLOR_15: equ TILE_EMPTY

;----

TILE_PATTERNS.size: equ $ - TILE_PATTERNS

; TILE_PATTERNS.size: 0x578 (175 tiles)

; tiles available: 189 - 175 = 24

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
