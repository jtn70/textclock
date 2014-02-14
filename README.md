textclock
=========

textclock is a small application displaying a textclock with date and calendar on the desktop

Version 1.0
Copyright (c) 2014 Jens Torgeir Næss
Licensed under GPLv3. 

textclock is based in part on works of the GtkD project 
(http://www.dsource.org/projects/gtkd)

Please view LICENSING for additional information.

The program is written in D and will compile on the standard D compiler.

Requirements:
-------------
- Linux with GTK libraries (it might work under Mac and Windows ????)
- GtkD library (http://gtkd.org)
- Cairo, Pango
- D reference compiler with Phobos std. library 


Building
--------
Automatic building tools is not provided yes.
To build:
dmd -m64 -O -release -inline -noboundscheck textclock.d main.d -L-lgtkd-2 -L-lphobos2 -oftextclock

chmod +x textclock
copy textclock to wanted directory

If you want a smaller executable, run the following commands
strip --strip-unneeded textclock
upx textclock

RUNNING
-------
textclock --xpos=1000 --ypos=50, or
textclock --help to get options
