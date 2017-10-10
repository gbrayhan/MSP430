;******************************************************************************
;  MSP430FR57xx Demo - USCI_B0 I2C Slave RX single bytes from MSP430 Master
;
;  Description: This demo connects two MSP430's via the I2C bus. The master
;  transmits to the slave. This is the slave code. The interrupt driven
;  data receiption is demonstrated using the USCI_B0 RX interrupt.
;  ACLK = n/a, MCLK = SMCLK = default DCO = ~1.045MHz
;
;                                /|\  /|\
;                MSP430FR5739    10k  10k     MSP430FR5739
;                   slave         |    |         master
;             -----------------   |    |   -----------------
;           -|XIN  P1.6/UCB0SDA|<-|----+->|P1.6/UCB0SDA  XIN|-
;            |                 |  |       |                 |
;           -|XOUT             |  |       |             XOUT|-
;            |     P1.7/UCB0SCL|<-+------>|P1.7/UCB0SCL     |
;            |                 |          |                 |
;            |                 |          |                 |
;
;   Tyler Witt
;   Texas Instruments Inc.
;   September 2011
;   Built with Code Composer Studio V4.2
;******************************************************************************
 .cdecls C,LIST,  "msp430fr5739.h"
RXData		.set	R5
;------------------------------------------------------------------------------
			.global _main
            .text                  			; Program reset
;------------------------------------------------------------------------------
_main
RESET       mov.w   #1DFEh,SP               ; Initialize stack pointer
			mov.w	#WDTPW+WDTHOLD,&WDTCTL	; Stop WDT
			mov.b	#0xA5,&CSCTL0_H
			bis.w	#DCOFSEL0+DCOFSEL1,&CSCTL1 ; Set max DCO setting
			mov.w	#SELA_3+SELS_3+SELM_3,&CSCTL2 ; ACLK = MCLK = DCO
			mov.w	#DIVA_3+DIVS_3+DIVM_3,&CSCTL3 ; set all dividers to 1MHz
			bis.b	#BIT6+BIT7,&P1SEL1		; Configure pins
			
			bis.w	#UCSWRST,&UCB0CTLW0		; Software reset enabled
			bis.w	#UCMODE_3+UCSYNC,&UCB0CTLW0 ; I2C mode, sync mode
			mov.w	#0x48+UCOAEN,&UCB0I2COA0 ; own address is 0x48 + enable
			bic.w	#UCSWRST,&UCB0CTLW0		; Software reset cleared
			bis.w	#UCRXIE0,&UCB0IE

Mainloop	bis.w	#LPM0+GIE,SR			; Enter LPM0 w/ interrupt
			nop								; remain in LPM0
			
;------------------------------------------------------------------------------
USCI_ISR ;	USCI Interrupt Service Routine
;------------------------------------------------------------------------------
			add		&UCB0IV,PC				; Add offset to PC
			reti							; No interrupt
			reti							; ALIFG break
			reti							; NACKIFG break
			reti							; STTIFG break
			reti							; STPIFG break
			reti							; RXIFG3 break
			reti							; TXIFG3 break
			reti							; RXIFG2 break
			reti							; TXIFG2 break
			reti							; RXIFG1 break
			reti							; TXIFG1 break
			jmp		GetRX					; RXIFG0 break
			reti							; TXIFG0 break
			reti							; BCNTIFG break
			reti							; clock low timeout break
			reti							; 9th bit break
GetRX		mov.w	&UCB0RXBUF,RXData		; Get RX data
			reti
;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET                   ;
            .sect	".int55"				; USCI_B0_VECTOR
            .short	USCI_ISR				;
            .end
