#define USART1_OSC_FREQUENCY 16000000UL // 16MHz
#define USART1_BAUD_RATE 9600 // bps

// Apply the UBRR formulae according to the Atmega 328 datasheet.
#define USART1_BRR_VALUE (unsigned long) round(USART1_OSC_FREQUENCY/16.0/USART1_BAUD_RATE) - 1

#define USART1_RX_ENABLE 1
#define USART1_TX_ENABLE 1

// #define USART1_RX_INT_ENABLE_1 1
// #define USART1_TX_INT_ENABLE_1 1
// #define USART1_UDR_INT_ENABLE_1 1

// #define USART1_CHARACTER_SIZE_5 1
// #define USART1_CHARACTER_SIZE_6 1
// #define USART1_CHARACTER_SIZE_7 1
#define USART1_CHARACTER_SIZE_8 1
// #define USART1_CHARACTER_SIZE_9 1

#define USART1_ASYNC_MODE 1
// #define USART1_SYNC_MODE 1
// #define USART1_MASTER_SPI_MODE 1

#define USART1_PARITY_CHECK_DISABLE 1
// #define USART1_PARITY_CHECK_ODD 1
// #define USART1_PARITY_CHECK_EVEN 1

#define USART1_STOP_BIT_ONE 1
// #define USART1_STOP_BIT_TWO 1

#define USART1_POLARITY_TX_RISING 1
// #define USART1_POLARITY_TX_FALLING 1
