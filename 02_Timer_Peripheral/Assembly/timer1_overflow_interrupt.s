;Author : Shubham Varne
;Goal   : Configure Timer1 in normal mode and prescalar clk/1024
;	  when Timer/Counter register reaches its maximum value it will generate
;	  Timer1 overflow interrupt and Timer/Counter register will reset to 0
;	  We had written ISR which will toggle PB5 LED whenever its get called


;We will define registers needed for this code
;THIS are the IO space addresses
.EQU	PORTB,	0x05	
.EQU	DDRB,	0x04
.EQU	DDRD,	0x0A
.EQU 	PORTD,	0x0B
.EQU	PINC,	0x06
.EQU	DDRC,	0x07
.EQU	PORTC,	0x08
.EQU	SPH, 	0x3E
.EQU	SPL,	0X3D
.EQU	EIMSK,	0x1D


.EQU	EICRA,	0x69	; MEMORY SPACE ADDRESS
.EQU	TIMSK1,	0x6F	; MEMORY MAPPED
.EQU	TCCR1A, 0x80
.EQU	TCCR1B, 0x81
.EQU	TCNT1H, 0x85
.EQU	TCNT1L, 0x84


.EQU    RAMEND, 0x08FF

.global	main
	.type	main, @function

main:

;;setting stack pointer
	LDI 	R16, 	0x08
	OUT 	SPH, 	R16
	LDI 	R16, 	0xFF
	OUT 	SPL, 	R16

	SBI 	DDRB, 	5	;making pin PB5 as a output pin

	LDI 	R20, 	0x01	; 0000 0001
	STS 	TIMSK1, R20	;Enabling Timer1 Overflow interrupt

	SEI

	LDI 	R20, 	0x00	;starting timer count from 0
	STS 	TCNT1H, R20
	STS	TCNT1L, R20
	
	LDI 	R20, 	0x00
	STS 	TCCR1A, R20	;operating Timer0 in normal mode
	
	LDI 	R20, 	0x05	;0000 0101 
	STS 	TCCR1B, R20	;using prescalar of clk/1024

HERE:
	JMP HERE	;keeping CPU busy waiting for interrupt

	RET



;ISR for Timer1
.global	__vector_13
	.type	__vector_13, @function

__vector_13:

	IN 	R16,	PORTB	;read PORTB
	LDI 	R17,	0x20	;0010 0000 for toggling PB5
	EOR 	R16,	R17
	OUT 	PORTB,	R16	;toggle PB5

	LDI 	R16,	0x00	; 
	STS 	TCNT1H, R16	;load Timer1 with 0 (for next round)
	STS	TCNT1L, R16
	RETI	
