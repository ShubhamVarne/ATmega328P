;Author : Shubham Varne
;Goal   : Timer0 is configured in Capture Compare(CTC) Mode and prescalar clk/1024
;	  Output compare registers A and B will be loaded and when their value matches
;	  with Timer/Counter register then respective Flag will be raised in TIFR register
;	  We have two seperate function which will be continously checking status of this
;	  Flag. We had kept LEDs PB5 and PC0 contineously on in this fucntion
;	  once flag is raised
;	  We are also checking waveform generation on pin PD6 and PD5



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
.EQU	TIFR0,	0x15

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

	SBI 	DDRB,	5	;making pin PB5 as a output pin for channel A delay
	SBI 	DDRC,	0	;making pin PC0 as a output pin for channel B delay
	SBI	DDRD,	5	;making pin PD5 as a output for channel B waveform
	SBI	DDRD,	6	;making pin PD6 as a output for channel A waveform

	LDI 	R20, 	0x00	;starting timer count from 0
	OUT 	TCNT0, 	R20

	LDI 	R20, 	0xFA
	OUT 	OCR0A, 	R20	;keeping OxF0 in Output compare A register

	LDI 	R20, 	0xDE
	OUT 	OCR0B, 	R20	;keeping 0xEE in Output compare B register

	LDI 	R20, 	0x52	;0101 0010
	OUT 	TCCR0A, R20	;operating Timer0 in Capture Compare mode
				;waveform generation option selected to toggle
				;OC0A and OC0B pin whenever interrupt occur

	LDI 	R20, 	0x05	;0000 0101 
	OUT 	TCCR0B, R20	;using prescalar of clk/1024
	
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
	SBIS	TIFR0,	1
	RJMP 	AGAIN_A
		
	LDI 	R16, 	0x20	;0010 0000 for toggling PB5
	OUT 	PORTB, 	R16	;toggle PB5
	
	LDI	R16, 	0x02	;we are going to write 1 manuall in OC0AF Flag
	OUT	TIFR0,	R16
	RET	


;function for Timer0 Compare match B
.global Delay_B
	.type 	Delay_B, 	@function

Delay_B:
	
AGAIN_B:
	SBIS	TIFR0,	2
	RJMP	AGAIN_B

	LDI 	R16, 	0x01	;0000 0001
	OUT	PORTC,	R16
	
	LDI	R16, 	0x04	;we are going to write 1 manually in OC0BF Flag
	OUT	TIFR0,	R16

	RET

;;as we had connected switch in pull up configuration
;;when switch is in OFF state, micro-controller will read logic HIGH
;;due to pull up configuration
;;as soon as switch state changed to OFF, micro-controller will read
;;LOGIC LOW
	
