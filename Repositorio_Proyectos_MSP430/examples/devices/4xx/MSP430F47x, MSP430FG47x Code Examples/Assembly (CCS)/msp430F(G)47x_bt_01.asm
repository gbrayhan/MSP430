;******************************************************************************
;  MSP430F(G)47x Demo - Basic Timer, Toggle P4.6 Inside ISR, DCO SMCLK
;
;  Description: Toggles P4.6 by xor'ing P4.6 inside of a basic timer ISR.
;  SMCLK provides the basic timer clock source. When using default FLL+
;  register settings and an external 32kHz watch crystal, LED toggles
;  every ~244us.
;  ACLK = LFXT1 = 32768Hz, MCLK = SMCLK = default DCO = 32 x ACLK = 1048576Hz
;  //* An external watch crystal between XIN & XOUT is required for ACLK *//
;
;                MSP430F(G)47x
;             -----------------
;         /|\|              XIN|-
;          | |                 | 32kHz
;          --|RST          XOUT|-
;            |                 |
;            |             P4.6|-->LED
;
;   P.Thanigai
;   Texas Instruments Inc.
;   September 2008
;   Built with Code Composer Essentials Version: 3.0
;******************************************************************************
 .cdecls C,LIST, "msp430xG47x.h" 

;------------------------------------------------------------------------------
            .text                           ; Program Start
;------------------------------------------------------------------------------
RESET       mov.w   #0A00h,SP               ; Initialize stack pointer
Init_Sys    mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupBT     mov.b   #BTSSEL+BT_fCLK2_DIV256,&BTCTL   ; SMCLK/256
            bis.b   #BTIE,&IE2              ; Enable Basic Timer interrupt
SetupP4     bis.b   #040h,&P4DIR            ; P4.6 output
                                            ;						
Mainloop    bis.w   #CPUOFF+GIE,SR          ; Enter LPM0, enable interrupts
            nop                             ; Required only for debugger
                                            ;
;------------------------------------------------------------------------------
BT_ISR;     Toggle P4.6
;------------------------------------------------------------------------------
            xor.b   #040h,&P4OUT            ; Toggle P4.6
            reti                            ;		
                                            ;
;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect	".reset"            ; RESET Vector
            .short  RESET               ;
            .sect   ".int00"	        ; MSP430 Basic Timer Interrupt Vector
            .short  BT_ISR         
            .end
