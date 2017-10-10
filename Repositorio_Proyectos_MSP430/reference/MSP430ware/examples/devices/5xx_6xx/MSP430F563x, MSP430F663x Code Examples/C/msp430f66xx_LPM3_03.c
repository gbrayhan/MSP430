//******************************************************************************
//   MSP430x66xx Demo - Enters LPM3 with ACLK =VLO;  LFXT1, REF0 disabled, 
//                      VUSB LDO and SLDO disabled, SVS default state
//
//   Description: Configure ACLK = VLO and enter LPM3. Measure current.
//   ACLK = VLO = 12kHz, MCLK = SMCLK = default DCO
// 
//           MSP430F663x
//         ---------------
//     /|\|               |
//      | |               |
//      --|RST            |
//        |               |
//        |               |  
//        |               |
//
//   Priya Thanigai
//   Texas Instruments Inc.
//   September 2009
//   Built with IAR Embedded Workbench Version: 4.20 & Code Composer Studio V4.0
//******************************************************************************

#include <msp430f6638.h>

void main(void)
{
  WDTCTL = WDTPW + WDTHOLD;                 // Stop WDT
   
  UCSCTL4 = SELA_1;                         // Ensure VLO is ACLK source
  
  // Port Configuration
  P1OUT = 0x00;P2OUT = 0x00;P3OUT = 0x00;P4OUT = 0x00;P5OUT = 0x00;P6OUT = 0x00;
  P7OUT = 0x00;P8OUT = 0x00;P9OUT = 0x00;PJOUT = 0x00;
  P1DIR = 0xFF;P2DIR = 0xFF;P3DIR = 0xFF;P4DIR = 0xFF;P5DIR = 0xFF;P6DIR = 0xFF;
  P7DIR = 0xFF;P8DIR = 0xFF;P9DIR = 0xFF;PJDIR = 0xFF;

    // Disable VUSB LDO and SLDO
  USBKEYPID   =     0x9628;                 // set USB KEYandPID to 0x9628 
                                            // enable access to USB config reg
  USBPWRCTL &= ~(SLDOEN+VUSBEN);            // Disable the VUSB LDO and the SLDO
  USBKEYPID   =    0x9600;                  // disable access to USB config reg 

  __bis_SR_register(LPM3_bits);             // Enter LPM3
  __no_operation();                         // For debugger
}


