	;; I/O SRAM from 0x60 to 0x1ff can be accessed with
	;; ST, STS, STD, LD, LDS, LDD instructions.
	;; Below of 0x60 can be accessed with OUT and IN.
	;; 
	;; Macros without preffix can be accessed with the above instructions.
	;; Macros with O preffix can be accessed with OUT and IN instructions.
	
	;; __________________________________________________
	;; Reserved, 0x1FF 
	;; ...	Reserved		
	;; Reserved, 0x13F 
	;; Reserved, 0x13E 
	;; Reserved, 0x13D 
	;; Reserved, 0x13C 
	;; Reserved, 0x13B 
	;; Reserved, 0x13A 
	;; Reserved, 0x139 
	;; Reserved, 0x138 
	;; Reserved, 0x137 
	.set UDR3, 0x136 
	.set UBRR3H, 0x135 
	.set UBRR3L, 0x134 
	;; Reserved, 0x133
	.set UCSR3C, 0x132  
	.set UCSR3B, 0x131 
	.set UCSR3A, 0x130 
	;; Reserved, 0x12F 
	;; Reserved, 0x12E 
	.set OCR5CH, 0x12D 
	.set OCR5CL, 0x12C 
	.set OCR5BH, 0x12B 
	.set OCR5BL, 0x12A 
	.set OCR5AH, 0x129 
	.set OCR5AL, 0x128 
	.set ICR5H, 0x127 
	.set ICR5L, 0x126 
	.set TCNT5H, 0x125 
	.set TCNT5L, 0x124 
	;; Reserved, 0x123 
	.set TCCR5C, 0x122 
	.set TCCR5B, 0x121 
	.set TCCR5A, 0x120  
	;; Reserved, 0x11F 
	;; Reserved, 0x11E 
	;; Reserved, 0x11D 
	;; Reserved, 0x11C 
	;; Reserved, 0x11B 
	;; Reserved, 0x11A 
	;; Reserved, 0x119 
	;; Reserved, 0x118 
	;; Reserved, 0x117 
	;; Reserved, 0x116 
	;; Reserved, 0x115 
	;; Reserved, 0x114 
	;; Reserved, 0x113 
	;; Reserved, 0x112 
	;; Reserved, 0x111 
	;; Reserved, 0x110 
	;; Reserved, 0x10F 
	;; Reserved, 0x10E 
	;; Reserved, 0x10D 
	;; Reserved, 0x10C 
	.set PORTL, 0x10B  
	.set DDRL, 0x10A 
	.set PINL, 0x109  
	.set PORTK, 0x108  
	.set DDRK, 0x107 
	.set PINK, 0x106  
	.set PORTJ, 0x105  
	.set DDRJ, 0x104 
	.set PINJ, 0x103  
	.set PORTH, 0x102  
	.set DDRH, 0x101 
	.set PINH, 0x100 
	;; Reserved, 0xFF 
	;; Reserved, 0xFE 
	;; Reserved, 0xFD 
	;; Reserved, 0xFC 
	;; Reserved, 0xFB 
	;; Reserved, 0xFA 
	;; Reserved, 0xF9 
	;; Reserved, 0xF8 
	;; Reserved, 0xF7 
	;; Reserved, 0xF6 
	;; Reserved, 0xF5 
	;; Reserved, 0xF4 
	;; Reserved, 0xF3 
	;; Reserved, 0xF2 
	;; Reserved, 0xF1 
	;; Reserved, 0xF0 
	;; Reserved, 0xEF 
	;; Reserved, 0xEE 
	;; Reserved, 0xED 
	;; Reserved, 0xEC 
	;; Reserved, 0xEB 
	;; Reserved, 0xEA 
	;; Reserved, 0xE9 
	;; Reserved, 0xE8 
	;; Reserved, 0xE7 
	;; Reserved, 0xE6 
	;; Reserved, 0xE5 
	;; Reserved, 0xE4 
	;; Reserved, 0xE3 
	;; Reserved, 0xE2 
	;; Reserved, 0xE1 
	;; Reserved, 0xE0 
	;; Reserved, 0xDF 
	;; Reserved, 0xDE 
	;; Reserved, 0xDD 
	;; Reserved, 0xDC 
	;; Reserved, 0xDB 
	;; Reserved, 0xDA 
	;; Reserved, 0xD9 
	;; Reserved, 0xD8 
	;; Reserved, 0xD7 
	.set UDR2, 0xD6 
	.set UBRR2H, 0xD5 
	.set UBRR2L, 0xD4 
	;; Reserved, 0xD3 
	.set UCSR2C, 0xD2 
	.set UCSR2B, 0xD1 
	.set UCSR2A, 0xD0 
	;; Reserved, 0xCF 
	.set UDR1, 0xCE 
	.set UBRR1H, 0xCD 
	.set UBRR1L, 0xCC 
	;; Reserved, 0xCB 
	.set UCSR1C, 0xCA 
	.set UCSR1B, 0xC9 
	.set UCSR1A, 0xC8 
	;; Reserved, 0xC7 
	.set UDR0, 0xC6 
	.set UBRR0H, 0xC5 
	.set UBRR0L, 0xC4 
	;; Reserved, 0xC3 
	.set UCSR0C, 0xC2 
	.set UCSR0B, 0xC1 
	.set UCSR0A, 0xC0 
	;; Reserved, 0xBF 
	;; Reserved, 0xBE 
	.set TWAMR, 0xBD 
	.set TWCR, 0xBC  
	.set TWDR, 0xBB 
	.set TWAR, 0xBA  
	.set TWSR, 0xB9  
	.set TWBR, 0xB8 
	;; Reserved, 0xB7 
	.set ASSR, 0xB6 
	;; Reserved, 0xB5 
	.set OCR2B, 0xB4 
	.set OCR2A, 0xB3 
	.set TCNT2, 0xB2 
	.set TCCR2B, 0xB1  
	.set TCCR2A, 0xB0  
	;; Reserved, 0xAF 
	;; Reserved, 0xAE 
	.set OCR4CH, 0xAD 
	.set OCR4CL, 0xAC 
	.set OCR4BH, 0xAB 
	.set OCR4BL, 0xAA 
	.set OCR4AH, 0xA9 
	.set OCR4AL, 0xA8 
	.set ICR4H, 0xA7 
	.set ICR4L, 0xA6 
	.set TCNT4H, 0xA5 
	.set TCNT4L, 0xA4 
	;; Reserved, 0xA3 
	.set TCCR4C, 0xA2  
	.set TCCR4B, 0xA1  
	.set TCCR4A, 0xA0  
	;; Reserved, 0x9F 
	;; Reserved, 0x9E 
	.set OCR3CH, 0x9D 
	.set OCR3CL, 0x9C 
	.set OCR3BH, 0x9B 
	.set OCR3BL, 0x9A 
	.set OCR3AH, 0x99 
	.set OCR3AL, 0x98 
	.set ICR3H, 0x97 
	.set ICR3L, 0x96 
	.set TCNT3H, 0x95 
	.set TCNT3L, 0x94 
	;; Reserved, 0x93 
	.set TCCR3C, 0x92  
	.set TCCR3B, 0x91  
	.set TCCR3A, 0x90  
	;; Reserved, 0x8F 
	;; Reserved, 0x8E 
	.set OCR1CH, 0x8D 
	.set OCR1CL, 0x8C 
	.set OCR1BH, 0x8B 
	.set OCR1BL, 0x8A 
	.set OCR1AH, 0x89 
	.set OCR1AL, 0x88 
	.set ICR1H, 0x87 
	.set ICR1L, 0x86 
	.set TCNT1H, 0x85 
	.set TCNT1L, 0x84 
	;; Reserved, 0x83 
	.set TCCR1C, 0x82  
	.set TCCR1B, 0x81  
	.set TCCR1A, 0x80  
	.set DIDR1, 0x7F 
	.set DIDR0, 0x7E  
	.set DIDR2, 0x7D  
	.set ADMUX, 0x7C  
	.set ADCSRB, 0x7B 
	.set ADCSRA, 0x7A  
	.set ADCH, 0x79 
	.set ADCL, 0x78 
	;; Reserved, 0x77 
	;; Reserved, 0x76 
	.set XMCRB, 0x75 
	.set XMCRA, 0x74 
	.set TIMSK5, 0x73 
	.set TIMSK4, 0x72 
	.set TIMSK3, 0x71 
	.set TIMSK2, 0x70 
	.set TIMSK1, 0x6F
	;; (0x6e) timer counter interrupt mask register 
	.set TIMSK0, 0x6E 
	.set PCMSK2, 0x6D 
	.set PCMSK1, 0x6C 
	.set PCMSK0, 0x6B 
	.set EICRB, 0x6A 
	.set EICRA, 0x69 
	.set PCICR, 0x68 
	;; Reserved, 0x67 
	.set OSCCAL, 0x66 
	.set PRR1, 0x65 
	.set PRR0, 0x64  
	;; Reserved, 0x63 
	;; Reserved, 0x62 
	.set CLKPR, 0x61  
	.set WDTCSR, 0x60 

	;; __________________________________________________
	;; 
	.set OSREG, 0x3F
	.set SREG, 0x5F 
	.set OSPH, 0x3E  
	.set SPH, 0x5E  
	.set OSPL, 0x3D  
	.set SPL, 0x5D  
	.set OEIND, 0x3C 
	.set EIND, 0x5C 
	.set ORAMPZ, 0x3B 
	.set RAMPZ, 0x5B 
	;; Reserved (0x5A)
	;; Reserved, 0x3A 
	;; Reserved (0x59)
	;; Reserved, 0x39 
	;; Reserved (0x58)
	;; Reserved, 0x38 
	.set OSPMCSR, 0x37 
	.set SPMCSR, 0x57 
	;; Reserved (0x56)
	;; Reserved, 0x36 
	.set OMCUCR, 0x35 
	.set MCUCR, 0x55 
	.set OMCUSR, 0x34 
	.set MCUSR, 0x54 
	.set OSMCR, 0x33 
	.set SMCR, 0x53 
	;; Reserved (0x52)
	;; Reserved, 0x32 
	.set OOCDR, 0x31  
	.set OCDR, 0x51  
	.set OACSR, 0x30 
	.set ACSR, 0x50 
	;; Reserved (0x4F)
	;; Reserved, 0x2F 
	.set OSPDR, 0x2E 
	.set SPDR, 0x4E 
	.set OSPSR, 0x2D 
	.set SPSR, 0x4D 
	.set OSPCR, 0x2C 
	.set SPCR, 0x4C 
	.set OGPIOR2, 0x2B 
	.set GPIOR2, 0x4B 
	.set OGPIOR1, 0x2A 
	.set GPIOR1, 0x4A 
	;; Reserved (0x49)
	;; Reserved, 0x29 
	;; 0x28 (0x48) ouput compare register A
	.set OOCR0B, 0x28 
	.set OCR0B, 0x48 
	.set OOCR0A, 0x27 
	.set OCR0A, 0x47
	;; 0x26 (0x46) Timer counter register
	.set OTCNT0, 0x26 
	.set TCNT0, 0x46
	;; 0x25 (0x45) Timer counter control register B
	.set OTCCR0B, 0x25
	.set TCCR0B, 0x45
	;; 0x25 (0x44) Timer counter control register A
	.set OTCCR0A, 0x24  
	.set TCCR0A, 0x44  
	.set OGTCCR, 0x23 
	.set GTCCR, 0x43 
	.set OEEARH, 0x22 
	.set EEARH, 0x42 
	.set OEEARL, 0x21 
	.set EEARL, 0x41 
	.set OEEDR, 0x20 
	.set EEDR, 0x40 
	.set OEECR, 0x1F 
	.set EECR, 0x3F 
	.set OGPIOR0, 0x1E 
	.set GPIOR0, 0x3E 
	.set OEIMSK, 0x1D 
	.set EIMSK, 0x3D 
	.set OEIFR, 0x1C  
	.set EIFR, 0x3C  
	.set OPCIFR, 0x1B 
	.set PCIFR, 0x3B 
	.set OTIFR5, 0x1A 
	.set TIFR5, 0x3A 
	.set OTIFR4, 0x19 
	.set TIFR4, 0x39 
	.set OTIFR3, 0x18 
	.set TIFR3, 0x38 
	.set OTIFR2, 0x17 
	.set TIFR2, 0x37 
	.set OTIFR1, 0x16 
	.set TIFR1, 0x36 
	.set OTIFR0, 0x15 
	.set TIFR0, 0x35 	
	.set OPORTG, 0x14 
	.set PORTG, 0x34 
	.set ODDRG, 0x13 
	.set DDRG, 0x33 
	.set OPING, 0x12 
	.set PING, 0x32 
	.set OPORTF, 0x11  
	.set PORTF, 0x31  
	.set ODDRF, 0x10  
	.set DDRF, 0x30  
	.set OPINF, 0x0F  
	.set PINF, 0x2F  
	.set OPORTE, 0x0E  
	.set PORTE, 0x2E  
	.set ODDRE, 0x0D  
	.set DDRE, 0x2D  
	.set OPINE, 0x0C  
	.set PINE, 0x2C  
	.set OPORTD, 0x0B  
	.set PORTD, 0x2B  
	.set ODDRD, 0x0A  
	.set DDRD, 0x2A  
	.set OPIND, 0x09  
	.set PIND, 0x29  
	.set OPORTC, 0x08  
	.set PORTC, 0x28  
	.set ODDRC, 0x07  
	.set DDRC, 0x27  
	.set OPINC, 0x06  
	.set PINC, 0x26  
	.set OPORTB, 0x05  
	.set PORTB, 0x25  
	.set ODDRB, 0x04  
	.set DDRB, 0x24  
	.set OPINB, 0x03  
	.set PINB, 0x23  
	.set OPORTA, 0x02  
	.set PORTA, 0x22  
	.set ODDRA, 0x01  
	.set DDRA, 0x21  
	.set OPINA, 0x00  
	.set PINA, 0x20
