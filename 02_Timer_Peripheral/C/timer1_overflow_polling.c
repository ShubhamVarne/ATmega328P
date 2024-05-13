/*
 *Author : Shubham Varne
 *Goal   : To check timer 1 overflow flag in polling method
 * */



#define DDRB (*(volatile unsigned char*)0x24)
#define PORTB (*(volatile unsigned char*)0x25)

#define TCNT1H (*(volatile unsigned char*)0x85)
#define TCNT1L (*(volatile unsigned char*)0x84)
#define TIFR1 (*(volatile unsigned char*)0x36)
#define TCCR1A (*(volatile unsigned char*)0x80)
#define TCCR1B (*(volatile unsigned char*)0x81)
#define OCR1AH (*(volatile unsigned char*)0x89)
#define OCR1AL (*(volatile unsigned char*)0x88)

#define OCF1A 2
#define TOV1 1

void toDelay(void);

int main(void)
{
	DDRB = 0x20;		//we had kept PB5 for output

	while(1) {
		
		PORTB = 0x20;
		toDelay();
		PORTB = 0x00;
		toDelay();
	}

	return 0;
}

void toDelay(void)
{
	TCNT1H = 0x00;
	TCNT1L = 0x00;

	TCCR1A = 0x00;		//we will using timer1 in regular mode no waveform generation
				//no PWM
	TCCR1B = 0x05;		//prescalar clk/1024 is used

	/*Will keep checking for Timer1 overflow flag*/
	while((TIFR1 & (0x01 <<  TOV1)) == 0);
	
	TIFR1 = 0x01 << TOV1;
}
