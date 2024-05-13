#define DDRC *((volatile unsigned char*) 0x27)
#define DDRB *((volatile unsigned char*) 0x24)

#define PORTC *((volatile unsigned char*) 0x28)
#define PORTB *((volatile unsigned char*) 0x25)

#define PINC *((volatile unsigned char*) 0x26)


int main(void)
{
	DDRC = 0xFE;	//1111 1110 we had kept PC0 pin for input and all others for output
	DDRB = 0x20;	//0010 0000 we had kept PB5 pin for output

	PORTC = 0x01;	//as switch can be interfaced in two methods
			//pull up config and pull down config
			//If we directly connect switch's one terminal to Ground and another to IC
			//then we can get to know when switch if ON but it is difficult to determine
			//when switch is in OFF state
			//hence we through register we connect other terminal of switch to either
			//LOGIC HIGH or LOGIC LOW
			//so if swicth is in ON state current will directly flow between switch's other
			//terminal to micro-controller as register is connected so it will bypass that branch
			//when Switch is in OFF state, the circuit will complete through register branch and 
			//micro-controller pin
			//IF Logic HIGH is connected to register then we sayv it as Pull up config as
			//when switch is in open state micro-controller will get logic High to its pin
			//and when switch gets closed micro-controller will get logic zero

	while(1){

		if(PINC & 0x01)
		{
			PORTB = 0x00;
		}
		else{
			PORTB = 0x20;
		}
	}

	return 0;
}
