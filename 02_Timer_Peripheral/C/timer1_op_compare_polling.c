/*Author : Shubham Varne
 *Goal   : Ouput Compare Register A of timer1 will be loaded with value
 *	   when TCNT1 value will match OCRA value then OC1A flag will be 
 *	   raised. we will be cheking this flag in polling mode
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
	DDRB = 0xFF;

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
	TCNT1H = 0x00;	//loading 0 in TCNT1
	TCNT1L = 0x00;

	TCCR1A = 0x00;	//0000 0000 CTC mode is selected for Timer1
	TCCR1B = 0x0D;	//0000 1101 clk/1024 prescalar is selected 

	OCR1AH = 0xFF;	//Loading 0xFF00 in OP compare register A	
	OCR1AL = 0x00;

	/*Will be checking Output Compare A flag of Timer 0*/
	while((TIFR1 & (0x01 <<  OCF1A)) == 0);

	
	TIFR1 = 0x01 << OCF1A;
}
