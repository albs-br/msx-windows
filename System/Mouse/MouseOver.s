_MOUSE_OVER:

    ; if (OS.isDraggingWindow || OS.isResizingWindow) ret
    ld      a, (OS.isDraggingWindow)
    ld      b, a
    ld      a, (OS.isResizingWindow)
    or      b
    ret     nz

    ; if (mouseOver_Activated != 0)
    ld      a, (OS.mouseOver_Activated)
    or      a
    jp      z, .skip_1

    ; if (mouseOver_screenMappingValue != currentTileMouseOver)
    ld      a, (OS.currentTileMouseOver)
    ld      b, a
    ld      a, (OS.mouseOver_screenMappingValue)
    cp      b
    ret     z
        
        ; check if is resize or window button
        ld      a, (OS.mouseOver_screenMappingValue)
        and     1111 0000 b
        cp      SCREEN_MAPPING_WINDOWS_RESIZE_CORNER
        jp      nz, .notOver_WindowButton
        jp      .notOver_ResizeCorner

.skip_1:


    ; get screenMapping value under mouse cursor
    ld      a, (OS.currentTileMouseOver)

    ; first check if the cursor is on desktop/taskbar
    cp      SCREEN_MAPPING_DESKTOP ; 255
    ret     z
    cp      SCREEN_MAPPING_TASKBAR ; 254
    ret     z


    ; get process id and put it in C
    and     0000 1111 b ; get low nibble
    ld      c, a

    ld      a, (OS.currentTileMouseOver)
    and     1111 0000 b ; get hi nibble


    ; --------------
    ; hi nibble shows which type of button the mouse is over

    cp      SCREEN_MAPPING_WINDOWS_CLOSE_BUTTON
    jp      z, .over_WindowCloseButton

    cp      SCREEN_MAPPING_WINDOWS_MAXIMIZE_RESTORE_BUTTON
    jp      z, .over_WindowMaximizeRestoreButton

    cp      SCREEN_MAPPING_WINDOWS_MINIMIZE_BUTTON
    jp      z, .over_WindowMinimizeRestoreButton

    cp      SCREEN_MAPPING_WINDOWS_RESIZE_CORNER
    jp      z, .over_WindowResizeCorner

    ret

.over_WindowCloseButton:

    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    ret     nz

    call    .getWindowCloseButton_NAMTBL

    ld      iy, TILE_WINDOW_CLOSE_BUTTON_PATTERN
    ld      b, TILE_WINDOW_CLOSE_BUTTON

    call    .setMouseOver

    ret



.over_WindowMaximizeRestoreButton:

    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    ret     nz

    call    .getWindowCloseButton_NAMTBL
    dec     hl ; adjust to get position of maximize button

    ld      iy, TILE_WINDOW_MAXIMIZE_BUTTON_PATTERN
    ld      b, TILE_WINDOW_MAXIMIZE_BUTTON

    call    .setMouseOver

    ret



.over_WindowMinimizeRestoreButton:

    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    ret     nz

    call    .getWindowCloseButton_NAMTBL
    dec     hl
    dec     hl ; adjust to get position of minimize button

    ld      iy, TILE_WINDOW_MINIMIZE_BUTTON_PATTERN
    ld      b, TILE_WINDOW_MINIMIZE_BUTTON

    call    .setMouseOver

    ret



.over_WindowResizeCorner:
 
    ; if (mouseOver_Activated) ret
    ld      a, (OS.mouseOver_Activated)
    or      a
    ret     nz

    ; set flag mouseOver_Activated to true
    ld      a, 1
    ld      (OS.mouseOver_Activated), a

    ; set mouseOver_screenMappingValue to current tile
    ld      a, (OS.currentTileMouseOver)
    ld      (OS.mouseOver_screenMappingValue), a

 
    ; copy resize cursor pattern to VRAM PATTBL on SPRITE_INDEX_CURSOR_0 & 1 
    ld      hl, SPRITE_CURSOR_RESIZE_PATTERN            ; RAM address (source)
    ld		de, SPRPAT + (SPRITE_INDEX_CURSOR_0 * 32)   ; VRAM address (destiny)
    ld		bc, SPRITE_CURSOR_RESIZE_PATTERN.size       ; Block length
    call 	BIOS_LDIRVM        	                        ; Block transfer to VRAM from memory


    ret



