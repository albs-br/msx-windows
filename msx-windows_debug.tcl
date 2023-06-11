# ram_watch   add     0xC01f      -type byte       -desc nextAvaiProcAddr      -format dec

ram_watch   add     0xC016      -type byte       -desc BotRig_Y      -format dec
ram_watch   add     0xC023      -type byte       -desc BotRig_Y_Min      -format dec

# OS.windowCorner_BottomRight_X: equ 0C017h ; last def. pass 3
#OS.windowCorner_BottomRight_Y: equ 0C016h ; last def. pass 3
#OS.resizeWindowCorner_BottomRight_Y_Min: equ 0C023h ; last def. pass 3

# ram_watch   add     0xC60B      -type word       -desc currProcAddr      -format hex
# ram_watch   add     0xC60d      -type word       -desc nextAvaiProcAddr      -format hex


# ram_watch   add     0xC01c      -type byte       -desc currTimeSec      -format hex
# ram_watch   add     0xC01b      -type byte       -desc currTimeMin      -format hex
# ram_watch   add     0xC01a      -type byte       -desc currTimeHour     -format hex

# ram_watch   add     0xC32d      -type byte       -desc _tileToBeRestored     -format dec
# ram_watch   add     0xC32e      -type word       -desc _NAMTBL_addr     -format hex

# OS.mouseOver_tileToBeRestored: equ 0C32Dh ; last def. pass 3
# OS.mouseOver_NAMTBL_addr: equ 0C32Eh ; last def. pass 3

# ram_watch   add     0xC60f      -type byte       -desc p0_id      -format hex
# ram_watch   add     0xC649      -type byte       -desc p1_id      -format hex
# ram_watch   add     0xC683      -type byte       -desc p2_id      -format hex
# ram_watch   add     0xC6bd      -type byte       -desc p3_id      -format hex
# 
# ram_watch   add     0xC610      -type byte       -desc _p0_state      -format dec
# ram_watch   add     0xC64a      -type byte       -desc _p1_state      -format dec
# ram_watch   add     0xC684      -type byte       -desc _p2_state      -format dec
# ram_watch   add     0xC6be      -type byte       -desc _p3_state      -format dec
# 
# ram_watch   add     0xc648      -type byte       -desc __p0_prevState      -format dec
# ram_watch   add     0xC682      -type byte       -desc __p1_prevState      -format dec
# ram_watch   add     0xC6bc      -type byte       -desc __p2_prevState      -format dec
# ram_watch   add     0xC6f6      -type byte       -desc __p3_prevState      -format dec

# ram_watch   add     0xC616      -type byte       -desc _p0_width      -format dec


#ram_watch   add     5001a      -type byte       -desc _p0_layer      -format hex
#ram_watch   add     50822      -type byte       -desc _p1_layer      -format hex
#ram_watch   add     51634      -type byte       -desc _p2_layer      -format hex
#ram_watch   add     52446      -type byte       -desc _p3_layer      -format hex

# ram_watch   add     0xd30b      -type byte       -desc Temp     -format hex


# ram_watch   add     0xC32f      -type byte       -desc currTileMouseOver     -format hex
# 
# ram_watch   add     0xC72F      -type byte       -desc IsResizing     -format dec
# 
# ram_watch   add     0xC33F      -type byte       -desc mouseOver_screenMappingValue     -format hex

# OS.mouseOver_screenMappingValue: equ 0C33Fh ; last def. pass 3

# IsResizing: equ 0C72Fh ; last def. pass 3


# ram_watch   add     0xfc48      -type word       -desc BOTTOM     -format hex
# ram_watch   add     0xfc4a      -type word       -desc HIMEM     -format hex
# 
# 
# ram_watch   add     0xC00a      -type byte       -desc mouseBtn1     -format hex
# ram_watch   add     0xC00b      -type byte       -desc mouseBtn2     -format hex
# 
# ram_watch   add     0xC002      -type byte       -desc mouseY     -format dec
# ram_watch   add     0xC003      -type byte       -desc mouseX     -format dec
# ram_watch   add     0xC00a      -type byte       -desc windowCor_Y     -format dec
# ram_watch   add     0xC00b      -type byte       -desc windowCor_X     -format dec


# ram_watch   add     0xC018      -type word       -desc ticksSinceLastInput     -format dec

