;Author : Shubham Varne
;Goal   : Timer0 will be configured in Capture Compare Mode(CTC) with prescalar clk/1024
;	  OCR0A and OCR0B register will have intial value and when TCNT reaches that value
;	  an interrupt should occur, we will write ISR routine in which we will toggle
;	  PB5 and PC0 LED
;	  Also we will check waveform generation on pin PD5 and PD6


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
.EQU	TCCR0A,	0x24
.EQU	TCCR0B, 0x25
.EQU	TCNT0,	0x26
.EQU	OCR0B,	0x28
.EQU	OCR0A,	0x27

.EQU	EICRA,	0x69	; MEMORY SPACE ADDRESS
.EQU	TIMSK0,	0x6E	; MEMORY MAPPED

.EQU    RAMEND, 0x08FF

.global	main
	.type	main, @function

main:

;;setting stack pointer
	LDI	R16,	0x08
	OUT	SPH,	R16
	LDI	R16,	0xFF
	OUT 	SPL,	R16

	SBI 	DDRB,	5	;making pin PB5 as a output pin for channel B interrupt
	SBI 	DDRC,	0	;making pin PC0 as a output pin for channel A interrupt
	SBI	DDRD,	5	;making pin PD5 as a output pin for channel B waveform
	SBI 	DDRD,	6 	;making pin PD6 as a output pin for channel A waveform

	LDI	R20, 	0x06	; 0000 0110
	STS	TIMSK0, R20	;Enabling TOC0A and TOC0B interrupt

	SEI

	LDI 	R20, 	0x00	;starting timer count from 0
	OUT 	TCNT0, 	R20

	LDI 	R20, 	0xF0
	OUT 	OCR0A, 	R20	;keeping OxF0 in Output compare A register

	LDI 	R20, 	0xEE
	OUT 	OCR0B, 	R20	;keeping 0xEE in Output compare B register

	LDI 	R20, 	0x52	;0101 0010
	OUT 	TCCR0A, R20	;operating Timer0 in Capture Compare mode
				;waveform generation option selected to toggle
				;OC0A and OC0B pin whenever interrupt occur

	LDI 	R20, 	0x05	;0000 0101 
	OUT 	TCCR0B, R20	;using prescalar of clk/1024
	
HERE:
	JMP 	HERE		;keeping CPU busy waiting for interrupt

	RET

;ISR for Timer0 Compare match B
.global	__vector_15
	.type	__vector_15, 	@function

__vector_15:

	IN 	R16, 	PORTB	;read PORTB
	LDI 	R17, 	0x20	;0010 0000 for toggling the pin
	EOR 	R16, 	R17
	
	OUT 	PORTB, 	R16	;toggle PB5
	RETI	


;ISR for Timer0 Compare match A
.global __vector_14
	.type __vector_14, 	@function

__vector_14:
	
	IN 	R16, 	PORTC	;read PORTC
	LDI 	R17, 	0x01	;0000 0001
	EOR	R16,	R17
	
	OUT	PORTC,	R16	;toggle PC0
	RETI

;;as we had connected switch in pull up configuration
;;when switch is in OFF state, micro-controller will read logic HIGH
;;due to pull up configuration
;;as soon as switch state changed to OFF, micro-controller will read
;;LOGIC LOW
	
