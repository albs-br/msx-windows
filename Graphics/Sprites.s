SPRITE_PATTERNS:

SPRITE_CURSOR_ARROW_PATTERN:

SPRITE_INDEX_CURSOR_0: equ 0 * 4
    ; --- mouse cursor sprite
    ; color 1
    DB 10000000b
    DB 11000000b
    DB 10100000b
    DB 10010000b
    DB 10001000b
    DB 10000100b
    DB 10000010b
    DB 10000001b
    DB 10000000b
    DB 10000000b
    DB 10000011b
    DB 10010010b
    DB 10101001b
    DB 11001001b
    DB 00000110b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 10000000b
    DB 01000000b
    DB 11000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
SPRITE_INDEX_CURSOR_1: equ 1 * 4
    ; color 15
    DB 00000000b
    DB 00000000b
    DB 01000000b
    DB 01100000b
    DB 01110000b
    DB 01111000b
    DB 01111100b
    DB 01111110b
    DB 01111111b
    DB 01111111b
    DB 01111100b
    DB 01101100b
    DB 01000110b
    DB 00000110b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 10000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
SPRITE_CURSOR_ARROW_PATTERN.size:  equ $ - SPRITE_CURSOR_ARROW_PATTERN

SPRITE_INDEX_WINDOW_TOP_LEFT: equ 2 * 4
    DB 11001100 b
    DB 10000000 b
    DB 00000000 b
    DB 00000000 b
    DB 10000000 b
    DB 10000000 b
    DB 00000000 b
    DB 00000000 b

    DB 10000000 b
    DB 10000000 b
    DB 00000000 b
    DB 00000000 b
    DB 10000000 b
    DB 10000000 b
    DB 00000000 b
    DB 00000000 b

    DB 11001100 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b

    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b

SPRITE_INDEX_WINDOW_TOP_RIGHT: equ 3 * 4
    DB 11001100 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b

    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b

    DB 00110011 b
    DB 00000001 b
    DB 00000000 b
    DB 00000000 b
    DB 00000001 b
    DB 00000001 b
    DB 00000000 b
    DB 00000000 b

    DB 00000001 b
    DB 00000001 b
    DB 00000000 b
    DB 00000000 b
    DB 00000001 b
    DB 00000001 b
    DB 00000000 b
    DB 00000000 b

SPRITE_INDEX_WINDOW_BOTTOM_LEFT: equ 4 * 4
    DB 00000000 b
    DB 00000000 b
    DB 10000000 b
    DB 10000000 b
    DB 00000000 b
    DB 00000000 b
    DB 10000000 b
    DB 10000000 b

    DB 00000000 b
    DB 00000000 b
    DB 10000000 b
    DB 10000000 b
    DB 00000000 b
    DB 00000000 b
    DB 10000000 b
    DB 11001100 b

    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b

    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 11001100 b

SPRITE_INDEX_WINDOW_BOTTOM_RIGHT: equ 5 * 4
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b

    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00000000 b
    DB 00110011 b

    DB 00000000 b
    DB 00000000 b
    DB 00000001 b
    DB 00000001 b
    DB 00000000 b
    DB 00000000 b
    DB 00000001 b
    DB 00000001 b

    DB 00000000 b
    DB 00000000 b
    DB 00000001 b
    DB 00000001 b
    DB 00000000 b
    DB 00000000 b
    DB 00000001 b
    DB 00110011 b

SPRITE_PATTERNS.size: equ $ - SPRITE_PATTERNS



SPRITE_CURSOR_RESIZE_PATTERN:
    ; color 1
    DB 11111110b
    DB 10000100b
    DB 10001000b
    DB 10000100b
    DB 10100010b
    DB 11010001b
    DB 10001000b
    DB 00000100b
    DB 00000010b
    DB 00000001b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 10000000b
    DB 01000000b
    DB 00100000b
    DB 00010001b
    DB 10001011b
    DB 01000101b
    DB 00100001b
    DB 00010001b
    DB 00100001b
    DB 01111111b
    ; color 15
    DB 00000000b
    DB 01111000b
    DB 01110000b
    DB 01111000b
    DB 01011100b
    DB 00001110b
    DB 00000111b
    DB 00000011b
    DB 00000001b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 00000000b
    DB 10000000b
    DB 11000000b
    DB 11100000b
    DB 01110000b
    DB 00111010b
    DB 00011110b
    DB 00001110b
    DB 00011110b
    DB 00000000b
.size: equ $ - SPRITE_CURSOR_RESIZE_PATTERN