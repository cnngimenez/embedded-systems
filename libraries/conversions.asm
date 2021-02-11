;; Copyright 2021 Christian Gimenez
	   
;; Author: Christian Gimenez

;; usart-lib.asm
	   
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
BYTE2HEX:
        push r16
        push r19

        mov r19, r16

        ;; Convert the lower 4 bits
        andi r16, 0b00001111
        rcall .4bits_to_hex
        mov r18, r17

        mov r16, r19

        ;; Convert the higher 4 bits
        andi r16, 0b11110000
        lsr r16
        lsr r16
        lsr r16
        lsr r16
        rcall .4bits_to_hex

        mov r19, r17    
        mov r17, r18
        mov r18, r19
        
        pop r19
        pop r16
        ret

.4bits_to_hex:
	    push r16

	    andi r16, 0b00001111
        cpi r16, 10
        brlo 1f
        ;; r16 is greater or equal than 10
        subi r16, 10
        ldi r17, 'A'
        add r16, r17
        rjmp 2f
1:
        ;; r16 is lower than 10
        ldi r17, '0'
        add r16, r17
2:
        pop r16
        ret
BYTE2DECSTR:
	push r16
	push r20
	push r21

	ldi r17, 10

	rcall DIV
	mov r16, r18
	mov r21, r19		; r21 = first digit

	rcall DIV
	mov r16, r18
	mov r20, r19		; r20 = second digit

	rcall DIV		; r19 = third digit

	ldi r17, '0'
	add r17, r21		; r17 = firts ASCII digit
	ldi r18, '0'
	add r18, r20		; r18 = second ASCII digit
	ldi r20, '0'
	add r19, r20		; r19 = third ASCII digit

	pop r21
	pop r20
	pop r16
	ret
DIV:
	push r16		; N
	push r17		; D
	push r20		; i

	ldi r18, 0		; Q := 0;
	ldi r19, 0		; R := 0;

	;; if N = 0 (0/D = 0) then return
	cpi r16, 0
	breq 3f
	;; if N = D then return 1
	cp r16, r17
	brne 1f
	ldi r18, 1
	rjmp 3f
1:
	;; if D = 1 (N/1 = N) then return N
	cpi r17, 1		
	brne 4f
	mov r18, r16
	rjmp 3f

4:
	;; Division algorithm
	ldi r20, 8		; for i := 7 .. 0 loop
1:
	lsl r19			; R := R << 1;

				; R(0) := N(i);
	sbrc r16, 7		;     if N(i) is 0, skip instruction
	ori r19, 0x01
	lsl r16			;     simmulates next indexing

	cp r19, r17		; if R >= D then
	brlo 2f
	;; R >= D
	sub r19, r17		; R := R - D;

	ori r18, 0x01		; Q(i) := 1; (continues with lsl r18)
2:
	lsl r18 		; (Part of the Q(i) := 1 or Q(i) := 0).
	dec r20			; end loop;
	cpi r20, 0
	brne 1b

	lsr r18
3:
	pop r20
	pop r17
	pop r16
	ret
DIV16:
	push r16		; NL
	push r17		; NH
	push r18		; DL
	push r19		; DH
	push r24		; i

	ldi r20, 0		; Q := 0;
	ldi r21, 0
	ldi r22, 0		; R := 0;
	ldi r23, 0

	;; if N = 0 (0/D = 0) then set results to 0
	cpi r17, 0
	brne 1f
	cpi r16, 0
	brne 1f
	rjmp 3f
1:	
	;; if D = 1 (N/1 = N) then copy N to Q
	cpi r19, 0
	brne 4f
	cpi r18, 1		
	brne 4f
	mov r20, r16
	mov r21, r17	
	rjmp 3f

	;; Division Algorithm
4:
	ldi r24, 16		; for i := 16 .. 1 loop
1:
	clc			; R := R << 1;
	rol r22
	rol r23

				; R(0) := N(i);
	sbrc r17, 7		;     if N(i) is 0, skip instruction
	ori r22, 0x01
	clc			;     simmulates next indexing
	rol r16
	rol r17

	cp r23, r19		; if R >= D then
	brlo 2f
	cp r22, r18
	brlo 2f	
	;; R >= D
	clc			; R := R - D;
	sbc r22, r18
	sbc r23, r19

	ori r20, 0x01		; Q(i) := 1; (continues with lsl r18)
2:
	clc			; (Part of the Q(i) := 1 or Q(i) := 0).
	rol r20
	rol r21
	dec r24			; end loop;
	cpi r24, 0
	brne 1b

	clc
	ror r21
	ror r20
3:
	pop r24
	pop r19
	pop r18
	pop r17
	pop r16
	ret
