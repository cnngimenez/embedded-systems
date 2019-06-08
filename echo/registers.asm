;; Copyright 2019 Christian Gimenez
	   
;; Author: Christian Gimenez

;; registers.asm
	   
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
	   
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
	   
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

	;; 
	;; This are register for the Arduino UNO.
	;; 
	
	;; Reserved (0xFF)  
	;; Reserved (0xFE)  
	;; Reserved (0xFD)  
	;; Reserved (0xFC)  
	;; Reserved (0xFB)  
	;; Reserved (0xFA)  
	;; Reserved (0xF9)  
	;; Reserved (0xF8)  
	;; Reserved (0xF7)  
	;; Reserved (0xF6)  
	;; Reserved (0xF5)  
	;; Reserved (0xF4)  
	;; Reserved (0xF3)  
	;; Reserved (0xF2)  
	;; Reserved (0xF1)  
	;; Reserved (0xF0)  
	;; Reserved (0xEF)  
	;; Reserved (0xEE)  
	;; Reserved (0xED)  
	;; Reserved (0xEC)  
	;; Reserved (0xEB)  
	;; Reserved (0xEA)  
	;; Reserved (0xE9)  
	;; Reserved (0xE8)  
	;; Reserved (0xE7)  
	;; Reserved (0xE6)  
	;; Reserved (0xE5)  
	;; Reserved (0xE4)  
	;; Reserved (0xE3)  
	;; Reserved (0xE2)  
	;; Reserved (0xE1)  
	;; Reserved (0xE0)  
	;; Reserved (0xDF)  
	;; Reserved (0xDE)  
	;; Reserved (0xDD)  
	;; Reserved (0xDC)  
	;; Reserved (0xDB)  
	;; Reserved (0xDA)  
	;; Reserved (0xD9)  
	;; Reserved (0xD8)  
	;; Reserved (0xD7)  
	;; Reserved (0xD6)  
	;; Reserved (0xD5)  
	;; Reserved (0xD4)  
	;; Reserved (0xD3)  
	;; Reserved (0xD2)  
	;; Reserved (0xD1)  
	;; Reserved (0xD0)  
	;; Reserved (0xCF)  
	;; Reserved (0xCE)  
	;; Reserved (0xCD)  
	;; Reserved (0xCC)  
	;; Reserved (0xCB)  
	;; Reserved (0xCA)  
	;; Reserved (0xC9)  
	;; Reserved (0xC8)  
	;; Reserved (0xC7)  
	.set UDR0, 0xC6
	.set UBRR0H, 0xC5
	.set UBRR0L, 0xC4
	;; Reserved (0xC3)  
	.set UCSR0C, 0xC2
	.set UCSR0B, 0xC1
	.set UCSR0A, 0xC0
	;; Reserved (0xBF)  
	;; Reserved (0xBE)  
	.set TWAMR, 0xBD
	.set TWCR, 0xBC
	.set TWDR, 0xBB
	.set TWAR, 0xBA
	.set TWSR, 0xB9
	.set TWBR, 0xB8
	;; Reserved (0xB7)  
	.set ASSR, 0xB6
	;; Reserved (0xB5)  
	.set OCR2B, 0xB4
	.set OCR2A, 0xB3
	.set TCNT2, 0xB2
	.set TCCR2B, 0xB1
	.set TCCR2A, 0xB0
	;; Reserved (0xAF)  
	;; Reserved (0xAE)  
	;; Reserved (0xAD)  
	;; Reserved (0xAC)  
	;; Reserved (0xAB)  
	;; Reserved (0xAA)  
	;; Reserved (0xA9)  
	;; Reserved (0xA8)  
	;; Reserved (0xA7)  
	;; Reserved (0xA6)  
	;; Reserved (0xA5)  
	;; Reserved (0xA4)  
	;; Reserved (0xA3)  
	;; Reserved (0xA2)  
	;; Reserved (0xA1)  
	;; Reserved (0xA0)  
	;; Reserved (0x9F)  
	;; Reserved (0x9E)  
	;; Reserved (0x9D)  
	;; Reserved (0x9C)  
	;; Reserved (0x9B)  
	;; Reserved (0x9A)  
	;; Reserved (0x99)  
	;; Reserved (0x98)  
	;; Reserved (0x97)  
	;; Reserved (0x96)  
	;; Reserved (0x95)  
	;; Reserved (0x94)  
	;; Reserved (0x93)  
	;; Reserved (0x92)  
	;; Reserved (0x91)  
	;; Reserved (0x90)  
	;; Reserved (0x8F)  
	;; Reserved (0x8E)  
	;; Reserved (0x8D)  
	;; Reserved (0x8C)  
	.set OCR1BH, 0x8B
	.set OCR1BL, 0x8A
	.set OCR1AH, 0x89
	.set OCR1AL, 0x88
	.set ICR1H, 0x87
	.set ICR1L, 0x86
	.set TCNT1H, 0x85
	.set TCNT1L, 0x84
	;; Reserved (0x83)  
	.set TCCR1C, 0x82
	.set TCCR1B, 0x81
	.set TCCR1A, 0x80
	.set DIDR1, 0x7F
	.set DIDR0, 0x7E
	;; Reserved (0x7D)  
	.set ADMUX, 0x7C
	.set ADCSRB, 0x7B
	.set ADCSRA, 0x7A
	.set ADCH, 0x79
	.set ADCL, 0x78
	;; Reserved (0x77)  
	;; Reserved (0x76)  
	;; Reserved (0x75)  
	;; Reserved (0x74)  
	;; Reserved (0x73)  
	;; Reserved (0x72)  
	;; Reserved (0x71)  
	.set TIMSK2, 0x70
	.set TIMSK1, 0x6F
	.set TIMSK0, 0x6E
	.set PCMSK2, 0x6D
	.set PCMSK1, 0x6C
	.set PCMSK0, 0x6B
	;; Reserved (0x6A)  
	.set EICRA, 0x69
	.set PCICR, 0x68
	;; Reserved (0x67)  
	.set OSCCAL, 0x66
	;; Reserved (0x65)  
	.set PRR, 0x64
	;; Reserved (0x63)  
	;; Reserved (0x62)  
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
	;; Reserved 0x3C (0x5C)  
	;; Reserved 0x3B (0x5B)  
	;; Reserved 0x3A (0x5A)  
	;; Reserved 0x39 (0x59)  
	;; Reserved 0x38 (0x58)  
	.set OSPMCSR, 0x37
	.set SPMCSR, 0x57
	;; Reserved 0x36 (0x56)  
	.set OMCUCR, 0x35
	.set MCUCR, 0x55
	.set OMCUSR, 0x34
	.set MCUSR, 0x54
	.set OSMCR, 0x33
	.set SMCR, 0x53
	;; Reserved 0x32 (0x52)  
	;; Reserved 0x31 (0x51)  
	.set OACSR, 0x30
	.set ACSR, 0x50
	;; Reserved 0x2F (0x4F)  
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
	;; Reserved 0x29 (0x49)  
	.set OOCR0B, 0x28
	.set OCR0B, 0x48
	.set OOCR0A, 0x27
	.set OCR0A, 0x47
	.set OTCNT0, 0x26
	.set TCNT0, 0x46
	.set OTCCR0B, 0x25
	.set TCCR0B, 0x45
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
	;; Reserved 0x1A (0x3A)  
	;; Reserved 0x19 (0x39)  
	;; Reserved 0x18 (0x38)  
	.set OTIFR2, 0x17
	.set TIFR2, 0x37
	.set OTIFR1, 0x16
	.set TIFR1, 0x36
	.set OTIFR0, 0x15
	.set TIFR0, 0x35
	;; Reserved  0x14 (0x34)  
	;; Reserved  0x13 (0x33)  
	;; Reserved  0x12 (0x32)  
	;; Reserved  0x11 (0x31)  
	;; Reserved  0x10 (0x30)  
	;; Reserved  0x0F (0x2F)  
	;; Reserved  0x0E (0x2E)  
	;; Reserved  0x0D (0x2D)  
	;; Reserved  0x0C (0x2C)  
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
	;; Reserved  0x02 (0x22)  
	;; Reserved  0x01 (0x21)  
	;; Reserved  0x0 (0x20)  
