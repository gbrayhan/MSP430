//******************************************************************************
//  MSP430F23x0 Demo - Software Port Interrupt Service on P1.3 from LPM4
//
//  Description: A hi/low transition on P1.3 will trigger P1_ISR which,
//  toggles P1.0. Normal mode is LPM4 ~ 0.1uA. LPM4 current can be measured
//  with the LED removed, all unused Px.x configured as output or inputs
//  pulled high or low, and ensure the P1.3 interrupt input does not float.
//  ACLK = n/a, MCLK = SMCLK = default DCO
//
//               MSP430F23x0
//            -----------------
//        /|\|              XIN|-
//         | |                 |
//         --|RST          XOUT|-
//     /|\   |                 |
//      --o--|P1.3         P1.0|-->LED
//     \|/
//
//  A. Dannenberg
//  Texas Instruments Inc.
//  January 2007
//  Built with CCE Version: 3.2.0 and IAR Embedded Workbench Version: 3.41A
//******************************************************************************
#include "msp430x23x0.h"

void main(void)
{
  WDTCTL = WDTPW + WDTHOLD;                 // Stop watchdog timer
  P1DIR |= 0x01;                            // Set P1.0 to output direction
  P1IE |= 0x08;                             // P1.3 interrupt enabled
  P1IES |= 0x08;                            // P1.3 Hi/lo edge
  P1IFG &= ~0x08;                           // P1.3 IFG cleared

  __bis_SR_register(LPM4_bits + GIE);       // Enter LPM4 w/interrupt
}

// Port 1 interrupt service routine
#pragma vector=PORT1_VECTOR
__interrupt void Port_1(void)
{
  P1OUT ^= 0x01;                            // P1.0 = toggle
  P1IFG &= ~0x08;                           // P1.3 IFG cleared
}

