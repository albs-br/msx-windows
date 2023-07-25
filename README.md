# msx-windows
OS with graphic interface for MSX 1

Proof of concept for the viability of a mouse oriented OS with GUI, as Windows 3.xx/9x.

Video demonstration:
https://www.youtube.com/watch?v=q2wZaBPbj4M

[![IMAGE ALT TEXT](https://www.youtube.com/watch?v=q2wZaBPbj4M/0.jpg)](https://www.youtube.com/watch?v=q2wZaBPbj4M "MSX Windows")

Use it online on Webmsx:
https://webmsx.org/?ROM=https://github.com/albs-br/msx-windows/releases/download/v.0.61.0/msx-windows.rom&MACHINE=MSX1A&FAST_BOOT=1&MOUSE_MODE=1

Restrictions:
- Run on 16kb RAM MSX 1 (TMS 9918 VDP), using screen 2
- Should fit on 16kb ROM, with a few small programs, such as: notepad, calc, minesweeper,
  task manager, date & time, tic-tac-toe, etc

The goal here is showing how it is possible for a 1983 8-bit home computer to have the user 
experience of an early 90's PC with Windows (even faster, as here there is not swapping file).
The idea is to be frame-fast on all operations. ALT-TAB between 2 maximized programs should be
instantaneous, for example.

Loading files/programs from disk is possible, but out of the scope for now.