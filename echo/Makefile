# File to compile
FILE=main

# Compiling variables
# --------------------------------------------------

# Instruction set architecture (ISA):
# MMCU=atmega2560
MMCU=atmega328p

# Optimizations (For debugging with simavr you should deactivate this)
OPT=-Os

# Include this C headers
INCLUDES=-I/usr/avr/include/avr

# CPU Frequency
F_CPU=16000000UL

# Flashing variables
# --------------------------------------------------

# Port to use
PORT=/dev/ttyUSB1
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


all:
# avr-gcc $(OPT) -DF_CPU=$(F_CPU) -mmcu=$(MMCU) $(INCLUDES) -o $(FILE).elf $(FILE).c
	avr-as -g -mmcu=$(MMCU) -o $(FILE).o $(FILE).asm
	avr-ld -g -m$(LD_MODE) -o $(FILE).elf $(FILE).o
	avr-objcopy -g -O ihex -R .eeprom $(FILE).elf $(FILE).hex

install: all
	avrdude -C//etc/avrdude.conf -p$(PARTNO) -c$(PROGID) -P$(PORT) -b$(BAUD) -D -Uflash:w:$(FILE).hex:i


clean:
	rm $(FILE).elf $(FILE).o $(FILE).hex
