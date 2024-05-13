;Author : Shubham Varne
;Goal   : To connect switch in pull up configuration
;	  LED will be ON for the duration of time in which switch is in ON state
;	  LED will be OFF for all other time		


;We will define registers needed for this code
.EQU	PORTB,	0x05	
.EQU	DDRB,	0x04
.EQU	DDRD,	0x0A
.EQU 	PORTD,	0x0B
.EQU	PIND,	0x09
.EQU	RAMEND, 0x08FF
.EQU	SPH, 	0x3E
.EQU	SPL,	0X3D

.global	main
	.type	main, @function

.ORG 0

;;setting stack pointer
	LDI R16, 0x08
	OUT SPH, R16
	LDI R16, 0xFF
	OUT SPL, R16

main:

	CBI DDRD, 2	;setting pin PD2 as a input pin
	LDI R16, 0x20	;0010 0000
	OUT DDRB, R16	;making pin PB5 as a output pin

;;as we had connected switch in pull up configuration
;;when switch is in OFF state, micro-controller will read logic HIGH
;;due to pull up configuration
;;as soon as switch state changed to OFF, micro-controller will read
;;LOGIC LOW

AGAIN:
	SBIC PIND, 2	;check status of PD2 weather it got cleared or not
			;skip next instruction if bit is cleared
	RJMP OVER
	LDI R16, 0x20	;if PD2 is 0 then we will make LED ON
	OUT PORTB, R16
	RJMP AGAIN

OVER:
	LDI R16, 0x00	;if PD2 is not cleared then we will make LED OFF
	OUT PORTB, R16
	RJMP AGAIN
	
	RET
