/*Author : Shubham Varne
 *Goal   : To generate interrupt when compare match is occurres for OC1A and OC1B
 *	   register. Also Generate waveforms on OC1A and OC1B pins.
 * */


#include "avr/io.h"
#include "avr/interrupt.h"

int main(void)
{
	DDRB |= 0x2E;		//setting pin PB5 (onboard Arduino LED), PB3, PB2 and PB1 (0100 1110) as output
				//We will use this onboard LED(PB5) to observe Timer1 channel B interrupt
				//We will use LED connected to Digital PIN 10(OC1B) to observe Timer1 channel B
				//We will use LED connected to Digital PIN 9(OC1A) to observe Timer1 channel A 
				//We will use LED connected to PB3 to observe Timer1 channel A interrupt
	

	OCR1AH = 0xF0;		//In Timer1's Output compare register of A channel we
	OCR1AL = 0x0F;		//have kept value as 0xF00F
				//AS Timer1 is 16 bit timer is TCNT1 register can count
				//till maximumm 65536 i.e 0xFFFF
				//Once value present in TCNT1 register matches with
				//OCR1A register then an Output compare match
				//interrupt will get triggered
	
	OCR1BH = 0x0F;		//This is Output Compare Register of B channel of timer0
	OCR1BL = 0xF0;		//Its functionality is same as like above, it will generate
				//its own interrupt once value is matched with TCNT1 register	\


	TCCR1A = 0x50;		//(0101 0000)
				//We had kept timer1 in capture compare mode 
				//it can generate interrupt when TCNT1's count
				//will reach to value present in OCR register
				//
				//This is achieved by using it in CTC (Capture Compare) mode by 
				//giving value 0100 to WGM13, WGM12, WGM11 and WGM10 bits respectively
				//
				//out of them WGM11 and WGM10 are present in TCCR1A, while
				//WGM13 and WGM12 is present in TCCR1B register
				//
				//Now we wanted to generate some waveform, so COM1A1, COM1A0, COM1B1 and COM1B0 bits
				//of this register we had kept at 0101 so it will toggle OC1B pin i.e 
				//Digital pin 10 of arduino board or PB2 pin and OC1A pin or Digital PIN 9 or PB1 pin.
				//LED connected to that pin should blinking
				//interrupt arrives




	/*As per value present in TCCR1A register behaviour of OC1B i.e. Digital PIN 10 of Arduino
	 * will change, we are not using PWM as of now so we will consider normal mode table 16-1
	 * from the datasheet
	 *
	 * for COM1B1 = 1 and COM1B0 = 1 we had implemented
	 * for COM1B1 = 0 and COM1B0 = 1 : This will be your task 1 just observe what is happening
	 * for COM1B1 = 1 and COM1B0 = 0 ; This will be your task 2 observe what is happening
	 * for COM1B1 = 0 and COM1B0 = 0 ; this will be your task 3 observe what is happening
	 *
	 */
	



	TCCR1B = 0x0D;		//0000 1101 here we had kept Clock select bits CS02, CS01, CS00
				//we had used prescalar with value clk/1024 maximum possible
				//prescalar so that we can observe the output
				//Also for WGM13 and WGM12 we had kept them on 10 so we can use
				//Timer 1 in CTC mode
				


	/*Task4: Apply all possible combinations of prescalar values and let me know the behaviour*/


	TIMSK1 |= (1 << OCIE1B); //Enabling interrupt for Timer0 Compare match for channel B
	TIMSK1 |= (1 << OCIE1A); //Enabling interrupt for Timer0 Compare match for channel A

	sei();			//This functione enables interrupt

	volatile long long int i = 0;

	while(1)
		i++;		//just so that while(1) loop will keep running

	return 0;
}

ISR(TIMER1_COMPA_vect)
{
	PORTB ^= 0x08;		//We are using LED in active High Configuration for Arduino's
				//Digital PIN 7 i.e PD7
				//We will use this to observe occurance of Timer0 channel A 
				//output compare interrupt 
				//It will toggle once interrupt is arrived
}

ISR(TIMER1_COMPB_vect)
{
	PORTB ^= 0x20;		//we are using onboard LED to check interrupt occurance for 
				//Timer0 channel B output compare interrupt
}

/*If you got all task working then you can check for OC0A pin also, as we had used OC0B pin similarly you can
 * implement for OC0A by reffering the datasheet and this code. This will be chocolate problem for you... */
