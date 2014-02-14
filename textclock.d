/**
 * main.d
 *
 * Textclock widget 
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

module textclock;

import core.time;

import std.stdio;
import std.math;
import std.datetime;
import std.string;
import std.conv;

import glib.Timeout;

import gtk.Main;
import gtk.MainWindow;
import gdk.Screen;
import gdk.Visual;

import cairo.Context;
import cairo.Surface;
import cairo.FontOption;
import cairo.ImageSurface;

import pango.PgCairo;
import pango.PgLayout;
import pango.PgFontDescription;

import gtk.Widget;
import gtk.DrawingArea;

import gtk.EventBox;
import gtk.AccelGroup;
import gdk.Event;
import gtk.Menu;
import gtk.MenuItem;

class WidgetWindow : MainWindow
{
    Menu menu;
    const int defaultxSize = 520;
    const int defaultySize = 350;
    int defaultxpos;
    int defaultypos;
    Timeout appmovetimer;

    this(string xpos, string ypos, string verstring)
    {
        // Initialize Widget
        super(format("Textclock Widget: %s", verstring));

        // Add popup menu to the application
        menu = new Menu();
        MenuItem menuQuitItem = new MenuItem("Quit");
        menuQuitItem.addOnButtonRelease(&onQuit);
        menu.append(menuQuitItem);

        defaultxpos = to!int(xpos);
        defaultypos = to!int(ypos);

        // Turn window transparency on
        Screen screen = getScreen();
        Visual visual = screen.getRgbaVisual();
        if (visual && screen.isComposited() == true)
            setVisual(visual);

        // Set various window settings. See explanation.
        setAppPaintable(true);      
        setDecorated(false);                            // Removes window decorations (menus, ...)
        setKeepBelow(true);                             // Window will stay below other windows
        setSkipTaskbarHint(true);                       // Window icon will not show up in taskbar
        setSkipPagerHint(true);                         // Window icon will not show up in pager
        setAcceptFocus(false);                          // Window will not recieve focus

        // Set default window size and move the window.
        setDefaultSize (defaultxSize, defaultySize);
        move(defaultxpos, defaultypos);

        TextClock tc = new TextClock();

        appmovetimer = new Timeout(2000, &appmoveTimer, false);

        // Show the window and run the application
        tc.addOnButtonPress(&onButtonPress);
        menu.attachToWidget(tc, null);
        add(tc);

        tc.show();
        showAll();
    }

    /**
     * Event handler for popup menu quit event.
     * This will exit the application in an orderly/standard way.
     */
    public bool onQuit(Event event, Widget widget)
    {   
        if (event.type == EventType.BUTTON_RELEASE)
        {
            GdkEventButton* buttonEvent = event.button;

            if (buttonEvent.button == 1) // If left mouse button pressed.
            {
                Main.quit();
                return true;        
            }
        }
        return false;
    }

    /**
     * Event handler that will display popup menu if right button is
     * pressed inside appliacation borders.
     */
    public bool onButtonPress(Event event, Widget widget)
    {
        if ( event.type == EventType.BUTTON_PRESS)
        {
            GdkEventButton* buttonEvent = event.button;

            if (buttonEvent.button == 3)
            {
                menu.showAll();
                menu.popup(buttonEvent.button, buttonEvent.time);

                return true;
            }
        }
        return false;
    }

    bool appmoveTimer()
    {
        int curxpos;
        int curypos;
        getPosition(curxpos, curypos);
        if (defaultxpos != curxpos && defaultypos != curypos)
            move(defaultxpos, defaultypos);

        return false;
    }
}


 class TextClock : DrawingArea
 {
    const string weekdayname[] = 
        ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];
    const string weekdaynameshort[] = 
        ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
    const string monthname[] =
        ["january", "february", "march", "april", "may", "june", "july", "august", "september", "november", "december"];
    Timeout redrawtimer;
    static bool secondState = false;

 public:
    this()
    {
        // Attach our expose callback, which will draw the window.
        // this.setOpacity(0.1);
        
        redrawtimer = new Timeout(60000, &redrawTimer, false);
        addOnDraw(&drawCallback);
    }

