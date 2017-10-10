;*******************************************************************************
;   MSP-FET430P430 Demo - FLL+, Runs Internal DCO at 8MHz
;
;   Description: This program demonstrates setting the internal
;   DCO to run at 8MHz with auto-calibration by the FLL+.
;   ACLK = LFXT1 = 32768Hz, MCLK = SMCLK = DCOCLK = (121+1)x2xACLK = 7995392Hz
;   ;* An external watch crystal between XIN & XOUT is required for ACLK *//	
;
;                MSP430FG439
;             -----------------
;         /|\|              XIN|-
;          | |                 | 32kHz
;          --|RST          XOUT|-
;            |                 |
;            |        P1.1/MCLK|--> MCLK = 8MHz
;            |                 |
;            |        P1.5/ACLK|--> ACLK = 32kHz
;            |                 |
;
;   M. Buccini / M. Mitchell
;   Texas Instruments Inc.
;   May 2005
;   Built with Code Composer Essentials Version: 1.0
;******************************************************************************
 .cdecls C,LIST,  "msp430xG43x.h"
;-------------------------------------------------------------------------------
            .text                  ; Program Start
;-------------------------------------------------------------------------------
RESET       mov.w   #0A00h,SP               ; Initialize stack pointer
SetupWDT    mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupFLL2   bis.b   #FN_4,&SCFI0            ; x2 DCO, 8MHz nominal DCO
            bis.b   #DCOPLUS+XCAP14PF,&FLL_CTL0 ; DCO+, configure load caps
            mov.b   #121,&SCFQCTL           ; (121+1) x 2 x 32768 = 7.99 MHz
SetupPorts  bis.b   #022h,&P1DIR            ; P1.1 & P1.5 to output direction
            bis.b   #022h,&P1SEL            ; P1.1 & P1.5 to output MCLK & ACLK
                                            ;
Mainloop    jmp     Mainloop                ; Loop with CPU running
                                            ;
;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; RESET Vector
            .short  RESET                   ;
            .end







