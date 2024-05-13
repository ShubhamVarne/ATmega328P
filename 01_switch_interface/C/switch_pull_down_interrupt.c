/*
 * Objective : We will connect switch in pulld down configuration and using
 * 	       INT0 interrupt we will identify switch is in ON state ot OFF state
 *	       If switch is in ON state LED will remain OFF and vise versa
 */

#include <avr/interrupt.h>
#include <avr/io.h>

int main(void)
{
	MCUCR = 0x10;	//0001 0000 Pull-up disable
	DDRC = 0x01;	//0000 0001 we had kept PC0 pin for output
	DDRD = 0xFB;	//1111 1011 we had kept PB4 pin for input and all other for output

	DDRD = 0x00;	//we are implementing pull down mechanisum for our code
			//hence we are kepping all bits of B register to logic low
			//IF switch is pressed, PD2 will get logic High
			//IF switch is in OFF state, PD2 will get logic low
			
	EICRA = 0x01;	//0000 0001 to generate interrupt for any logic level change
	EIMSK = 0x01;	//0000 0001 to enable INT0 interrupt

	sei();

	while(1);

	return 0;
}

ISR(INT0_vect)
{
	PORTC ^= (1 << 0);
}
