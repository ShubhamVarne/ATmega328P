#define DDRB (*(volatile unsigned char*)0x24)
#define PORTB (*(volatile unsigned char*)0x25)

#define TCNT0 (*(volatile unsigned char*)0x46)
#define TIFR0 (*(volatile unsigned char*)0x35)
#define TCCR0A (*(volatile unsigned char*)0x44)
#define TCCR0B (*(volatile unsigned char*)0x45)
#define OCR0A (*(volatile unsigned char*)0x47)
#define OCR0B (*(volatile unsigned char*)0x48)

#define OCF0A 1
#define TOV0 0

void toDelay(void);

int main(void)
{
	DDRB = 0x20;	//setting PB5 for output

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
	TCNT0 = 0x00;	//loading Timer0 counter with value 0

	TCCR0A = 0x00;	//Normal Timer operation no waveform generation no PWM
	TCCR0B = 0x05;	//using prescalar clk/1024

	/*Continously checking if timer0 overflow flag is raised or not*/
	while((TIFR0 & (0x01 <<  TOV0)) == 0);

	TIFR0 = 0x01 << TOV0;
}
