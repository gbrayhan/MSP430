;******************************************************************************
;  MSP430F21x1 Demo - Timer0_A3, Toggle P1.0, TA0CCR1 Cont. Mode ISR, DCO SMCLK
;
;  Description: Toggle P1.0 using software and Timer0_A1 ISR. Toggles every
;  50000 SMCLK cycles. SMCLK provides clock source for TA0CLK.
;  During the Timer0_A1 ISR, P1.0 is toggled and 50000 clock cycles are added to
;  TA0CCR0. Timer0_A1 ISR is triggered every 50000 cycles. CPU is normally off and
;  used only during Timer0_A1 ISR. Proper use of the TA0IV interrupt vector generator
;  is demonstrated.
;  ACLK = n/a, MCLK = SMCLK = TA0CLK = default DCO ~1.2MHz
;
;               MSP430F21x2
;            -----------------
;        /|\|              XIN|-
;         | |                 |
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
SetupC1     mov.w   #CCIE,&TA0CCTL1         ; TACCR1 interrupt enabled
            mov.w   #50000,&TA0CCR1         ;
SetupTA     mov.w   #TASSEL_2+MC_2,&TA0CTL  ; SMCLK, contmode
                                            ;
Mainloop    bis.w   #CPUOFF+GIE,SR          ; CPU off, interrupts enabled
            nop                             ; Required only for debugger
                                            ;
;-------------------------------------------------------------------------------
TAX_ISR;    Common ISR for TACCR1 and overflow
;-------------------------------------------------------------------------------
            add.w   &TAIV,PC                ; Add Timer_A offset vector
            reti                            ;
            jmp     TACCR1_ISR              ; TACCR1
            reti                            ; TACCR2 not used
            reti                            ;
            reti                            ;
            reti                            ; Overflow not used
                                            ;
TACCR1_ISR  add.w   #50000,&TACCR1          ; Offset until next interrupt
            xor.b   #001h,&P1OUT            ; Toggle P1.0
            reti                            ; Return from TACCR1 ISR
                                            ;
;-------------------------------------------------------------------------------
;			Interrupt Vector
;-------------------------------------------------------------------------------
            .sect	".reset"				; MSP430 RESET Vector
            .short	RESET                   ;
            .sect	".int08"        		; Timer_AX Vector
            .short	TAX_ISR                 ;
            .end            
            