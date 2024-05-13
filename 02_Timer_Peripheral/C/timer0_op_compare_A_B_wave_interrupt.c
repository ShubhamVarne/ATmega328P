/*
 *Author : Shubham Varne
 *Goal 	 : We will generate Output compare interrupt for both channel A and B
 *	   Also we will generate waveform on OC0A and OC0B pins
 * */


#include "avr/io.h"
#include "avr/interrupt.h"

int main(void)
{
	DDRB |= 0x20;		//setting pin PB5 (onboard Arduino LED) (0100 0000) as output
				//We will use this onboard LED to observe Timer0 channel B interrupt
				
	DDRD |= 0xE0;		//setting pin PD7, PD6 and PD5 (1110 0000) as output (need to connect LED to PD7 i.e. 
				//Digital PIN 7 , PD6 i.e. Digital PIN 6 and PD5  i.e Digital PIN 5 on arduino board)
				//We will use LED connected to Digital PIN 7 to observe Timer0 channel A interrupt
				//We are going to generate waveform on pin OC0B and OC0A which is Digital PIN 5 and
				//digital PIN 6 on arduino board. We can observe that waveform by connecting LED to 
				//Digital PIN 5 and 6. 
	

	OCR0A = 239;		//In Timer0's Output compare register of A channel we
				//have kept value as decimal 239
				//AS Timer0 is 8 bit timer is TCNT0 register can count
				//till maximumm 255 i.e 0xFF or 1111 1111
				//Once value present in TCNT0 register matches with
				//OCR0A register then an Output compare match
				//interrupt will get triggered
	
	OCR0B = 238;		//This is Output Compare Register of B channel of timer0
				//Its functionality is same as like above, it will generate
				//its own interrupt once value is matched with TCNT0 register
				


	/*Task1: Keep OCR0B > OCR0A and observe the result let me know what is happening */
	/*Task2: keep OCR0B = OCR0A and observe the result let me know what is happening */


	TCCR0A = 0x52;		//(0101 0010)
				//We had kept timer0 in capture compare mode 
				//it can generate interrupt when TCNT0's count
				//will reach to value present in OCR register
				//
				//This is achieved by using it in CTC (Capture Compare) mode by 
				//giving value 010 to WGM02, WGM01 and WGM00 bits respectively
				//
				//out of them WGM01 and WGM00 are present in TCCR0A, while
				//WGM02 is present in TCCR0B register
				//
				//Now we wanted to generate some waveform, so COM0B1 and COM0B0 bits
				//of this register we had kept at 01 so it will toggle OC0B pin i.e 
				//Digital pin 5 of arduino board
				//LED connected to that pin should be blink as interrupt arrives
				//
				//Similarly we will set COM0A1 and COM0A0 bits of this register to 01
				//so it will generate waveform on OC0A pin when interrupt occures




	/*As per value present in TCCR0A register behaviour of OC0B i.e. Digital PIN 5 of Arduino
	 * will change, we are not using PWM as of now so we will consider normal mode table 15-5
	 * from the datasheet
	 *
	 * for COM0B1 = 1 and COM0B0 = 1 we had implemented
	 * for COM0B1 = 0 and COM0B0 = 1 : This will be your task 4 just observe what is happening
	 * for COM0B1 = 1 and COM0B0 = 0 ; This will be your task 5 observe what is happening
	 * for COM0B1 = 0 and COM0B0 = 0 ; this will be your task 6 observe what is happening
	 *
	 * out of above for task 5 you need to make LED connected to Digital PIN 5 ON first
	 * before giving value to TCCR0A register, but as we are using Timer0 which can generate
	 * small time delay only so it will be not observable time when LED is transitioning 
	 * from ON to OFF state, we will implement same in timer1 where larger delay is possible
	 * and it will be more observable*/
	



	TCCR0B = 0x05;		//1000 0101 here we had kept Clock select bits CS02, CS01, CS00
				//we had used prescalar with value clk/1024 maximum possible
				//prescalar so that we can observe the output
				


	/*Task3: Apply all possible combinations of prescalar values and let me know the behaviour*/


	TIMSK0 |= (1 << OCIE0B); //Enabling interrupt for Timer0 Compare match for channel B
	TIMSK0 |= (1 << OCIE0A); //Enabling interrupt for Timer0 Compare match for channel A

	sei();			//This functione enables interrupt

	volatile long long int i = 0;

	while(1)
		i++;		//just so that while(1) loop will keep running

	return 0;
}

ISR(TIMER0_COMPA_vect)
{
	PORTD ^= 0x80;		//We are using LED in active High Configuration for Arduino's
				//Digital PIN 7 i.e PD7
				//We will use this to observe occurance of Timer0 channel A 
				//output compare interrupt 
				//It will toggle once interrupt is arrived
}

ISR(TIMER0_COMPB_vect)
{
	PORTB ^= 0x20;		//we are using onboard LED to check interrupt occurance for 
				//Timer0 channel B output compare interrupt
}

/*If you got all task working then you can check for OC0A pin also, as we had used OC0B pin similarly you can
 * implement for OC0A by reffering the datasheet and this code. This will be chocolate problem for you... */
