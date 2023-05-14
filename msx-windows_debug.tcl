ram_watch   add     0xC326      -type word       -desc currProcAddr      -format dec

ram_watch   add     0xC328      -type word       -desc nextAvaiProcAddr      -format dec

ram_watch   add     0xC01A      -type byte       -desc currTimeSec      -format hex


# OS.currentProcessAddr: equ 0C326h ; last def. pass 3
# OS.nextAvailableProcessAddr: equ 0C328h ; last def. pass 3


# OS.currentTime_Seconds: equ 0C01Ah ; last def. pass 3
