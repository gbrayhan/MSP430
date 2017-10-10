//******************************************************************************
//  MSP430F66x Demo - Flash In-System Programming w/ Long-Word write at 0x1800
//
//  Description: This program first erases flash seg D, then it writes a 32-bit
//  value to memory location 0x1800 using long-word write mode. Long-word write
//  provides faster write than byte/word mode.
//  ACLK = REFO = 32kHz, MCLK = SMCLK = default DCO 1048576Hz
//
//                MSP430x66x
//            -----------------
//        /|\|              XIN|-
//         | |                 |
//         --|RST          XOUT|-
//           |                 |
//
//
//   Priya Thanigai
//   Texas Instruments Inc.
//   Nov 2009
//   Built with IAR Embedded Workbench Version: 4.20 & Code Composer Studio V4.0
//******************************************************************************
#include <msp430f6638.h>

void main(void)
{
  unsigned long * Flash_ptrD;               // Initialize Flash pointer Seg D
  unsigned long value;
  WDTCTL = WDTPW+WDTHOLD;                   // Stop WDT

  Flash_ptrD = (unsigned long *) 0x1800;    // Initialize Flash pointer
  value = 0x12345678;                       // Initialize Value
  FCTL3 = FWKEY;                            // Clear Lock bit
  FCTL1 = FWKEY+ERASE;                      // Set Erase bit
  *Flash_ptrD = 0;                          // Dummy write to erase Flash seg
  FCTL1 = FWKEY+BLKWRT;                     // Enable long-word write
  *Flash_ptrD = value;                      // Write to Flash
  FCTL1 = FWKEY;                            // Clear WRT bit
  FCTL3 = FWKEY+LOCK;                       // Set LOCK bit
  while(1);                                 // Loop forever, SET BREAKPOINT HERE
}
