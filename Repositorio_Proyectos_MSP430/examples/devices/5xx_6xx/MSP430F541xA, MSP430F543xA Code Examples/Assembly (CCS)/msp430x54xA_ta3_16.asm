;*******************************************************************************
;  MSP430F54xA Demo - Timer_A3, PWM TA1.1-2, Up Mode, DCO SMCLK
;
;  Description: This program generates two PWM outputs on P2.2,P2.3 using
;  Timer1_A configured for up mode. The value in CCR0, 512-1, defines the PWM
;  period and the values in CCR1 and CCR2 the PWM duty cycles. Using ~1.045MHz
;  SMCLK as TACLK, the timer period is ~500us with a 75% duty cycle on P2.2
;  and 25% on P2.3.
;  ACLK = n/a, SMCLK = MCLK = TACLK = default DCO ~1.045MHz.
;
;                MSP430F5438A
;            -------------------
;        /|\|                   |
;         | |                   |
;         --|RST                |
;           |                   |
;           |         P2.2/TA1.1|--> CCR1 - 75% PWM
;           |         P2.3/TA1.2|--> CCR2 - 25% PWM
;
;   D. Dang
;   Texas Instruments Inc.
;   December 2009
;   Built with CCS Version: 4.0.2 
;******************************************************************************

    .cdecls C,LIST,"msp430x54xA.h"

;-------------------------------------------------------------------------------
            .global _main 
            .text                           ; Assemble to Flash memory
;-------------------------------------------------------------------------------
_main
RESET       mov.w   #0x5C00,SP              ; Initialize stackpointer
            mov.w   #WDTPW + WDTHOLD,&WDTCTL; Stop WDT    
            bis.b   #BIT2 + BIT3,&P2DIR     ; P2.2 and P2.3 output
            bis.b   #BIT2 + BIT3,&P2SEL     ; P2.2 and P2.3 options select
            mov.w   #512-1,&TA1CCR0         ; PWM Period
            mov.w   #OUTMOD_7,&TA1CCTL1     ; CCR1 reset/set
            mov.w   #384,&TA1CCR1           ; CCR1 PWM duty cycle
            mov.w   #OUTMOD_7,&TA1CCTL2     ; CCR2 reset/set
            mov.w   #128,&TA1CCR2           ; CCR2 PWM duty cycle
            mov.w   #TASSEL_2 + MC_1 + TACLR,&TA1CTL
                                            ; SMCLK, up mode, clear TAR
            bis.w   #LPM0,SR                ; Enter LPM0
            nop                             ; For debugger
  
;-------------------------------------------------------------------------------
                  ; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; POR, ext. Reset
            .short  RESET
            .end