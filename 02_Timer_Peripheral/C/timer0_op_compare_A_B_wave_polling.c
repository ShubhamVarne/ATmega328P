#define DDRB (*(volatile unsigned char*)0x24)
#define PORTB (*(volatile unsigned char*)0x25)
#define DDRD (*(volatile unsigned char*) 0x2A)
#define PORTD (*(volatile unsigned char*)0x2B)

#define TCNT0 (*(volatile unsigned char*)0x46)
#define TIFR0 (*(volatile unsigned char*)0x35)
#define TCCR0A (*(volatile unsigned char*)0x44)
#define TCCR0B (*(volatile unsigned char*)0x45)
#define OCR0A (*(volatile unsigned char*)0x47)
#define OCR0B (*(volatile unsigned char*)0x48)

#define OCF0B 2
#define OCF0A 1
#define TOV0 0

void toDelay_A(void);
void toDelay_B(void);

int main(void)
{
	DDRB = 0x20;	//setting PB5 for output
	DDRD = 0xE0;	//1110 0000 to set PD7, PD6 and PD5 for output

	TCNT0 = 0x00;   //loading Timer0 counter with value 0

        TCCR0A = 0x52;  //0101 0010 Timer used in capture compare mode
                        //and waveform generation is ON for OC0A and OC0B
        TCCR0B = 0x05;  //using prescalar clk/1024


	while(1) {
		toDelay_A();
		toDelay_B();
	}

	return 0;
}

void toDelay_A(void)
{
	OCR0A = 240;

	/*Continously checking if timer0 op compare A flag is raised or not*/
	while((TIFR0 & (0x01 <<  OCF0A)) == 0);
	PORTD ^= 0x80;
	TIFR0 = 0x01 << OCF0A;
}

void toDelay_B(void)
{
	OCR0B = 239;

	/*Continously checking if timer0 op compare B flag is raised*/
	while((TIFR0 & (0x01 << OCF0B)) == 0);
	PORTB ^= 0x20;
	TIFR0 = 0x01 << OCF0B;
}
