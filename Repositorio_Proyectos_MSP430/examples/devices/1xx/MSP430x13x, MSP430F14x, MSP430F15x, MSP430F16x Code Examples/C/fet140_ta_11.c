//******************************************************************************
//  MSP-FET430P140 Demo - Timer_A, Toggle P1.1/TA0, Up Mode, 32kHz ACLK
//
//  Description: Toggle P1.1 using hardware TA0 output. Timer_A is configured
//  for up mode with CCR0 defining period, TA0 also output on P1.1. In this
//  example, CCR0 is loaded with 10-1 and TA0 will toggle P1.1 at TACLK/10.
//  Thus the output frequency on P1.1 will be the TACLK/20. No CPU or software
//  resources required. Normal operating mode is LPM3.
//  As coded with TACLK = ACLK, P1.1 output frequency = 32768/20 = 1.6384kHz.
//  ACLK = TACLK = 32kHz, MCLK = default DCO ~800kHz
//  //* External watch crystal installed on XIN XOUT is required for ACLK *//	
//
//              MSP430F149
//            -----------------
//        /|\|              XIN|-
//         | |                 | 32kHz
//         --|RST          XOUT|-
//           |                 |
//           |         P1.1/TA0|--> ACLK/20
//
//  M. Buccini
//  Texas Instruments Inc.
//  Feb 2005
//  Built with CCE Version: 3.2.0 and IAR Embedded Workbench Version: 3.21A
//******************************************************************************

#include  <msp430x14x.h>

void main(void)
{
  WDTCTL = WDTPW + WDTHOLD;                 // Stop WDT
  P1DIR |= 0x02;                            // P1.1 output
  P1SEL |= 0x02;                            // P1.1 option select
  CCTL0 = OUTMOD_4;                         // CCR0 toggle mode
  CCR0 = 10-1;
  TACTL = TASSEL_1 + MC_1;                  // ACLK, upmode

  _BIS_SR(LPM3_bits);                       // Enter LPM3 w/interrupt
}
