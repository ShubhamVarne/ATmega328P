# ATmega328P
This repository contains program in C and Assembly language for ATmega328p Arduino UNO. The reference book used for this codes is "The AVR Microcontroller and Embedded Systems Using Assembly and C" by Mazidi. Instead of using AVRStudio/Microchip Studio or Arduino IDE we use avr-gcc crosscompilation toolchain on Linux Ubuntu 22.04 host machine.


We need to setup crosscompiler tool chain for AVR microcontroller which can compile, assemble, debug and link our code.

To insall the tool chain on host machine
$ sudo apt install gcc-avr
This gives us access to compile, assemble, debug and link our code

Now we need insatll libararies, through this command we can install them.
$ sudo apt install avr-libc 

To compile and generate .out file we have to use instruction 
**avr-gcc -mmcu=atmega328p <source_file.c> -o <target_file.out>**

Now the generated .out file is not in an understandable for our AVR Controller
The .out file is generated in Operating system favourable environment like it may have
different memory segments which processes of OS have, like .text, .data, heap and stack

We only need .data section and .text section of this file for our code
so we will use avr-objcopy utility that comes with gcc-avr toolchain
**avr-objcopy -O ihex -j .text -j .data <.out file_name> <.hex file_name>**

1. -O(Output format) <ihex> (used for intel hex format)
2. -j(specifiy which sections of code should get copied) <-j .text -j .data>
3. input file_name <a.out>
4. specify name of output hex file you want <ihex> 


Command to upload code on arduino

**avrdude -C /etc/avrdude.conf -v -p atmega328p -c arduino -P /dev/ttyACM0 -b 115200 -U flash:w:<.hex_file>:i**

1. <path_of_avrdude.exe_file> 
2. -C(To specify which avrdude.conf file we use) <path_of_avrdude.conf_file> 
3. -v(To enable verbose output)
4. -p(Partname of<controller) <atmega328p> 
5. -c(Programmer ID) <arduino> 
6. -P(Port Name) </deb/ttyACM*>
7. -b(baud rate) <115200> 
8. -U(Memory operation command with systax) 
	<Memory_Region> : <r/w/v_operation> : <output_file_name_with_path> : <i->intel Hex, e->elf, m->exact values>
	
Memory_region can be : flash, eeprom, lfuse, hfuse, efuse
for detailed reference we can use manual of avr-gcc and it other utilities


References:- 

for avr-libc :- https://www.nongnu.org/avr-libc/user-manual/overview.html
for avr-gcc :- https://gcc.gnu.org/wiki/avr-gcc#ABI
for avr-gcc installation guide :- https://ece-classes.usc.edu/ee459/library/documents/AVR-gcc.pdf
detailed manual PDF format :- https://www.cs.ou.edu/~fagg/classes/general/atmel/avr-libc-user-manual-1.7.1.pdf

avr-gcc :- https://gcc.gnu.org/onlinedocs/gcc/AVR-Options.html
avr-objcopy :- http://ccrma.stanford.edu/planetccrma/man/man1/avr-objcopy.1.html
avrdude :- https://avrdudes.github.io/avrdude/7.2/avrdude.pdf
