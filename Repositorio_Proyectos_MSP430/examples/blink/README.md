MSP430 Blinker
==============

This project shows how to make use of the timer interrupts on the MSP430 series
microcontrollers to blink the two LEDs that can be found on the Launchpad. For
the sake of making it compile over a wide number of devices, the ta0compat.h
file is provided in order to map the Timer0 A0 functionality from the devices
that have more than one timer to the defines present in single-timer devices.

The magic happens in the ISR at the bottom of main.c where the Uint8 global
variable "twink" will toggle between 1 and 0, and in effect light up either
LED1 or LED2.

The code in main() is responsible for setting up the timers and enable global
interrupts so that the ISR occur when they hit the target value.

Requirements
------------

To compile this project you need a MSP430-based device and programmer. It is
designed to be used with the Launchpad, but the binaries should be universal
and can be programmed onto any compatible device with any programmer.

 * mspdebug is needed to identify the device as well as program it
 * msp430-gcc is needed to compile the project

The Makefile
------------

The makefile is based on the mspdev skeleton makefile and thus prvides the
following actions:

 * all - Build all the source files, link the binary and then call on mspdebug
   to program the device. This is the default action, and thus just calling
   make will instantly deploy the project on the microcontroller, just like
   with the picdev makefile.

 * bin - Build all the source files and link the binary in elf and hex format.
   No programming is done here.

 * prog - Program the device with the binary.

 * clean - Clean the build environment and remove all temporary files.

 * listing - Generate assembly source listings from the .c files.

 * identify - Identify the attached microcontroller using mspdebug.


