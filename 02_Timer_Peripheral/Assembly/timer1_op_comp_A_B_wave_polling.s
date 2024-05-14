;Author : Shubham Varne
;Goal   : Timer1 is configured in Capture Compare(CTC) Mode and prescalar clk/1024
;	  Output compare registers A and B will be loaded and when their value matches
;	  with Timer/Counter register then respective Flag will be raised in TIFR register
;	  We have two seperate function which will be continously checking status of this
;	  Flag. We had kept LEDs PB5 and PC0 contineously on in this fucntion
;	  once flag is raised
;	  We are also checking waveform generation on pin PB1 and PB2



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
.EQU	TIFR1,	0x16

.EQU	EICRA,	0x69	; MEMORY SPACE ADDRESS
.EQU	TIMSK1,	0x6F	; MEMORY MAPPED
.EQU	TCCR1A, 0x80
.EQU	TCCR1B,	0x81
.EQU	TCNT1H,	0x85
.EQU	TCNT1L, 0x84
.EQU	OCR1AH, 0x89
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

	SBI 	DDRB,	5	;making pin PB5 as a output pin for channel A delay
	SBI 	DDRC,	0	;making pin PC0 as a output pin for channel B delay
	SBI	DDRB,	2	;making pin PB2 as a output for channel B waveform
	SBI	DDRB,	1	;making pin PB1 as a output for channel A waveform

	LDI 	R20, 	0x00	;starting timer count from 0
	STS 	TCNT1H, R20
	STS	TCNT1L,	R20

	LDI 	R20, 	0xFF
	STS 	OCR1AH, R20	;keeping OxFF00 in Output compare A register
	LDI	R20, 	0x00
	STS	OCR1AL, R20

	LDI 	R20, 	0x0F
	STS 	OCR1BH, R20	;keeping 0x0FFF in Output compare B register
	LDI	R20, 	0xFF
	STS	OCR1BL,	R20

	LDI 	R20, 	0x50	;0101 0000
	STS 	TCCR1A, R20	;operating Timer1 in Capture Compare mode
				;waveform generation option selected to toggle
				;OC1A and OC1B pin whenever interrupt occur

	LDI 	R20, 	0x0D	;0000 1101 
	STS 	TCCR1B, R20	;using prescalar of clk/1024
	
HERE:
	RCALL 	Delay_B

	RCALL 	Delay_A

	JMP 	HERE		;keeping CPU busy waiting for interrupt

	RET

;Function for Timer0 Compare match A
.global	Delay_A
	.type	Delay_A, 	@function

Delay_A:

AGAIN_A:
	SBIS	TIFR1,	1
	RJMP 	AGAIN_A
	
	IN	R17,	PORTB	
	LDI 	R16, 	0x20	;0010 0000 for toggling PB5
	EOR	R16, 	R17
	OUT 	PORTB, 	R16	;toggle PB5
	
	LDI	R16, 	0x02	;we are going to write 1 manuall in OC1AF Flag
	OUT	TIFR1,	R16
	RET	


;function for Timer0 Compare match B
.global Delay_B
	.type 	Delay_B, 	@function

Delay_B:
	
AGAIN_B:
	SBIS	TIFR1,	2
	RJMP	AGAIN_B

	IN	R17,	PORTC
	LDI 	R16, 	0x01	;0000 0001
	EOR	R16,	R17
	OUT	PORTC,	R16
	
	LDI	R16, 	0x04	;we are going to write 1 manually in OC1BF Flag
	OUT	TIFR1,	R16

	RET
	
