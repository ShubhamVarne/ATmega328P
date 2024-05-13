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
.EQU	PIND,	0x09
.EQU	SPH, 	0x3E
.EQU	SPL,	0X3D
.EQU	EIMSK,	0x1D

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

	CBI DDRD, 2	;setting pin PD2 as a input pin
	SBI PORTD, 2	;pull up activation for PD2
	SBI DDRB, 5	;making pin PB5 as a output pin

	SBI EIMSK, 0	;Enabling INT0 interrupt
	LDI R16, 0x00
	STS EICRA, R16	;Low level triggering of Interrupt
	SEI

HERE:
	JMP HERE	;CPU wait for infinite time for Interrupt
			;to occur

	RET

;;ISR for  INT0 interrupt
.global	__vector_1
	.type	__vector_1, @function

__vector_1:

	IN R21, PORTB	;Current value of PORTB copying into R21
	LDI R22, 0x20	;0010 0000 
	EOR R21, R22	;Ex-OR operation to toggle value present in PORTB
	OUT PORTB, R21	;Toggled value will be written on PORTB again
	RETI

;;as we had connected switch in pull up configuration
;;when switch is in OFF state, micro-controller will read logic HIGH
;;due to pull up configuration
;;as soon as switch state changed to OFF, micro-controller will read
;;LOGIC LOW
	
