ram_watch   add     0xC326      -type word       -desc currProcAddr      -format dec

ram_watch   add     0xC328      -type word       -desc nextAvaiProcAddr      -format dec

ram_watch   add     0xC01A      -type byte       -desc currTimeSec      -format hex

ram_watch   add     0xC32a      -type byte       -desc p0_id      -format hex

# OS.processes: equ 0C32Ah ; last def. pass 3


# OS.currentProcessAddr: equ 0C326h ; last def. pass 3
# OS.nextAvailableProcessAddr: equ 0C328h ; last def. pass 3


# OS.currentTime_Seconds: equ 0C01Ah ; last def. pass 3
