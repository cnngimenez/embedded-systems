;; Copyright 2019 Christian Gimenez
	   
;; Author: Christian Gimenez

;; wait-lib.asm
	   
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

;; Registers used:
	;; r17, r18, r19
WAIT:
    push r17
    push r18
    push r19

ldi r17, 0
ldi r18, 0
ldi r19, 0

1:
	nop
	nop
	nop
	nop
	nop

inc r17
cpi r17, 0xff
breq 2f

rjmp 1b

2:
	;; check if the high value is UPPER
	ldi r17, 0

inc r18
cpi r18, 0xff
brne 1b

3:
	ldi r18, 0

inc r19
cp r19, r16
brne 1b

pop r19
pop r18
pop r17
  ret			; UPPER waiting limit achieved

WAITMS:
    push r17

ldi r17, 0

1: 
    rcall _onems

    inc r17
    cp r17, r16
    brne 1b

pop r17
ret

_onems:
    push XL
    push XH

ldi XL, 0
ldi XH, 0

1:
    adiw X, 1          ;; 2c

    cpi XL, lo8(2635)  ;; 1c
    brne 1b            ;; 1/2c
    cpi XH, hi8(2635)  ;; 1c
    brne 1b            ;; 1/2c

pop XH
pop XL
ret

WAITUS:
    push r17

ldi r17, 0

1:
    rcall _wait_oneus
    inc r17
    cp r17, r16
    brne 1b

pop r17
ret

_wait_oneus:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret
