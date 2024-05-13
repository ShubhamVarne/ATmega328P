;Author : Shubham Varne
;Goal   : To connect switch in pull down configuration 
;	  LED will be ON for the duration of time in which switch is in ON state
;	  LED will be OFF for all other time		


;We will define registers needed for this code
;THIS are the IO space addresses
.EQU	PORTB,	0x05	
.EQU	DDRB,	0x04
.EQU	DDRD,	0x0A
.EQU 	PORTD,	0x0B
.EQU	PIND,	0x09
.EQU	SPH, 	0x3E
.EQU	SPL,	0X3D
.EQU	EIMSK,	0x1D
.EQU	MCUCR,	0x35

.EQU	EICRA,	0x69	; MEMORY SPACE ADDRESS

.EQU    RAMEND, 0x08FF

.global	main
	.type	main, @function

main:

;;setting stack pointer
	LDI R16, 0x08
	OUT SPH, R16
	LDI R16, 0xFF
	OUT SPL, R16

	LDI R16, 0x10
	OUT MCUCR, R16	;Disabling the internal Pull-ups
	CBI DDRD, 3	;setting pin PD3 as a input pin
	CBI PORTD, 3	;pull down activation for PD3
	SBI DDRB, 5	;making pin PB5 as a output pin

	SBI EIMSK, 1	;Enabling INT1 interrupt
	LDI R16, 0x04	; 0000 0100
	STS EICRA, R16	;Any logic change will triggering of Interrupt
	SEI

HERE:
	JMP HERE	;CPU wait for infinite time for Interrupt
			;to occur

	RET

;;ISR for  INT1 interrupt
.global	__vector_2
	.type	__vector_2, @function

__vector_2:

	IN R21, PORTB	;Current value of PORTB copying into R21
	LDI R22, 0x20	;0010 0000 
	EOR R21, R22	;Ex-OR operation to toggle value present in PORTB
	OUT PORTB, R21	;Toggled value will be written on PORTB again
	RETI
