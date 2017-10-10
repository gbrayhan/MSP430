//******************************************************************************
//  MSP-FET430P410 Demo - FLL+, Output MCLK, ACLK Using 32kHz XTAL and DCO
//
//  Description: This program outputs buffered MCLK and ACLK on port pins
//  P1.1 and P1.5.
//  ACLK = LFXT1 = 32768Hz, MCLK = SMCLK = default DCO = 32 x ACLK = 1048576Hz
//  //* An external watch crystal between XIN & XOUT is required for ACLK *//	
//
//                MSP430F413
//            -----------------
//        /|\|              XIN|-
//         | |                 | 32kHz
//         --|RST          XOUT|-
//           |                 |
//           |        P1.1/MCLK|-->MCLK = 1048576Hz
//           |        P1.5/ACLK|-->ACLK = 32kHz
//
//  M. Buccini
//  Texas Instruments Inc.
//  Feb 2005
//  Built with CCE Version: 3.2.0 and IAR Embedded Workbench Version: 3.21A
//*****************************************************************************
#include  <msp430x41x.h>

void main(void)
{
  WDTCTL = WDTPW + WDTHOLD;                 // Stop watchdog timer
  FLL_CTL0 = XCAP14PF;                      // Configure load caps

  P1DIR = 0x22;                             // P1.1,5 to output direction
  P1SEL = 0x22;                             // P1.1,5 to output MCLK & ACLK

  while(1);                                 // Loop in place
}
