//******************************************************************************
//   MSP430F552x Demo - Write a Word to Port A (Port1+Port2)
//
//   Description: Writes a Word(1234h) to Port A and stays in LPM4
//   ACLK = 32.768kHz, MCLK = SMCLK = default DCO
//
//                MSP430F552x
//             -----------------
//         /|\|                 |
//          | |                 |
//          --|RST          PA.x|-->HI
//            |                 |
//            |                 |
//
//   Bhargavi Nisarga
//   Texas Instruments Inc.
//   April 2009
//   Built with CCSv4 and IAR Embedded Workbench Version: 4.21
//******************************************************************************

#include <msp430f5529.h>

void main(void)
{
  WDTCTL = WDTPW+WDTHOLD;                   // Stop WDT

  PADIR |= 0xFFFF;                          // PA.x output
  PAOUT = 0x1234;                           // Write to Port A

  __bis_SR_register(LPM4_bits + GIE);       // Enter LPM4 w/interrupts enabled
  __no_operation();                         // Place BREAKPOINT HERE and check register PAOUT, P1OUT and P2OUT
}
