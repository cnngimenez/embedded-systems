type
  Reg = ptr uint8

  Pin = tuple
    pinb : Reg # 0x23
    ddrb : Reg # 0x24
    portb: Reg # 0x25

  Timer = tuple
    tccr1a: Reg # 0x80
    tccr1b: Reg # 0x81
    tccr1c: Reg # 0x82
    res1  : Reg # 0x83
    tcnt1l: Reg # 0x84
    tcnt1h: Reg # 0x85
    res2  : Reg # 0x86
    res3  : Reg # 0x87
    ocr1al: Reg # 0x88
    ocr1ah: Reg # 0x89
    ocr1bl: Reg # 0x8a
    ocr1bh: Reg # 0x8b
    # timsk1: Reg # 0x6f
    # tifr1 : Reg # 0x36

var
  pb {.volatile.}: Pin = cast[Pin] (0x23)
  # pinb {.volatile.}: Reg = cast[Reg] (0x23)
  # ddrb {.volatile.}: Reg = cast[Reg] (0x24)
  # portb {.volatile.}: Reg = cast[Reg] (0x25)
  
  tccr1a {.volatile.}: Reg = cast[Reg] (0x80)
  tccr1b {.volatile.}: Reg = cast[Reg] (0x81)
  tccr1c {.volatile.}: Reg = cast[Reg] (0x82)
  tcnt1h {.volatile.}: Reg = cast[Reg] (0x85)
  tcnt1l {.volatile.}: Reg = cast[Reg] (0x84)
  ocr1ah {.volatile.}: Reg = cast[Reg] (0x89)
  ocr1al {.volatile.}: Reg = cast[Reg] (0x88)
  ocr1bh {.volatile.}: Reg = cast[Reg] (0x8b)
  ocr1bl {.volatile.}: Reg = cast[Reg] (0x8a)
  timsk1 {.volatile.}: Reg = cast[Reg] (0x6f)
  tifr1  {.volatile.}: Reg = cast[Reg] (0x36)

proc delay1ms() =
  # Use the clock to wait 1ms

proc delay20us =
  # Use the clock to wait 20us 

proc send_petition =
  # Set the port to output mode
  ddrb[] = 0b0000_1000
  
  # Pull down for 1ms
  portb[] = 0x00
  delay1ms()
  # Pull up for 20 to 40us
  portb[] 0b0000_1000
  delay20us

proc start_receiving =
  # Set the port to input mode
  ddrb[] = 0b0000_0000
  
  while pinb[] == 0b0000_0000:
    discard

  start_clock()
  while pinb[] == 0b0000_1000:
    discard
  stop_clock()

  if clock > 28:
    add_one()
  else:
    add_zero()

# Send petition for retrieving data
send_petition()
# Receive data
start_receiving()
