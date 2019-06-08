lds r16, UCSR0B
set
bst r16, 4       ; RXEN0 bit enabled
bst r16, 3       ; TXEN0 bit enabled
sts UCSR0B, r16
