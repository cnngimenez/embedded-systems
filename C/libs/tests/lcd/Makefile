# File to compile
ifndef FILE
FILE=lcd-send
endif

# Compiling variables
# --------------------------------------------------

# List of files to be compiled with the main file.
LIBS=../../lcd-lib.c

# Instruction set architecture (ISA):
# MMCU=atmega2560
MMCU=atmega328p

# Optimizations (For debugging with simavr you should deactivate this)
# OPT=-Os

# Include this C headers
INCLUDES=-I/usr/avr/include/avr -I../..

# CPU Frequency
F_CPU=16000000UL

# Flashing variables
# --------------------------------------------------

# Port to use
ifndef PORT
PORT=/dev/ttyUSB0
endif
# Type of MCU connected to the programmer
# PARTNO=atmega2560
PARTNO=atmega328p
# Programmer id
# PROGID=wiring
PROGID=arduino
# Baud rate
BAUD=115200
# Linking Mode to use
# LD_MODE=avr6
LD_MODE=avr5

# 
# --------------------------------------------------

lcd:
	avr-gcc $(OPT) -g -DF_CPU=$(F_CPU) -mmcu=$(MMCU) $(INCLUDES) -o $(FILE).elf $(LIBS) $(FILE).c
	avr-objcopy -g -O ihex -R .eeprom $(FILE).elf $(FILE).hex

install:
	avrdude -C//etc/avrdude.conf -p$(PARTNO) -c$(PROGID) -P$(PORT) -b$(BAUD) -D -Uflash:w:$(FILE).hex:i

all: lcd install

clean:
	rm $(FILE).elf $(FILE).o $(FILE).hex
