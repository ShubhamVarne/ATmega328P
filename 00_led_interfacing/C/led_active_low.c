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

#define PORTC *((volatile unsigned char*) 0x28)
#define DDRC *((volatile unsigned char*) 0x27)


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
	 * 		0 will be read if Logic LOW is present on bit
	 **/
	
	/*As we are writing the code to connect LED in active low config
	 * we can't use onboard LED avilable on Arduino as its anode is connected
	 * to pin PB5
	 * We will use another LED, we will connects its Cathode terminal to pin
	 * PC0 and connect the anode terminal to 5V pin on arduino board*/


	DDRC = 0x01; //we had written 0000 0001 in order to set PC0 as output pin
		     
	PORTC = 0x00; //we are writting 0000 0000 so that LED cathode terminal 
		      //will get Logic Low and anode terminal will be connected to
		      //onboard 5V pin which will make LED in forward bais and it
		      //will be in ON state

	// we are simply running the while loop so program will never end and 
	// LED will be ON for all the time
	while(1){
			
	}

	/*The advantage of connecting in active low configuration over active high
	 * configuration is
	 *
	 * 	1) In active High config we are sinking current from micro-controller
	 * 	   itself, as our anode is connected to pin of micro-controller. It 
	 * 	   will increase current flowing inside IC and it will lead to more
	 * 	   power dissipiation and hence less life. (This is current Sinking 
	 * 	   Mechanisum)
	 *
	 * 	   on other hand when we use active low configuration, our anode terminal
	 * 	   is connected to onboard 5V pin which will source current from onboard
	 * 	   power supply circuitery which will avoid flow power dissipiation done
	 * 	   inside IC. (This is current sourcing mechanisum)
	 *
	 *
	 * 	2) for active high coinfiguration we need more minority charge carriers
	 * 	   i.e holes. To increase number of holes we need to increase area of 
	 * 	   P-type material which is responsible for production of minority charge 
	 * 	   carriers. But impurities which added to make P-type semiconductor are
	 * 	   costly over N-type impurities. Hence with active high config we are
	 * 	   having disadvantage of size and cost.  
	 *
	 * 	   on other hand active low configuration needs majority charge carriers
	 * 	   i.e electrons which gets generated due to N-type material which have 
	 * 	   good density and less manufacturing cost so active low configuration
	 * 	   is preffered. */

	return (0);
}
