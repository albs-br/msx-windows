ram_watch   add     0xC32b      -type word       -desc currProcAddr      -format hex

ram_watch   add     0xC32d      -type word       -desc nextAvaiProcAddr      -format hex

ram_watch   add     0xC01c      -type byte       -desc currTimeSec      -format hex
ram_watch   add     0xC01b      -type byte       -desc currTimeMin      -format hex
ram_watch   add     0xC01a      -type byte       -desc currTimeHour     -format hex


ram_watch   add     0xC32f      -type byte       -desc p0_id      -format hex
ram_watch   add     0xC65b      -type byte       -desc p1_id      -format hex
ram_watch   add     0xC987      -type byte       -desc p2_id      -format hex
ram_watch   add     0xCCB3      -type byte       -desc p3_id      -format hex

ram_watch   add     5001a      -type byte       -desc _p0_layer      -format hex
ram_watch   add     50822      -type byte       -desc _p1_layer      -format hex
ram_watch   add     51634      -type byte       -desc _p2_layer      -format hex
ram_watch   add     52446      -type byte       -desc _p3_layer      -format hex

ram_watch   add     0xd30b      -type byte       -desc Temp     -format hex


ram_watch   add     0xC328      -type byte       -desc currTileMouseOver     -format hex

ram_watch   add     0xfc48      -type word       -desc BOTTOM     -format hex
ram_watch   add     0xfc4a      -type word       -desc HIMEM     -format hex


ram_watch   add     0xC00a      -type byte       -desc mouseBtn1     -format hex
ram_watch   add     0xC00b      -type byte       -desc mouseBtn2     -format hex


ram_watch   add     0xC018      -type word       -desc ticksSinceLastInput     -format dec

