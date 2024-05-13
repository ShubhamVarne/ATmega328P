/*****************************************************************************************
 * ATmega328P architecture has 3 in Data memory spaces
 *	A) Register address space : 
 *		Address for General Purpose registers from 0x00 to 0x1F
 *										   
 *	B) Special Function Registers address space or Memory mapped IO address space : 
 *		Address space given for IO specific special function registers such as 
 *		I/O direction register DDRx, Timer Counter register TCNTx etc
 *	
 *	C) Data Address space :		
 *		remainign space will be utilize to store data and create stack					
*****************************************************************************************/

/*here using macro we are defining at which address SFR is present in memory
 we are doing this in order to avoid using standard input file avr/io.h which 
 has all this definations written*/

/*We alson wanted to check the necessity of volatile qualifier
 * AS we want to update data on SFR and it is possible that value of this SFR 
 * can be changing contineously hence we used volatile keyword here so that it
 * can avoid optimization done by compiler and it will read this value from 
 * memory everytime we want to perform operation on it*/

#define PORTB *((volatile unsigned char*) 0x25)
#define DDRB *((volatile unsigned char*) 0x24)


int main(void)
{

	/*AVR has 3 registers for basic IO operation
	 * DDRx  : Data direction register to specify either we should take input
	 * 	   or we should give output on I/O port or bits of I/O port
	 * 	   	for 1 -> bit is set to output
	 * 	   	for 0 -> bit is set to input
	 * PORTx : If we have to write on I/O port
	 * 		for 1 -> Logic HIGH will be written
	 * 		for 0 -> Logic LOW will be written
	 * PINx  : To read value present on I/O port 
	 * 		1 will be read if Logic HIGH is present on bit
	 * 		0 will be read if Logic LOW is present on bit*/
	
	DDRB = 0x20; //we had written 0010 0000 in order to set PB5 as output pin
		     //This has to done beacuse inbuilt LED of arduino is connected
		     //to PB pin
		     
	PORTB = 0x20; //we are writting 0010 0000 so that LED will turn ON as PB 5 
		      //will get Logic HIGH to its Anode terminal and it will be
		      //in Forward Bais which will make it in ON state
		      //We refered the Arduino Schematic 
		      //https://content.arduino.cc/assets/UNO-TH_Rev3e_sch.pdf here
		      //and ATmega328P DIP package datasheet
		      //http://ww1.microchip.com/downloads/en/DeviceDoc/ATmega48A-PA-88A-PA-168A-PA-328-P-DS-DS40002061A.pdf

	// we are simply running the while loop so program will never end and 
	// LED will be ON for all the time
	while(1){
			
	}

	return (0);
}
