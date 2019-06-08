USART_INIT:
    push r16
    push r17

ldi r16, 0
ldi r17, 103
sts UBRR0H, r16
sts UBRR0L, r17

lds r16, UCSR0B
set
bld r16, 4       ; RXEN0 is 4th bit
bld r16, 3       ; TXEN0 is 3rd bit
sts UCSR0B, r16

pop r17
pop r16
ret

USART_PUT:

push r16

1: 
    lds r16, UCSR0A
    sbrs r16, 5       ; bit 5 is UDRE
    rjmp 1b

sts UDR0, r18

pop r16
ret

USART_SEND:

push r18
push r19

1:
    ld r18, X+

cpi r18, 0      ; Z = 1 if r18 - 0 = 0
lds r19, SREG
sbrc r19, 1    ; 1 is Z bit 
rjmp 2f             ; if r18 is 0 (Z = 0) then return subroutine

call USART_PUT

rjmp 1b

2:
    pop r19
    pop r18
    ret

USART_HEX:
    push r16
    push r17
    push r18
    push r19

ldi r19, 0b1111

1:
    mov r16, XH
    lsr r16
    lsr r16
    lsr r16
    lsr r16

cpi r16, 0x0a
    brlo 2f
    ;; It is a digit between 0x0a to 0x0f
    subi r16, 0x0a
    ldi r17, 65     ;; 65 is ASCII for "A"
    add r16, r17
    mov r18, r16
    rcall USART_PUT    
    rjmp 3f
2: 
    ;; It is a number between 0x01 to 0x09
    ldi r17, 48     ;; 48 is ASCII for "0"
    add r16, r17
    mov r18, r16
    rcall USART_PUT
    rjmp 3f

3:
    lsr r19 ;; reduce one bit from the counter

    lsl XH
    lsl XH
    lsl XH
    lsl XH

    cpi r19, 0b0000
    breq 4f  ;; r19 counter is zero, return.

    cpi r19, 0b0011
    brne 1b  ;; r19 counter is working!

    ;; counter is 0b0011: work with XL
    mov XH, XL
    rjmp 1b

4:
    ;; XL and XH is 0x00! return!
    pop r19
    pop r18
    pop r17
    pop r16
    ret
