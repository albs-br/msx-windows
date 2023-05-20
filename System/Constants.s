; Constants

; constants (refer to Ram.s (OS.screenMapping) for explanation)
SCREEN_MAPPING_DESKTOP:     equ 255
SCREEN_MAPPING_TASKBAR:     equ 254
                                                    ; low nibble = process id
SCREEN_MAPPING_WINDOWS:                     equ 0000 0000 b
SCREEN_MAPPING_WINDOWS_TITLE_BAR:           equ 0001 0000 b
SCREEN_MAPPING_WINDOWS_MINIMIZE_BUTTON:     equ 0010 0000 b
SCREEN_MAPPING_WINDOWS_RESTORE_BUTTON:      equ 0011 0000 b
SCREEN_MAPPING_WINDOWS_MAXIMIZE_BUTTON:     equ 0100 0000 b
SCREEN_MAPPING_WINDOWS_RESIZE_CORNER:       equ 0101 0000 b


WINDOW_STATE:
.MINIMIZED:     equ 1
.RESTORED:      equ 2
.MAXIZED:       equ 3


MOUSE_ON_JOYPORT_1: equ 0x1310
MOUSE_ON_JOYPORT_2: equ 0x6C20

MOUSE_PORT:     equ MOUSE_ON_JOYPORT_1