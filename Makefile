# Define DMD as compiler
CC = dmd
CFLAGS = -c -release -inline
LFLAGS = -release -O -inline
LIBS = -L-lphobos2 -L-lcurl -L-lgtkd-2
APP = textclock

all:	textclock

textclock: main.o textclock.o
			$(CC) $(LFLAGS) main.o textclock.o $(LIBS) -of$(APP)
			strip $(APP)

main.o:		main.d
			$(CC) $(CFLAGS) main.d

textclock.o:	textclock.d
				$(CC) $(CFLAGS) textclock.d

clean:			
				rm -rf *.o textclock