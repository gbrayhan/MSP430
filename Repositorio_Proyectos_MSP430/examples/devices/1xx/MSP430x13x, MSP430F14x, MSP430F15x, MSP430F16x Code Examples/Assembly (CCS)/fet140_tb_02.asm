;******************************************************************************
;   MSP-FET430P140 Demo - Timer_B, Toggle P1.0, CCR0 Up Mode ISR, DCO SMCLK
;
;   Description: This program toggles P1.0 using software and
;   the TB_0 ISR. Timer_B is configured for up mode, thus the timer
;   overflows when TAB counts to TBCCR0. In this example, TBCCR0 is
;   loaded with 20000.
;   ACLK = n/a, MCLK = SMCLK = TBCLK = default DCO ~800kHz
;
;                MSP430F149
;             -----------------
;         /|\|              XIN|-
;          | |                 |
;          --|RST          XOUT|-
;            |                 |
;            |             P1.0|-->LED
;
;   M. Buccini / G. Morton
;   Texas Instruments Inc.
;   May 2005
;   Built with Code Composer Essentials Version: 1.0
;******************************************************************************
 .cdecls C,LIST,  "msp430x14x.h"
;------------------------------------------------------------------------------
            .text                           ; Progam Start
;------------------------------------------------------------------------------
RESET       mov.w   #0A00h,SP               ; Initialize stackpointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupP1     bis.b   #001h,&P1DIR            ; P1.0 output
SetupC0     mov.w   #CCIE,&TBCCTL0          ; TBCCR0 interrupt enabled
            mov.w   #20000,&TBCCR0          ;
SetupTB     mov.w   #TBSSEL_2+MC_1,&TBCTL   ; SMCLK, upmode
                                            ;						
Mainloop    bis.w   #CPUOFF+GIE,SR          ; CPU off, interrupts enabled
            nop                             ; Required only for debugger
                                            ;
;------------------------------------------------------------------------------
TB0_ISR;    Toggle P1.0
;------------------------------------------------------------------------------
            xor.b   #001h,&P1OUT            ; Toggle P1.0
            reti                            ;		
                                            ;
;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET                   ;
            .sect   ".int13"                ; Timer_B0 Vector
            .short  TB0_ISR                 ;
            .end
