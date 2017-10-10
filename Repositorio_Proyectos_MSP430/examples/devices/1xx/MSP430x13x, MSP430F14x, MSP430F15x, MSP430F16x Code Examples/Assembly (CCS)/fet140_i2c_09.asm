;******************************************************************************
;  MSP-FET430P140 Demo - I2C, Slave Writes to MSP430 Master, Repeat Mode
;
;  Description: This demo connects two MSP430's via the I2C bus. The master
;  reads from the slave in repeat mode. This is the slave code. The master
;  code is called fet140_i2c_10.asm. The TX data begins at 0 and is
;  incremented each time it is sent. The master checks the data it receives
;  for validity. If it is incorrect, it stops communicating and the P1.0 LED
;  will stay on.
;  The TXRDYIFG interrupt is used to know when to TX.
;  The Slave has a delay in data transmission and so holds the SCL low until
;  the byte is transmited
;  ACLK = n/a, MCLK = SMCLK = I2CCLOCK = default DCO ~800kHz
;  ;* MSP430F169 Device Required *//
;
;                                 /|\  /|\
;                  MSP430F169     10k  10k     MSP430F169
;                    slave         |    |        master
;              -----------------|  |    |  -----------------
;             |             P3.1|<-|---+->|P3.1             |
;             |                 |  |      |             P1.0|-->LED
;             |                 |  |      |                 |
;             |             P3.3|<-+----->|P3.3             |
;             |                 |         |                 |
;
;   H. Grewal / L. Westlund
;   Texas Instruments Inc.
;   May 2005
;   Built with Code Composer Essentials Version: 1.0
;******************************************************************************
 .cdecls C,LIST,  "msp430x16x.h"
;------------------------------------------------------------------------------
            .text                  ; Progam Start
;------------------------------------------------------------------------------
RESET       mov.w   #0A00h,SP               ; Initialize stackpointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
            bis.b   #0Ah,&P3SEL             ; Select I2C pins

I2C_init    bis.b   #I2C+SYNC,&U0CTL        ; Recommended init procedure
            bic.b   #I2CEN,&U0CTL           ; Recommended init procedure
            bis.b   #I2CSSEL1,&I2CTCTL      ; SMCLK
            mov     #0048h,&I2COA           ; Own Address is 048h
            bis.b   #TXRDYIE,&I2CIE         ; Enable TXRDYIFG interrupt
            bis.b   #I2CEN,&U0CTL           ; Enable I2C

            clr     R5                      ; Use R5 to hold TX data

Mainloop    bis.b   #LPM0+GIE,SR            ; Enter LPM0, enable interrupts
            nop                             ; Required only for debugger

;------------------------------------------------------------------------------
I2C_ISR;    Common ISR for I2C Module
;------------------------------------------------------------------------------
            add     &I2CIV,PC               ; Add I2C offset vector
            reti                            ; No Interrupt
            reti                            ; Arbitration lost
            reti                            ; No Acknowledge
            reti                            ; Own Address
            reti                            ; Register Access Ready
            reti                            ; Receive Ready
            jmp     TXRDY_ISR               ; Transmit Ready
            reti                            ; General Call
            reti                            ; Start Condition

TXRDY_ISR   mov     #032h,R15               ; Delay Data, Hold SCL Low
L$1         dec     R15                     ;
            jnz     L$1                     ;
            mov.b   R5,&I2CDRB              ; Load I2CDRB
            inc.b   R5                      ; Increment data
            reti

;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET vector
            .short  RESET                   ;
            .sect   ".int08"                ; I2C interrupt vector
            .short  I2C_ISR
            .end
