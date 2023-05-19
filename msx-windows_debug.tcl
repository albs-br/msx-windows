ram_watch   add     0xC327      -type word       -desc currProcAddr      -format hex

ram_watch   add     0xC329      -type word       -desc nextAvaiProcAddr      -format hex

ram_watch   add     0xC01A      -type byte       -desc currTimeSec      -format hex
ram_watch   add     0xC019      -type byte       -desc currTimeMin      -format hex
ram_watch   add     0xC018      -type byte       -desc currTimeHour     -format hex


ram_watch   add     0xC32B      -type byte       -desc p0_id      -format hex
ram_watch   add     50774       -type byte       -desc p1_id      -format hex
ram_watch   add     51585       -type byte       -desc p2_id      -format hex
ram_watch   add     52396       -type byte       -desc p3_id      -format hex

ram_watch   add     0xC326      -type byte       -desc currTileMouseOver     -format hex

ram_watch   add     0xfc48      -type word       -desc BOTTOM     -format hex
ram_watch   add     0xfc4a      -type word       -desc HIMEM     -format hex


# OS.currentTileMouseOver: equ 0C326h ; last def. pass 3
