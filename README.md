# msx-windows
OS with graphic interface for MSX 1

Proof of concept for the viability of a mouse oriented OS with GUI, as Windows 3.xx/9x.

Video demonstration:
https://www.youtube.com/watch?v=q2wZaBPbj4M

[![IMAGE ALT TEXT](http://img.youtube.com/vi/q2wZaBPbj4M/0.jpg)](https://www.youtube.com/watch?v=q2wZaBPbj4M "MSX Windows")

Use it online on Webmsx:
https://webmsx.org/?ROM=https://github.com/albs-br/msx-windows/releases/download/v.0.61.0/msx-windows.rom&MACHINE=MSX1A&FAST_BOOT=1&MOUSE_MODE=1

Discussion here: https://www.msx.org/forum/msx-talk/development/msx-windows-graphic-os-for-msx-1-poc

Restrictions:
- Run on 16kb RAM MSX 1 (TMS 9918 VDP), using screen 2
- Should fit on 16kb ROM, with a few small programs, such as: notepad, calc, minesweeper,
  task manager, date & time, tic-tac-toe, etc

The goal here is showing how it is possible for a 1983 8-bit home computer to have the user 
experience of an early 90's PC with Windows (even faster, as here there is not swapping file).
The idea is to be frame-fast on all operations. ALT-TAB between 2 maximized programs should be
instantaneous, for example.

Loading files/programs from disk is possible, but out of the scope for now.

The OS can run 4 process simultaneously. Each process has a header with vital info (x and y of window, process ID, title, etc).

The OS has 4 process slots, in which these headers are loaded when the app is open. Besides this, the OS alocates some space in RAM for each process. This space is fixed (currently only 1kb per process, but there is room for around 2,5kb per process on a 16kb of RAM machine).

There are some app events, that the OS calls when the actions are performed, such as open the app, click, get focus, etc. Each time the OS calls an app event, it passes the process slot addr on register IX, and the process RAM addr space on IY. This arrange makes it possible to the RAM space for variables to be dynamic (grows up or shrink on demand). But this is not implemented yet.

The main process event is "Work", which is called by the OS only for the active app, the other apps do not make any processing when are on background. This can be easily seen on Settings app, when it loses focus, the clock stops.

There is a possibility of implementing a BackgroundWork event for the apps opened but out of focus. In this case is up to the app developer to keep the processing on this event as light as possible, or it will slow down the system.

Each app has also its own 12 tile patterns that can be customized, besides all other OS tiles. They are assigned by the OS on app Open event.
There is still some tile space left on VRAM, meaning it can be grown to around 16 tiles per app in future.

I have not yet implemented some OS features, as the start menu or dialogs, so I'm not sure on how much tiles there will be left.

Of course, as the Z80 has no level of protection for processes, the app should be "well behaved" and do not mess up with RAM or VRAM of other processes or OS, nor uses too much CPU.

One more tech detail: the apps are fixed in ROM, but is possible to make them relocateble, so they can be loaded from disk. I have an idea on how to make this.

The windows are fixed to the 8x8 grid, to make it pixel precise is possible (due to the 2 colors only) but would become slow I guess.

I tried to make a minimalist design with only 2 colors (and a little of gray on some mouse overs). It's a visual style of the present day, on an 80's computer. I think the result was pretty good.

This OS could have been a firmware for the very first MSXs of 1983, with only 16kb of RAM! It would be be crazy, as this kind of user experience turned out to be common only 10 years later on machines 40 times more powerful.

OS variables amount to just 1855 bytes, that means around 11% of the 16kb of RAM, such a small overhead for a graphic OS.
And I had little to none worries with optimization. ROM size (OS and apps are under 12 kb). Apps are not fully implemented yet.