;Author : Shubham Varne
;Goal   : Timer0 is configured in Capture Compare Mode and prescalar clk/1024
;	  Output compare register A is loaded with initial value and when it match with
;	  Timer/Counter register value OVA0F flag will be raised
;	  We will be checking the status of OVA0F flag contineously in delay function
;	  which purpose will be to provide delay between LED ON and OFF operation		


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
	LDI 	R16, 	0x08
	OUT 	SPH, 	R16
	LDI 	R16, 	0xFF
	OUT 	SPL, 	R16

	SBI 	DDRB, 	5	;making pin PB5 as a output pin
	
	LDI 	R20, 	0x00	;starting timer count from 0
	OUT 	TCNT0, 	R20

	LDI 	R20, 	0xF0
	OUT 	OCR0A, 	R20	;keeping OxF0 in Output compare register
	
	LDI 	R20, 	0x02	;0000 0010
	OUT 	TCCR0A, R20	;operating Timer0 in Capture Compare mode
	
	LDI 	R20, 	0x05	;0000 0101 
	OUT 	TCCR0B, R20	;using prescalar of clk/1024
	
AGAIN:
	IN	R20,	PORTB
	LDI	R21,	0x20
	EOR	R20,	R21
	OUT	PORTB,	R20
	RCALL 	Delay
	JMP 	AGAIN	

	RET

;Delay function for Timer0 Compare match A
.global	Delay
	.type	Delay, 	@function

Delay:
BACK:
	SBIS 	TIFR0,	1	;skip next instruction if OC0AF flag is set
	RJMP 	BACK


	LDI 	R17,	0x02	;0000 0010 
	OUT 	TIFR0,	R17	;to set OCA0F flag maually


	LDI 	R16,	0x00	; 
	OUT 	TCNT0,	R16	;load Timer0 with 0 (for next round)
	
	RET

;;as we had connected switch in pull up configuration
;;when switch is in OFF state, micro-controller will read logic HIGH
;;due to pull up configuration
;;as soon as switch state changed to OFF, micro-controller will read
;;LOGIC LOW
	
