# msx-windows
OS with graphic interface for MSX 1

Proof of concept of the viability of a mouse oriented OS with GUI, as Windows 3.xx/9x.

Restrictions:
- Run on 16kb RAM MSX 1 (9918 VDP), using screen 2 (screen 1 is not out of question yet).
- Should fit on 16kb ROM, with a few small programs, such as: notepad, calc, minesweeper,
  task manager, date & time, tic-tac-toe, etc.

The goal here is showing how it is possible for a 1983 8-bit home computer to have the user 
experience of an early 90's PC with Windows (even faster, as here there is not swapping file).
The idea is to be frame-fast on all operations. ALT-TAB between 2 maximized programs should be
instantaneous, for example.

Loading files/programs from disk is possible, but out of the scope for now.