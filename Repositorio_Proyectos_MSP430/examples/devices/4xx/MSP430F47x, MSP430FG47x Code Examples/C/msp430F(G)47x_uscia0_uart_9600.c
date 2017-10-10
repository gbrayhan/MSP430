//******************************************************************************
//   MSP430F(G)47x Demo - USCI_A0, Ultra-Low Pwr UART 9600 Echo ISR, 32kHz ACLK
//
//   Description: Echo a received character, RX ISR used. Normal mode is LPM3,
//   USCI_A0 RX interrupt triggers TX Echo.
//   ACLK = BRCLK = LFXT1 = 32768, MCLK = SMCLK = DCO~1048k
//   Baud rate divider with 32768hz XTAL @9600 = 32768Hz/9600 = 3.41 (0003h 03h)
//   //* An external watch crystal is required on XIN XOUT for ACLK *//	
//
//
//                 MSP430F(G)47x
//             -----------------
//         /|\|              XIN|-
//          | |                 | 32kHz
//          --|RST          XOUT|-
//            |                 |
//            |     P2.5/UCA0RXD|------------>
//            |                 | 9600 - 8N1
//            |     P2.4/UCA0TXD|<------------
//
//  P. Thanigai
//  Texas Instruments Inc.
//  September 2008
//  Built with IAR Embedded Workbench V4.11A and CCE V3.2
//******************************************************************************
#include  <msp430xG47x.h>

void main(void)
{
  volatile unsigned int i;

  WDTCTL = WDTPW+WDTHOLD;                   // Stop WDT
  FLL_CTL0 |= XCAP14PF;                     // Configure load caps

  do
  {
    IFG1 &= ~OFIFG;                         // Clear OSCFault flag
    for (i = 0x47FF; i > 0; i--);           // Time for flag to set
  }
  while ((IFG1 & OFIFG));                   // OSCFault flag still set?

  P2SEL |= BIT4+BIT5;                       // P2.4,5 = USCI_A0 RXD/TXD
  UCA0CTL1 |= UCSSEL_1;                     // CLK = ACLK
  UCA0BR0 = 0x03;                           // 32k/9600 - 3.41
  UCA0BR1 = 0x00;                           //
  UCA0MCTL = 0x06;                          // Modulation
  UCA0CTL1 &= ~UCSWRST;                     // **Initialize USCI state machine**
  IE2 |= UCA0RXIE;                          // Enable USCI_A0 RX interrupt

  _BIS_SR(LPM0_bits + GIE);                 // Enter LPM0, interrupts enabled
}

//  Echo back RXed character, confirm TX buffer is ready first
#pragma vector=USCIAB0RX_VECTOR
__interrupt void USCIA0RX_ISR (void)
{
  while(!(IFG2&UCA0TXIFG));
  UCA0TXBUF = UCA0RXBUF;                    // TX -> RXed character
}
