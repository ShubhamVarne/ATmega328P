/*Author : Shubham Varne
 *Goal   : Ouput Compare Register A and B of timer1 will be loaded with value
 *	   when TCNT1 value will match OCRA and OCRB value then OC1A and OC1B 
 *	   flag will be raised. we will be cheking this flag in polling mode
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
#define OCR1BH (*(volatile unsigned char*)0x8B)
#define OCR1BL (*(volatile unsigned char*)0x8A)


#define OCF1B 2
#define OCF1A 1
#define TOV1 0

void toDelay_A(void);
void toDelay_B(void);
int main(void)
{
	DDRB = 0x2E;    //0010 1110 PB5, PB3, PB2, PB1 for output

	TCNT1H = 0x00;  //loading 0 in TCNT1
        TCNT1L = 0x00;

        TCCR1A = 0x50;  //0101 0000 Toggle OC1A and OC1B and use timer in CTC mode
        TCCR1B = 0x0D;  //0000 1101 clk/1024 prescalar is selected 

	while(1) {
		
		toDelay_A();
		toDelay_B();
	}

	return 0;
}

void toDelay_A(void)
{
	OCR1AH = 0xFF;	//Loading 0xFF00 in OP compare register A	
	OCR1AL = 0xF0;

	/*Will be checking Output Compare A flag of Timer 0*/
	while((TIFR1 & (0x01 <<  OCF1A)) == 0);

	PORTB ^= 0x20;
	TIFR1 = 0x01 << OCF1A;
}

void toDelay_B(void)
{
        OCR1BH = 0xF0;  //Loading 0xFF00 in OP compare register A
        OCR1BL = 0xFF;

        /*Will be checking Output Compare A flag of Timer 0*/
        while((TIFR1 & (0x01 <<  OCF1B)) == 0);

	PORTB ^= 0x08;
        TIFR1 = 0x01 << OCF1B;
}