protected:
    /**
     * Event handler that handles the window draw. This function uses
     * Cairo for drawing and displaying text.
     */
    bool drawCallback(Scoped!Context cr, Widget widget)
    {
        //TickDuration tstart = TickDuration.currSystemTick();
        FontOption font_options = FontOption.create();
        font_options.setHintStyle(cairo_hint_style_t.NONE);
        font_options.setHintMetrics(cairo_hint_metrics_t.OFF);
        font_options.setAntialias(cairo_antialias_t.GRAY);

        cr.setFontOptions(font_options);

        cr.save();
            cr.setOperator(CairoOperator.OVER);
            cr.identityMatrix();
            
            cr.moveTo(270, 80);
            cr.setSourceRgba(1, 1, 1, 1);
            cr.selectFontFace("Existence Light", cairo_font_slant_t.NORMAL, cairo_font_weight_t.NORMAL);
            cr.setFontSize(100);
            
            cr.showText(format("%02d", Clock.currTime().hour));

            /*
            if (secondState)
            {
                cr.moveTo(370, 70);
                cr.showText(":");
                secondState = false;
            }
            else
                secondState = true;
            */
            cr.selectFontFace("Georgia", cairo_font_slant_t.NORMAL, cairo_font_weight_t.NORMAL);
            cr.setFontSize(50);
            cr.moveTo(375, 60);
            cr.showText(":");

            cr.selectFontFace("Existence Light", cairo_font_slant_t.NORMAL, cairo_font_weight_t.NORMAL);
            cr.setFontSize(100);
            cr.moveTo(395, 80);
            cr.showText(format("%02d", Clock.currTime().minute));

            cr.moveTo(5, 90);
            cr.setSourceRgb(1, 1, 1);
            cr.setLineWidth(0.5);
            cr.lineTo(510, 90);
            cr.stroke();
            cr.moveTo(20, 120);
            cr.setFontSize(30);
            //cr.showText(format("%s %02d. %s %d", Clock.currTime().day));
            cr.showText(format("%s %02d. %s %04d", 
                weekdayname[(cast(DateTime)Clock.currTime()).dayOfWeek-1],
                Clock.currTime().day,
                monthname[Clock.currTime().month-1],
                Clock.currTime().year));
            
            // Print calendar
            const int xgap=20;
            const int ygap=20;
            const int calsx=350;
            const int calsy=150;
            const DateTime tdate = cast(DateTime)Clock.currTime;

            cr.selectFontFace("Liberation Sans", cairo_font_slant_t.NORMAL, cairo_font_weight_t.NORMAL);
            cr.setFontSize(10);

            foreach(int tmpday; 0 .. 7)
            {
                cr.moveTo(calsx + ((tmpday+1) * xgap), calsy);
                cr.showText(weekdaynameshort[tmpday]);
            }
            
            int startweek = Date(tdate.year, tdate.month, 1).isoWeek;

            foreach(int tmpday; 1 .. tdate.daysInMonth + 1)
            {
                int weekno = Date(tdate.year, tdate.month, tmpday).isoWeek - startweek + 1;
                int weekday = Date(tdate.year, tdate.month, tmpday).dayOfWeek;
                if (weekday == 0) weekday = 7;
                if (weekday == 1 || tmpday == 1)
                {
                    cr.moveTo(calsx, calsy + (weekno)*ygap);
                    cr.showText(format("%02d", Date(tdate.year, tdate.month, tmpday).isoWeek));
                }
                if (tmpday == tdate.day)
                {
                    cr.newSubPath();
                    cr.setLineWidth(0.3);
                    cr.arc(calsx + weekday * xgap+6, calsy + (weekno*ygap)-3, 10, 0, 360);
                    cr.stroke();
                    cr.moveTo(calsx + weekday * xgap, calsy + (weekno*ygap));
                    cr.showText(format("%02d", tmpday));
                }
                else
                {

                    cr.moveTo(calsx + weekday * xgap, calsy + (weekno*ygap));
                    cr.showText(format("%02d", tmpday));
                }
            }

            cr.setLineWidth(0.1);
            cr.moveTo(calsx + 15, calsy + 5);
            cr.lineTo(calsx + 160, calsy + 5);
            cr.stroke();
            cr.moveTo(calsx + 15, calsy + 5);
            cr.lineTo(calsx + 15, calsy + 110);
            cr.stroke();

            //cr.paint();
            
        cr.restore();
        //TickDuration st = TickDuration.currSystemTick().length - tstart.length;
        //writeln(st.msecs());
        return true;
    }

    bool redrawTimer()
    {
        queueDraw();
        return true;
    }
 }