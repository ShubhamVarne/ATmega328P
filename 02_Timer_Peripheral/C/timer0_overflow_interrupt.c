/*
 * Author : Shubham Varne
 * Goal	  : To generate timer0 overflow interrupt
 */


#include "avr/io.h"
#include "avr/interrupt.h"

int main(void)
{
	DDRB |= 0x20;		//setting pin PB5 (0100 0000) as output

	TCNT0 = 0x00;		//We loaded 0 in Timer/Counter register0
				//so that it can start counting from 0

	TCCR0A = 0x00;		//We will be using timer in regular mode
				//i.e. no waveform generation and no PWM

	TCCR0B = 0x05;		//0000 0101 here we had kept Clock select bits CS02, CS01, CS00
				//we had used prescalar with value clk/1024 maximum possible
				//prescalar so that we can observe the output

	TIMSK0 = (1 << TOIE0); //Enabling interrupt for Timer0 Compare match for channel A

	sei();			//This functione enables interrupt

	volatile long long int i = 0;

	while(1)
		i++;

	return 0;
}

ISR(TIMER0_OVF_vect)
{
	PORTB ^= 0x20;
}
