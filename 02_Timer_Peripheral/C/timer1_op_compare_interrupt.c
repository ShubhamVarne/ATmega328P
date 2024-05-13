/*Author : Shubham Varne
 *Goal   : Ouput compare register A of timer1 will be having preloaded value
 *	   when this value matches with counter register TCNT1 value an Output
 *	   compare match interrupt will generate. We will verify this implementation
 *
 * */

#include "avr/io.h"
#include "avr/interrupt.h"

int main(void)
{
	DDRB |= 0x20;		//setting pin PB5 (0100 0000) as output

	OCR1AH = 0xF0;		//In Timer1's Output compare register of A channel we
	OCR1AL = 0xF0;		//have kept value as oxFFF0
				//AS Timer1 is 8 bit timer is TCNT1 register can count
				//till maximumm 65536 i.e 0xFFFF
				//Once value present in TCNT1 register matches with
				//OCR1A register then an Output compare match
				//interrupt will get triggered


	TCCR1A = 0x00;		//We had kept timer1 in capture compare mode so 
				//it can generate interrupt when TCNT1's count
				//will reach to value present in OCR register
				//
				//This is achieved by giving value 0100 to WGM13, WGM12,
				//WGM11 and WGM10 bits respectively
				//
				//out of them WGM11 and WGM10 are present in TCCR1A, while
				//WGM13 and WGM12 is present in TCCR1B register

	TCCR1B = 0x0D;		//0000 1101 here we had kept Clock select bits CS12, CS11, CS10
				//we had used prescalar with value clk/1024 maximum possible
				//prescalar so that we can observe the output

	TIMSK1 |= (1 << OCIE1A); //Enabling interrupt for Timer1 Compare match for channel A

	sei();			//This functione enables interrupt

	volatile long long int i = 0;

	while(1)
		i++;

	return 0;
}

ISR(TIMER1_COMPA_vect)
{
	PORTB ^= 0x20;	//We are toggling onboard LED for Channel A interrupt
}
