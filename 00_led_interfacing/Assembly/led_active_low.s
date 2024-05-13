;Author : Shubham Varne
;Goal   : To glow LED connected in active low configuration

;We will define registers needed for this code
.EQU	PORTC,	0x08
.EQU	DDRC,	0x07

.global	main
	.type	main, @function

.ORG 0

main:
	LDI R16, 0x01
	OUT DDRC, R16  ;making PC0 pin of DDRC as output
AGAIN:
	LDI R17, 0x00
	OUT PORTC, R17 ;sending Logic LOW for PC0
		       ;on PORTC to make LED ON in active
		       ;high configuration

	RJMP AGAIN

	RET	
