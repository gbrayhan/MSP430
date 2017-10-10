;******************************************************************************
;   MSP430F(G)47x Demo - SVM, Toggle port 4.6 on Vcc < 2.8V
;
;  Description: The SVS feature is used to monitor VCC. LED turns ON when Vcc 
;  drops below reference threshold of 2.8V.SVS flags need to be reset in
;  software.
;   ACLK = n/a, MCLK = SMCLK = default DCO
;
;                 MSP430FG47x
;              -----------------
;          /|\|              XIN|-
;           | |                 |
;           --|RST          XOUT|-
;             |                 |
;             |             P4.6|-->LED
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
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupP4     bis.b   #040h,&P4DIR            ; P4.6  output
            mov.b   #VLD3,&SVSCTL           ; SVS enabled @ 2.8V, no POR
                                            
Mainloop    clr.b   &P4OUT
            bit.b   #SVSFG,&SVSCTL
            jz      Mainloop
            bic.b   #SVSFG,&SVSCTL
            bis.b   #040h,&P4OUT            ; Turn LED on
            mov.w   #050000,R15             ; Delay to R15
L1          dec.w   R15                     ; Decrement R15
            jnz     L1    
            jmp     Mainloop                ; Again
;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET                   ;  
            .end