.notOver_ResizeCorner:
    ; reset flag mouseOver_Activated
    xor     a
    ld      (OS.mouseOver_Activated), a

    ; reset mouseOver_screenMappingValue
    ld      (OS.mouseOver_screenMappingValue), a



    ; restore arrow cursor pattern to VRAM PATTBL on SPRITE_INDEX_CURSOR_0 & 1 
    ld      hl, SPRITE_CURSOR_ARROW_PATTERN             ; RAM address (source)
    ld		de, SPRPAT + (SPRITE_INDEX_CURSOR_0 * 32)   ; VRAM address (destiny)
    ld		bc, SPRITE_CURSOR_ARROW_PATTERN.size        ; Block length
    call 	BIOS_LDIRVM        	                        ; Block transfer to VRAM from memory



    ret



.notOver_WindowButton:

    ; get process id PREVIOULSY saved and put it in C
    ld      a, (OS.mouseOver_screenMappingValue)
    and     0000 1111 b ; get low nibble
    ld      c, a


    ; reset flag mouseOver_Activated
    xor     a
    ld      (OS.mouseOver_Activated), a

    ; reset mouseOver_screenMappingValue
    ld      (OS.mouseOver_screenMappingValue), a


    ; get process addr from process id in C register
    call    _GET_PROCESS_BY_ID
    ret     nz  ; this is necessary when closing window, to not let trash on screen


    ; --- update NAMTBL
        
    ; get mouse over NAMTBL addr previously saved 
    ld      hl, (OS.mouseOver_NAMTBL_addr)
    call    BIOS_SETWRT

    ; get tile index previously saved
    ld      a, (OS.mouseOver_tileToBeRestored)
    out     (PORT_0), a

    ret




;   IY = RAM addr of tile pattern
;   HL = VRAM NAMTBL addr
;   B = TILE_WINDOW_CLOSE_BUTTON
;   C = process id ; TODO: remove if not used anymore
.setMouseOver:

;_MOUSE_OVER.setMouseOver: equ 049AFh ; last def. pass 3

    ; if (mouseOver_Activated) ret
    ld      a, (OS.mouseOver_Activated)
    or      a
    ret     nz

    ; save tile index
    ; ld      a, TILE_WINDOW_CLOSE_BUTTON
    ld      a, b
    ld      (OS.mouseOver_tileToBeRestored), a

    ; set flag mouseOver_Activated to true
    ld      a, 1
    ld      (OS.mouseOver_Activated), a

    ; set mouseOver_screenMappingValue to current tile
    ld      a, (OS.currentTileMouseOver)
    ld      (OS.mouseOver_screenMappingValue), a

    ; ; get process addr from process id in C register
    ; call    _GET_PROCESS_BY_ID
    ; ret     nz

    push    hl

        ; if (mouseY <= 63) .updateScreenTop
        ; else if (mouseY <= 127) .updateScreenMiddle
        ; else .updateScreenBottom
        ld      a, (OS.mouseY)
        cp      64
        jp      c, .updateScreenTop
        cp      128
        jp      c, .updateScreenMiddle
        jp      .updateScreenBottom

.updateScreenTop:
        ; update pattern and color of tile TILE_MOUSE_OVER
        ; ld		hl, TILE_WINDOW_CLOSE_BUTTON_PATTERN                    ; RAM address (source)

        push    iy ; HL = IY
        pop     hl

        ld		de, PATTBL + (TILE_MOUSE_OVER * 8)                      ; VRAM address (destiny)
        ld		bc, 8	                                                ; Block length
        call 	BIOS_LDIRVM        	                                    ; Block transfer to VRAM from memory

        ld      a, 0xe1 ;                                               ; value
        ;ld      a, 0x61 ;                                               ; value
        ld      bc, 8                                                   ; size
        ld      hl, COLTBL + (TILE_MOUSE_OVER * 8)                      ; start VRAM address
        call    BIOS_FILVRM
        
        jp      .continue_1

