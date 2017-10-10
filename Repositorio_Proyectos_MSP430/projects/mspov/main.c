/**
 * MSP430 Persistence of Visition Display
 *
 * This is a simple POV display for the MSP430, capable of outputting text (for
 * now at least) in any direction. It can be extended with a tilt sensor to
 * change the direction.
 *
 * @author Christopher Vagnetoft <noccylabs.info>
 * @license GNU General Public License (GPL) v2 or later
' */

#include <msp430.h>
#include <legacymsp430.h>
#include "ta0compat.h"
#include "font.h"
#include "database.h"
#include <lib430.h>
#include <wdt.h>
#include "config.h"


// The message to display
const char message[] = "HELLO WORLD!\0";

void init_leds(void) {

	LED_DIR = 0xFF;
	LED_OUT = 0x00;

}

int main(void) {

	wdt_hold();

	//Setup LEDs
	init_leds();

	//Set ACLK to use internal VLO (12 kHz clock)
	BCSCTL3 |= LFXT1S_2;

	//Set TimerA to use auxiliary clock in UP mode
	TACTL = TASSEL_1 | MC_1;
	//Enable the interrupt for TACCR0 match
	TACCTL0 = CCIE;

	// Set TACCR0 which also starts the timer. At 12 kHz, counting to 12000
	// should output an LED change every 1 second. Try this out and see how
	// inaccurate the VLO can be
	TACCR0 = 100;

	// Timer to control, timer clock and edge, and timer
	// TIMER_setup(__TIMERA0_BASE, TASSEL_1 | MC_1, 100);

	//Enable global interrupts
	eint();

	while(1) {
		//Loop forever, interrupts take care of the rest
	}

}

// Interrupt Service Routine for Timer A0. We need to use preprocessor
// directives in order to place the interrupt at the correct address for
// the current mcu.
#ifdef TIMER0_A0_VECTOR
interrupt(TIMER0_A0_VECTOR) TIMERA0_ISR(void) {
#else
interrupt(TIMERA0_VECTOR) TIMERA0_ISR(void) {
#endif
	static unsigned char stepchar = 0;
	static unsigned char position = 0;
	static unsigned char blank = 0;
	static unsigned char step = 0;

	// Blank is used to make every 2nd display cycle blank (blacken) out the
	// LEDs.
	blank = !blank;
	if (!blank) {
		// Blank every 2nd step
		LED_OUT = 0;
		return;
	}

	// If we are not on a blank phase, we grab the message byte as stepchar.
	stepchar = message[step];
	if (stepchar == 0) {
		// If the character is 0 then we black out again, and reset to the
		// first step (step 0)
		LED_OUT = 0;
		position++;
		if (position > FONTWIDTH) step = 0;
	} else {
		// Else, we need to go over the columns of the font, so this is how
		// we do that.
	    if (position < FONTWIDTH) {
			// Set the output leds to be the value of char-offset with an
			// index to step.
			LED_OUT = System5x7[((stepchar - FONTOFFSET) * FONTWIDTH) + position];
			position++;
	    } else {
			// When we hit the end of the character, we jump to the next
			// characters' first column.
			step++;
			position=0;
	    }
	}

}


