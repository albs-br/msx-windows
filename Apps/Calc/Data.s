
.CALC_DISPLAY_TILES:
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP
    db TILE_WINDOW_TITLE_MIDDLE_TOP

    db TILE_EMPTY_BLACK
    db TILE_EMPTY_BLACK
    db TILE_EMPTY_BLACK
    db TILE_EMPTY_BLACK
    db TILE_EMPTY_BLACK
    db TILE_EMPTY_BLACK
    db TILE_EMPTY_BLACK
    db TILE_EMPTY_BLACK
    db TILE_EMPTY_BLACK
    db TILE_FONT_REVERSED_NUMBERS_0 + 1 ; debug
    db TILE_FONT_REVERSED_NUMBERS_0 + 2
    db TILE_FONT_REVERSED_NUMBERS_0 + 3

.CALC_KEYPAD_TILES:
    ; -----
    db TILE_LINE_TOP_LEFT, TILE_LINE_HORIZONTAL, TILE_LINE_TOP_RIGHT
    db TILE_LINE_TOP_LEFT, TILE_LINE_HORIZONTAL, TILE_LINE_TOP_RIGHT
    db TILE_LINE_TOP_LEFT, TILE_LINE_HORIZONTAL, TILE_LINE_TOP_RIGHT
    db TILE_LINE_TOP_LEFT, TILE_LINE_HORIZONTAL, TILE_LINE_TOP_RIGHT

    db TILE_LINE_VERTICAL, TILE_FONT_NUMBERS_0 + 7, TILE_LINE_VERTICAL
    db TILE_LINE_VERTICAL, TILE_FONT_NUMBERS_0 + 8, TILE_LINE_VERTICAL
    db TILE_LINE_VERTICAL, TILE_FONT_NUMBERS_0 + 9, TILE_LINE_VERTICAL
    db TILE_LINE_VERTICAL, TILE_FONT_NUMBERS_0 + 0, TILE_LINE_VERTICAL

    db TILE_LINE_BOTTOM_LEFT, TILE_LINE_HORIZONTAL, TILE_LINE_BOTTOM_RIGHT
    db TILE_LINE_BOTTOM_LEFT, TILE_LINE_HORIZONTAL, TILE_LINE_BOTTOM_RIGHT
    db TILE_LINE_BOTTOM_LEFT, TILE_LINE_HORIZONTAL, TILE_LINE_BOTTOM_RIGHT
    db TILE_LINE_BOTTOM_LEFT, TILE_LINE_HORIZONTAL, TILE_LINE_BOTTOM_RIGHT

    ; -----
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY

    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 4, TILE_EMPTY
    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 5, TILE_EMPTY
    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 6, TILE_EMPTY
    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 0, TILE_EMPTY

    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY

    ; -----
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY

    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 1, TILE_EMPTY
    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 2, TILE_EMPTY
    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 3, TILE_EMPTY
    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 0, TILE_EMPTY

    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY

    ; -----
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY

    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 0, TILE_EMPTY
    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 0, TILE_EMPTY
    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 0, TILE_EMPTY
    db TILE_EMPTY, TILE_FONT_NUMBERS_0 + 0, TILE_EMPTY

    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
    db TILE_EMPTY, TILE_EMPTY, TILE_EMPTY
