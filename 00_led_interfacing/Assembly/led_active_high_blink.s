;Author : Shubham Varne
;Goal   : To glow LED connected in active high configuration

;We will define registers needed for this code
.EQU	PORTB,	0x05
.EQU	DDRB,	0x04
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
	LDI R16, 0x20
	OUT DDRB, R16  ;making PB5 pin of DDRB as output
AGAIN:
	COM R16
	OUT PORTB, R16 ;sending Logic LOW for PB5
		       ;on PORTB to make LED ON in active
		       ;high configuration
	CALL DELAY
	RJMP AGAIN

DELAY:
	LDI R17, 100
	LOOP3:
		LDI R18, 0XFF
		LOOP2:
			LDI R19, 0XFF
			LOOP1:
				DEC R19
				BRNE LOOP1
			DEC R18
			BRNE LOOP2
		DEC R17
		BRNE LOOP3
		
	RET	
