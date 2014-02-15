/**
 * main.d
 *
 * Textclock widget main window
 *
 * Compile with: dmd textclock.d main.d -L-lgtkd-2 -L-lphobos2 -oftextclock
 * Run with: ./textclock -x=2025 -y=62
 * 
 * Authors: 
 *   Jens Torgeir Næss, jtn70 at hotmail dot com
 * 
 * Version: 1.0
 *
 * Date: February 20, 2014
 *
 * Copyright: (C) 2014  Jens Torgeir Næss
 *
 * License:
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

module main;

import textclock;

import std.stdio;
import std.getopt;
import std.conv;
import core.thread;

import gtk.MainWindow;
import gtk.Widget;
import gtk.Main;

const string verstring = "1.0";
const string copstring = "Copyright (C) 2014  Jens Torgeir Næss";
const string licstring = "GNU General Public License v3";

public string xpos = "20", ypos = "20";

void main(string[] args)
{
    
    bool ver = false, hlp = false;

    Main.init(args);

    getopt(args,
        "xpos|x", &xpos,
        "ypos|y", &ypos,
        "help|h", &hlp,
        "version|v", &ver);
    
    if (hlp == true)
    {
        showHelptext();
        return;
    }
    if (ver == true)
    {
        showVersion();
        return;
    }

    // Thread.sleep(dur!("seconds")( 5 ));

    new WidgetWindow(xpos, ypos, verstring);

    Main.run();
}

void showHelptext()
{
    writeln("Usage: textclock [OPTION]...");
    writeln("Display a textclock widget on the desktop.");
    writeln("");
    writeln("Options:");
    writeln("  -x, --xpos=[PIX]    horizontal position of the widget window (in pixels)");
    writeln("  -y, --ypos=[PIX]    vertical position of the widget window (in pixels)");
    writeln("  -v, --version       version information");
    writeln("  -h, --help          help for the widget (this information :-)");
    writeln("");
    writeln("[PIX] is a whole number from 1 to the horizontal/vertical monitor pixel size");

}

void showVersion()
{
    writeln("textclock   Version: ", verstring);
    writeln(copstring);
    writeln(licstring);
}

