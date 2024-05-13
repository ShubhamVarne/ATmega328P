;Author : Shubham Varne
;Goal   : To connect switch in pull up configuration
;	  LED will be ON for the duration of time in which switch is in ON state
;	  LED will be OFF for all other time		


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
	LDI R16, 0x08
	OUT SPH, R16
	LDI R16, 0xFF
	OUT SPL, R16

	SBI DDRB, 5	;making pin PB5 as a output pin
	LDI R20, 0x02	; 0000 0010
	STS TIMSK0, R20	;Enabling Timer0 Output Compare A interrupt
	SEI
	LDI R20, 0x00	;starting timer count from 0
	OUT TCNT0, R20
	LDI R20, 0xF0
	OUT OCR0A, R20	;keeping OxF0 in Output compare register
	LDI R20, 0x02	;0000 0010
	OUT TCCR0A, R20	;operating Timer0 in Capture Compare mode
	LDI R20, 0x05	;0000 0101 
	OUT TCCR0B, R20	;using prescalar of clk/1024
	OUT DDRC,R20	;make PORTC input
	LDI R20,0xFF
	OUT PORTC,R20	;enable pull-up resistors
	OUT DDRD,R20	;make PORTD output
HERE:
	IN R20,PINC	;read from PORTC
	OUT PORTD,R20	;give it to PORTD
	JMP HERE	;keeping CPU busy waiting for interrupt

	RET

;ISR for Timer0 Compare match A
.global	__vector_14
	.type	__vector_14, @function

__vector_14:

	IN R16,PORTB	;read PORTB
	LDI R17,0x20	;0010 0000 for toggling PB5
	EOR R16,R17
	OUT PORTB,R16	;toggle PB5
	LDI R16,0x00	; 
	OUT TCNT0,R16	;load Timer0 with 0 (for next round)
	RETI	

;;as we had connected switch in pull up configuration
;;when switch is in OFF state, micro-controller will read logic HIGH
;;due to pull up configuration
;;as soon as switch state changed to OFF, micro-controller will read
;;LOGIC LOW
	
