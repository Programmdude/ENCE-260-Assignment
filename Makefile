# File:   Makefile
# Author: M. P. Hayes, UCECE
# Date:   12 Sep 2010
# Descr:  Makefile for game

# Definitions.
CC = avr-gcc -std=c99
CFLAGS = -mmcu=atmega32u2 -Os -Wall -Wstrict-prototypes -Wextra -g -I. -I../../utils -I../../fonts -I../../drivers -I../../drivers/avr
OBJCOPY = avr-objcopy
SIZE = avr-size
DEL = rm


# Default target.
all: game.out


# Compile: create object files from C source files.
game.o: game.c
	$(CC) -c $(CFLAGS) $< -o $@
	
scheduler.o: scheduler.c
	$(CC) -c $(CFLAGS) $< -o $@
	
display_interrupt.o: display_interrupt.c
	$(CC) -c $(CFLAGS) $< -o $@
	
ledmat_interrupt.o: ledmat_interrupt.c
	$(CC) -c $(CFLAGS) $< -o $@
	
display_controller.o: display_controller.c
	$(CC) -c $(CFLAGS) $< -o $@
	
nav_controller.o: nav_controller.c
	$(CC) -c $(CFLAGS) $< -o $@
	
communication.o: communication.c
	$(CC) -c $(CFLAGS) $< -o $@

navswitch.o: ../../drivers/navswitch.c
	$(CC) -c $(CFLAGS) $< -o $@

led.o: ../../drivers/led.c
	$(CC) -c $(CFLAGS) $< -o $@

ir.o: ../../drivers/ir.c
	$(CC) -c $(CFLAGS) $< -o $@

ir_serial.o: ../../drivers/ir_serial.c
	$(CC) -c $(CFLAGS) $< -o $@

system.o: ../../drivers/avr/system.c
	$(CC) -c $(CFLAGS) $< -o $@

tinygl.o: ../../utils/tinygl.c
	$(CC) -c $(CFLAGS) $< -o $@

font.o: ../../utils/font.c
	$(CC) -c $(CFLAGS) $< -o $@



# Link: create ELF output file from object files.
game.out: game.o display_interrupt.o led.o ledmat_interrupt.o system.o scheduler.o display_controller.o tinygl.o font.o nav_controller.o navswitch.o communication.o ir.o ir_serial.o
	$(CC) $(CFLAGS) $^ -o $@ -lm
	$(SIZE) $@


# Target: clean project.
.PHONY: clean
clean: 
	-$(DEL) *.o *.out *.hex


# Target: program project.
.PHONY: program
program: game.out
	$(OBJCOPY) -O ihex game.out game.hex
	dfu-programmer atmega32u2 erase; dfu-programmer atmega32u2 flash game.hex; dfu-programmer atmega32u2 start


