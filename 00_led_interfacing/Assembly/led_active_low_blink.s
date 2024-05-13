;Author : Shubham Varne
;Goal   : To glow LED connected in active low configuration

;We will define registers needed for this code
.EQU	PORTC,	0x08
.EQU	DDRC,	0x07
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
	LDI R16, 0x01
	OUT DDRC, R16  ;making PC0 pin of DDRC as output
AGAIN:
	COM R16
	OUT PORTC, R16 ;sending Logic LOW for PC0
		       ;on PORTC to make LED ON in active
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
