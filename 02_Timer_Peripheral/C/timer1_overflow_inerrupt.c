/*
 *Author : Shubham Varne
 *Goal   : To generate Timer1 overflow interrupt
 * */



#include "avr/io.h"
#include "avr/interrupt.h"

int main(void)
{
	DDRB |= 0x20;		//setting pin PB5 (0100 0000) as output

	TCCR1A = 0x00;		//we used timer in regular mode no waveform generation
				//no PWM

	TCCR1B = 0x05;		//0000 0101 here we had kept Clock select bits CS12, CS11, CS10
				//we had used prescalar with value clk/1024 maximum possible
				//prescalar so that we can observe the output

	TCNT1H = 0x00;
	TCNT1L = 0x00;

	TIMSK1 |= (1 << TOIE1); //Enabling interrupt for Timer1 overflow

	sei();			//This functione enables interrupt

	volatile long long int i = 0;

	while(1)
		i++;

	return 0;
}

ISR(TIMER1_OVF_vect)
{
	PORTB ^= 0x20;	//We are toggling onboard LED for Channel A interrupt
}
