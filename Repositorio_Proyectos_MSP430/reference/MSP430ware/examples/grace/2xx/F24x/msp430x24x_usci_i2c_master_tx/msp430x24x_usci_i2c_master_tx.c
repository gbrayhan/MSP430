//******************************************************************************
//  MSP430x24x Demo - USCI_B0 I2C Master TX single bytes to MSP430 Slave
//
//  Description: This demo connects two MSP430's via the I2C bus. The master
//  transmits to the slave. This is the master code. It continuously
//  transmits 00h, 01h, ..., 0ffh and demonstrates how to implement an I2C
//  master transmitter sending a single byte using the USCI_B0 TX interrupt.
//  ACLK = n/a, MCLK = SMCLK = BRCLK = default DCO = ~1.045Mhz
//
//                                /|\  /|\
//               MSP430F249      10k  10k     MSP430F249
//                   slave         |    |        master
//             -----------------   |    |  -----------------
//           -|XIN  P3.1/UCB0SDA|<-|---+->|P3.1/UCB0SDA  XIN|-
//            |                 |  |      |                 |
//           -|XOUT             |  |      |             XOUT|-
//            |     P3.2/UCB0SCL|<-+----->|P3.2/UCB0SCL     |
//            |                 |         |                 |
//******************************************************************************
/*
 * ======== Standard MSP430 includes ========
 */
#include <msp430.h>

/*
 * ======== Grace related includes ========
 */
#include <ti/mcu/msp430/csl/CSL.h>

/*
 *  ======== main ========
 */

unsigned char TXData;
unsigned char TXByteCtr;

void main(int argc, char *argv[])
{
    CSL_init();

    TXData = 0x01;                            // Holds TX data

    while (1)
    {
      TXByteCtr = 1;                          // Load TX byte counter
      while (UCB0CTL1 & UCTXSTP);             // Ensure stop condition got sent
      UCB0CTL1 |= UCTR + UCTXSTT;             // I2C TX, start condition
      __bis_SR_register(CPUOFF + GIE);        // Enter LPM0 w/ interrupts
                                              // Remain in LPM0 until all data
                                              // is TX'd
      TXData++;                               // Increment data byte
    }
}

//------------------------------------------------------------------------------
// The USCIAB0TX_ISR is structured such that it can be used to transmit any
// number of bytes by pre-loading TXByteCtr with the byte count.
//------------------------------------------------------------------------------
unsigned short USCIAB0TX_ISR(void)
{
    if (TXByteCtr)                            // Check TX byte counter
    {
      UCB0TXBUF = TXData;                     // Load TX buffer
      TXByteCtr--;                            // Decrement TX byte counter
      return 0;                               // Remain in LMP0
    }
    else
    {
      UCB0CTL1 |= UCTXSTP;                    // I2C stop condition
      IFG2 &= ~UCB0TXIFG;                     // Clear USCI_B0 TX int flag
      return CPUOFF;                          // Exit LPM0
    }
}
