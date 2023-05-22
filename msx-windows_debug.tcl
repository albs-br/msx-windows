ram_watch   add     0xC329      -type word       -desc currProcAddr      -format hex

ram_watch   add     0xC32b      -type word       -desc nextAvaiProcAddr      -format hex

ram_watch   add     0xC01A      -type byte       -desc currTimeSec      -format hex
ram_watch   add     0xC019      -type byte       -desc currTimeMin      -format hex
ram_watch   add     0xC018      -type byte       -desc currTimeHour     -format hex


ram_watch   add     0xC32d      -type byte       -desc p0_id      -format hex
ram_watch   add     50776       -type byte       -desc p1_id      -format hex
ram_watch   add     51587       -type byte       -desc p2_id      -format hex
ram_watch   add     52398       -type byte       -desc p3_id      -format hex


# ram_watch   add     0xC356      -type byte       -desc p0_scrTilesBehind      -format hex

ram_watch   add     0xd304      -type byte       -desc Temp     -format hex

# Temp: equ 0D304h ; last def. pass 3

ram_watch   add     0xC326      -type byte       -desc currTileMouseOver     -format hex

ram_watch   add     0xfc48      -type word       -desc BOTTOM     -format hex
ram_watch   add     0xfc4a      -type word       -desc HIMEM     -format hex


ram_watch   add     0xC00a      -type byte       -desc mouseBtn1     -format hex
ram_watch   add     0xC00b      -type byte       -desc mouseBtn2     -format hex


ram_watch   add     0xC016      -type word       -desc ticksSinceLastInput     -format dec


# OS.ticksSinceLastInput: equ 0C016h ; last def. pass 3

# OS.currentTileMouseOver: equ 0C326h ; last def. pass 3

# OS.mouseButton_1: equ 0C00Ah ; last def. pass 3
