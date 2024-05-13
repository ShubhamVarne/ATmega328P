;Author : Shubham Varne
;Goal   : To connect switch in pull down configuration
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

	CBI DDRD, 3	;setting pin PD3 as a input pin
	LDI R16, 0x20	;0010 0000
	OUT DDRB, R16	;making pin PB5 as a output pin

;;as we had connected switch in pull down configuration
;;when switch is in OFF state, micro-controller will read logic LOW
;;due to pull down configuration
;;as soon as switch state changed to OFF, micro-controller will read
;;LOGIC HIGH

AGAIN:
	SBIS PIND, 3	;check status of PD3 weather it got set or not
			;skip next instruction if bit is set
	RJMP OVER
	LDI R16, 0x20	;if PD3 is 1 then we will make LED ON
	OUT PORTB, R16
	RJMP AGAIN

OVER:
	LDI R16, 0x00	;if PD3 is not set then we will make LED OFF
	OUT PORTB, R16
	RJMP AGAIN
	
	RET
