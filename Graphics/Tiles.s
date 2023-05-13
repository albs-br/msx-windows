TILE_PATTERNS:

;---------------------- window tiles -------------------------

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



TILE_WINDOW_MINIMIZE_BUTTON: equ 11
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 11111111b
    DB 11000001b
    DB 11000001b
    DB 11111111b
    DB 11111111b

TILE_WINDOW_MAXIMIZE_BUTTON: equ 12
    DB 11111111b
    DB 11000001b
    DB 11000001b
    DB 11011101b
    DB 11011101b
    DB 11000001b
    DB 11111111b
    DB 11111111b

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

BASE_INDEX_TILE_FONT: equ 17

TILE_FONT_REVERSED_LOWERCASE_PATTERNS:

TILE_FONT_REVERSED_LOWERCASE_A: equ BASE_INDEX_TILE_FONT + 0

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

TILE_PATTERNS.size: equ $ - TILE_PATTERNS