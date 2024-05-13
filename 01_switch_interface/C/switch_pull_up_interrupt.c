/*
 * Objective : We will connect switch in pulld down configuration and using
 * 	       INT0 interrupt we will identify switch is in ON state ot OFF state
 *	       If switch is in ON state LED will remain OFF and vise versa
 */

#include <avr/interrupt.h>
#include <avr/io.h>

int main(void)
{
	DDRB = 0x20;	//0010 0000 we had kept PB5 pin for output
	DDRD = 0xF7;	//1111 0111 we had kept PD3 pin for input and all other for output

	DDRD = 0x04;	//0000 1000 we are implementing pull down mechanisum for our code
			//hence we are kepping all bits of B register to logic low
			//IF switch is pressed, PD2 will get logic High
			//IF switch is in OFF state, PD2 will get logic low
			
	EICRA = 0x00;	//0000 0000 to generate interrupt for low level of INT1 pin
	EIMSK = 0x02;	//0000 0010 to enable INT1 interrupt

	sei();

	while(1);

	return 0;
}

ISR(INT1_vect)
{
	PORTB ^= (1 << PB5);
}
