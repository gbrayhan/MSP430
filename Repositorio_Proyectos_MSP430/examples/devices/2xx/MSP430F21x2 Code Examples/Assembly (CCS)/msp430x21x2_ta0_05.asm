;******************************************************************************
;  MSP430F21x2 Demo - Timer0_A3, Toggle P1.0, TA0CCR0 Up Mode ISR, 32kHz ACLK
;
;  Description: Toggle P1.0 using software and the Timer0_A0 ISR. Timer_A is
;  configured for up mode, thus the the timer overflows when TA0R counts
;  to TA0CCR0. In this example TA0CCR0 is loaded with 1000-1.
;  ACLK = TA0CLK = LFXT1 = 32768Hz, MCLK = SMCLK = default DCO ~1.2MHz
;  /* An external watch crystal on XIN XOUT is required for ACLK */
;
;               MSP430F21x2
;            -----------------
;        /|\|              XIN|-
;         | |                 | 32kHz
;         --|RST          XOUT|-
;           |                 |
;           |             P1.0|-->LED
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
RESET       mov.w   #025Fh,SP         		; Initialize stackpointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupP1     bis.b   #001h,&P1DIR            ; P1.0 output
SetupC0     mov.w   #CCIE,&TA0CCTL0          ; TACCR0 interrupt enabled
            mov.w   #1000-1,&TA0CCR0         ; TACCR0 counts to 1000
SetupTA     mov.w   #TASSEL_1+MC_1,&TA0CTL   ; ACLK, upmode
                                            ;
Mainloop    bis.w   #LPM3+GIE,SR            ; Enter LPM3, interrupts enabled
            nop                             ; Required for debugger
                                            ;
;-------------------------------------------------------------------------------
TA0_ISR;    Toggle P1.0
;-------------------------------------------------------------------------------
            xor.b   #001h,&P1OUT            ; Toggle P1.0
            reti                            ;
                                            ;
;-------------------------------------------------------------------------------
;			 Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect	".reset"				; MSP430 RESET Vector
            .short	RESET                   ;
            .sect	".int09"		        ; Timer_A0 Vector
            .short	TA0_ISR                 ;
            .end
