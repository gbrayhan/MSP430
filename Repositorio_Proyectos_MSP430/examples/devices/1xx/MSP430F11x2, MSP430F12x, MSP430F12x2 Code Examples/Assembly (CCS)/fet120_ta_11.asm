;*****************************************************************************
;   MSP-FET430P120 Demo - Timer_A, Toggle P1.1/TA0, Up Mode, 32kHz ACLK
;
;   Description: Toggle P1.1 using hardware TA0 output. Timer_A is configured
;   for up mode with CCR0 defining period, TA0 also output on P1.1. In this
;   example, CCR0 is loaded with 10-1 and TA0 will toggle P1.1 at TACLK/10.
;   Thus the output frequency on P1.1 will be the TACLK/20. No CPU or software
;   resources required. Normal operating mode is LPM3.
;   As coded with TACLK = ACLK, P1.1 output frequency = 32768/20 = 1.6384kHz
;   ACLK = TACLK = 32kHz, MCLK = default DCO ~800kHz
;   //* External watch crystal installed on XIN XOUT is required for ACLK *//	
;
;               MSP430F123(2)
;             -----------------
;         /|\|              XIN|-
;          | |                 | 32kHz
;          --|RST          XOUT|-
;            |                 |
;            |         P1.1/TA0|--> ACLK/20
;
;   M. Buccini / M. Raju
;   Texas Instruments Inc.
;   May 2005
;   Built with Code Composer Essentials Version: 1.0
;******************************************************************************
 .cdecls C,LIST,  "msp430x12x2.h"
;------------------------------------------------------------------------------
            .text                           ; Program Start
;------------------------------------------------------------------------------
RESET       mov.w   #300h,SP                ; Initialize stackpointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupP1     bis.b   #002h,&P1DIR            ; P1.1 output
            bis.b   #002h,&P1SEL            ; P1.1 option slect
SetupC0     mov.w   #OUTMOD_4,&CCTL0        ; CCR0 toggle mode
            mov.w   #10-1,&CCR0             ;
SetupTA     mov.w   #TASSEL_1+MC_1,&TACTL   ; ACLK, upmode
                                            ;						
Mainloop    bis.w   #LPM3,SR                ; Enter LPM3
            nop                             ; Required only for debugger
                                            ;
;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET                   ;
            .end
