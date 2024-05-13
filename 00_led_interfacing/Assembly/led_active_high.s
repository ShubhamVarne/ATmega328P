;Author : Shubham Varne
;Goal   : To glow LED connected in active high configuration

;We will define registers needed for this code
.EQU	PORTB,	0x05
.EQU	DDRB,	0x04

.global	main
	.type	main, @function

.ORG 0

main:
	LDI R16, 0x20
	OUT DDRB, R16  ;making PB5 pin of DDRB as output
AGAIN:
	OUT PORTB, R16 ;sending Logic HIGH for PB5
		       ;on PORTB to make LED ON in active
		       ;high configuration

	RJMP AGAIN

	RET	
