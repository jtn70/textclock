textclock
=========

textclock is a small application displaying a textclock with date and calendar on the desktop
(See textclock.png for a screencapture of the running application).

Version 1.0
Copyright (c) 2014 Jens Torgeir Næss
Licensed under GPLv3. 

textclock is based in part on works of the GtkD project 
(http://www.dsource.org/projects/gtkd)

Please view LICENSE for additional information.

The program is written in D and will compile on the standard D compiler.

Requirements:
-------------
- Linux with GTK libraries (it might work under Mac and Windows ????)
- GtkD library (http://gtkd.org)
- Cairo, Pango
- D reference compiler with Phobos std. library 
- Existence Light, Georgia and Liberation Sans fonts


Building
--------
Automatic building tools is not provided yet.

To build:
dmd -m64 -O -release -inline -noboundscheck textclock.d main.d -L-lgtkd-2 -L-lphobos2 -oftextclock

chmod +x textclock
copy textclock to the wanted directory

If you want a smaller executable, run the following commands
strip --strip-unneeded textclock
upx textclock

RUNNING
-------
textclock --xpos=1000 --ypos=50, or
textclock --help to get options