.updateScreenMiddle:
        ; update pattern and color of tile TILE_MOUSE_OVER
        ; ld		hl, TILE_WINDOW_CLOSE_BUTTON_PATTERN                    ; RAM address (source)

        push    iy ; HL = IY
        pop     hl

        ld		de, PATTBL + (256 * 8) + (TILE_MOUSE_OVER * 8)          ; VRAM address (destiny)
        ld		bc, 8	                                                ; Block length
        call 	BIOS_LDIRVM        	                                    ; Block transfer to VRAM from memory

        ld      a, 0xe1 ;                                               ; value
        ld      bc, 8                                                   ; size
        ld      hl, COLTBL + (256 * 8) + (TILE_MOUSE_OVER * 8)          ; start VRAM address
        call    BIOS_FILVRM
        
        jp      .continue_1

.updateScreenBottom:
        ; update pattern and color of tile TILE_MOUSE_OVER
        ; ld		hl, TILE_WINDOW_CLOSE_BUTTON_PATTERN                    ; RAM address (source)

        push    iy ; HL = IY
        pop     hl

        ld		de, PATTBL + (512 * 8) + (TILE_MOUSE_OVER * 8)          ; VRAM address (destiny)
        ld		bc, 8	                                                ; Block length
        call 	BIOS_LDIRVM        	                                    ; Block transfer to VRAM from memory

        ld      a, 0xe1 ;                                               ; value
        ld      bc, 8                                                   ; size
        ld      hl, COLTBL + (512 * 8) + (TILE_MOUSE_OVER * 8)          ; start VRAM address
        call    BIOS_FILVRM
        
.continue_1:

    pop     hl

        
    ; save NAMTBL position to be restored later
    ld      (OS.mouseOver_NAMTBL_addr), hl

    ; update NAMTBL
    call    BIOS_SETWRT
    ld      a, TILE_MOUSE_OVER
    out     (PORT_0), a

    ret

; ; TODO:
; ; remove or comment (is not being used)
; _MOUSE_XY_TO_NAMTBL:
; ; convert mouse position in pixels (x, y) to tiles (col, line)
;     ld      a, (OS.mouseY)
;     ; dec     a       ; because of the Y + 1 TMS9918 bug

;     ; divide by 8
;     srl     a ; shift right n, bit 7 = 0, carry = 0
;     srl     a ; shift right n, bit 7 = 0, carry = 0
;     srl     a ; shift right n, bit 7 = 0, carry = 0
;     ld      h, a


;     ld      a, (OS.mouseX)

;     ; divide by 8
;     srl     a ; shift right n, bit 7 = 0, carry = 0
;     srl     a ; shift right n, bit 7 = 0, carry = 0
;     srl     a ; shift right n, bit 7 = 0, carry = 0
;     ld      l, a


;     call    _CONVERT_COL_LINE_TO_LINEAR

;     ld      bc, NAMTBL
;     add     hl, bc

;     ret



; Input: 
;   HL = process header addr
; Output:
;   HL = NAMTBL addr of close button
.getWindowCloseButton_NAMTBL:
    push    hl ; IX = HL
    pop     ix
    call    _GET_WINDOW_TITLE_BASE_NAMTBL
    
    ld      a, (ix + PROCESS_STRUCT_IX.windowState)
    cp      WINDOW_STATE.MAXIMIZED
    jp      z, .isMaximized

    ; add width - n
    ld      c, (ix + PROCESS_STRUCT_IX.width)   ; process.width
    ld      b, 0
    add     hl, bc
    ld      bc, 32 - 2                          ; one line below, two columns to the left
    add     hl, bc
    
    ret

.isMaximized:
    ld      bc, 32 - 1
    add     hl, bc
    
    ret