# File to compile
ifndef FILE
FILE=lcd-send
endif

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

usart:
	avr-gcc $(OPT) -g -DF_CPU=$(F_CPU) -mmcu=$(MMCU) $(INCLUDES) -o usart_send.elf ../usart-lib.c usart_send.c
	avr-objcopy -g -O ihex -R .eeprom usart_send.elf usart_send.hex

install_usart: usart
	avrdude -C//etc/avrdude.conf -p$(PARTNO) -c$(PROGID) -P$(PORT) -b$(BAUD) -D -Uflash:w:usart_send.hex:i

lcd:
	avr-gcc $(OPT) -g -DF_CPU=$(F_CPU) -mmcu=$(MMCU) $(INCLUDES) -o lcd_send.elf ../lcd-lib.c lcd-send.c
	avr-objcopy -g -O ihex -R .eeprom lcd_send.elf lcd_send.hex

install_lcd: lcd
	avrdude -C//etc/avrdude.conf -p$(PARTNO) -c$(PROGID) -P$(PORT) -b$(BAUD) -D -Uflash:w:lcd_send.hex:i

all: usart lcd

clean:
	rm $(FILE).elf $(FILE).o $(FILE).hex
