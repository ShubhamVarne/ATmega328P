;Author : Shubham Varne
;Goal   : Timer1 will be configured in Capture Compare Mode(CTC) with prescalar clk/1024
;	  OCR1A and OCR1B register will have intial value and when TCNT reaches that value
;	  an interrupt should occur, we will write ISR routine in which we will toggle
;	  PB5 and PC0 LED
;	  Also we will check waveform generation on pin PB1 and PB2


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
.EQU	TCNT1H,	0x85
.EQU	TCNT1L,	0x84
.EQU	OCR1AH,	0x89
.EQU	OCR1AL, 0x88
.EQU	OCR1BH, 0x8B
.EQU	OCR1BL,	0x8A	

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
	SBI	DDRB,	2	;making pin PD5 as a output pin for channel B waveform
	SBI 	DDRB,	1	;making pin PD6 as a output pin for channel A waveform

	LDI	R20, 	0x06	; 0000 0110
	STS	TIMSK1, R20	;Enabling TOC1A and TOC1B interrupt

	SEI

	LDI 	R20, 	0x00	;starting timer count from 0
	STS 	TCNT1H, R20
	STS	TCNT1L,	R20

	LDI 	R20, 	0x0F
	STS 	OCR1AH, R20	;keeping Ox0F0F in Output compare A register
	LDI	R20, 	0x0F
	STS	OCR1AL,	R20	

	LDI 	R20, 	0x04
	STS 	OCR1BH, R20	;keeping 0x04FF in Output compare B register
	LDI	R20,	0xFF	
	STS	OCR1BL,	R20
	
	LDI 	R20, 	0x50	;0101 0000
	STS 	TCCR1A, R20	;operating Timer1 in Capture Compare mode
				;waveform generation option selected to toggle
				;OC1A and OC1B pin whenever interrupt occur

	LDI 	R20, 	0x0D	;0000 1101 
	STS 	TCCR1B, R20	;using prescalar of clk/1024
	
HERE:
	JMP 	HERE		;keeping CPU busy waiting for interrupt

	RET

;ISR for Timer1 Compare match B
.global	__vector_12
	.type	__vector_12, 	@function

__vector_12:

	IN 	R16, 	PORTB	;read PORTB
	LDI 	R17, 	0x20	;0010 0000 for toggling the pin
	EOR 	R16, 	R17
	
	OUT 	PORTB, 	R16	;toggle PB5
	RETI	


;ISR for Timer1 Compare match A
.global __vector_11
	.type __vector_11, 	@function

__vector_11:
	
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
	
