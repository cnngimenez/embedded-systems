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

DIV:
	push r16		; N
	push r17		; D
	push r20		; i

	ldi r18, 0		; Q := 0;
	ldi r19, 0		; R := 0;

	cpi r17, 1		; if D = 1 (N/1 = N) then copy r16
	brne 4f
	mov r18, r16
	rjmp 3f

4:
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
