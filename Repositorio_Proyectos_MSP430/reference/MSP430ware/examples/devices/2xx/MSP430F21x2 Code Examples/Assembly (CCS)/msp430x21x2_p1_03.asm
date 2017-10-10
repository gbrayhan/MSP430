;*******************************************************************************
;   MSP430F21x2 Demo - Poll P1 With Software with Internal Pull-up
;
;   Description: Poll P1.3 in a loop, if hi P1.0 is set, if low, P1.0 reset.
;   Internal pullup enabled on P1.3.
;   ACLK = n/a, MCLK = SMCLK = default DCO
;
;                MSP430F21x2
;             -----------------
;         /|\|              XIN|-
;          | |                 |
;          --|RST          XOUT|-
;      /|\   |      R          |
;       --o--| P1.3-o      P1.0|-->LED
;      \|/
;
;  JL Bile
;  Texas Instruments Inc.
;  May 2008
;  Built with Code Composer Essentials: v3 FET
;*******************************************************************************
 .cdecls C,LIST, "msp430x21x2.h"
;-------------------------------------------------------------------------------
 			.text							; Program Start
;-------------------------------------------------------------------------------
RESET       mov.w   #025Fh,SP      		    ; Initialize stackpointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupP1     mov.b   #001h,&P1DIR            ; P1.0 output, else input
            mov.b   #008h,&P1OUT            ; P1.3 pullup
            bis.b   #008h,&P1REN            ; P1.3 pullup

Mainloop    bit.b   #008h,&P1IN             ; P1.3 hi/low?
            jc      ON                      ; jmp--> P1.3 is set
                                            ;
OFF         bic.b   #001h,&P1OUT            ; P1.0 = 0 / LED OFF
            jmp     Mainloop                ;
ON          bis.b   #001h,&P1OUT            ; P1.0 = 1 / LED ON
            jmp     Mainloop                ;
                                            ;
;-------------------------------------------------------------------------------
;			Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect	".reset"            ; POR, ext. Reset
            .short	RESET
            .end
