;*******************************************************************************
;   MSP430x11x1 Demo - Timer_A, Toggle P1.0, CCR1 Cont. Mode ISR, DCO SMCLK
;
;   Description: Toggle P1.0 using software and TA_1 ISR. Toggles every
;   50000 SMCLK cycles. SMCLK provides clock source for TACLK.
;   During the TA_1 ISR, P1.0 is toggled and 50000 clock cycles are added to
;   CCR0. TA_1 ISR is triggered every 50000 cycles. CPU is normally off and
;   used only during TA_ISR. Proper use of the TAIV interrupt vector
;   generator is demonstrated.
;   ACLK = n/a, MCLK = SMCLK = TACLK = default DCO ~800kHz
;
;                MSP430F1121
;             -----------------
;         /|\|              XIN|-
;          | |                 |
;          --|RST          XOUT|-
;            |                 |
;            |             P1.0|-->LED
;
;   M. Buccini / Z. Albus
;   Texas Instruments Inc.
;   May 2005
;   Built with Code Composer Essentials Version: 1.0
;*******************************************************************************
 .cdecls C,LIST,  "msp430x11x1.h"
;-------------------------------------------------------------------------------
            .text                           ; Program Start
;-------------------------------------------------------------------------------
RESET       mov.w   #300h,SP                ; Initialize stackpointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupP1     bis.b   #001h,&P1DIR            ; P1.0 output
SetupC1     mov.w   #CCIE,&CCTL1            ; CCR1 interrupt enabled
            mov.w   #50000,&CCR1            ;
SetupTA     mov.w   #TASSEL_2+MC_2,&TACTL   ; SMCLK, contmode
                                            ;						
Mainloop    bis.w   #CPUOFF+GIE,SR          ; CPU off, interrupts enabled
            nop                             ; Required only for debugger
                                            ;
;-------------------------------------------------------------------------------
TAX_ISR;    Common ISR for CCR1-4 and overflow
;-------------------------------------------------------------------------------
            add.w   &TAIV,PC                ; Add Timer_A offset vector
            reti                            ; CCR0 - no source
            jmp     CCR1_ISR                ; CCR1
            reti                            ; CCR2
            reti                            ; CCR3
            reti                            ; CCR4
TA_over     reti                            ; Return from overflow ISR		
                                            ;
CCR1_ISR    add.w   #50000,&CCR1            ; Offset until next interrupt
            xor.b   #001h,&P1OUT            ; Toggle P1.0
            reti                            ; Return from overflow ISR		
                                            ;
;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET                   ;
            .sect   ".int08"                ; Timer_AX Vector
            .short  TAX_ISR                 ;
            .end
