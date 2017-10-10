;******************************************************************************
;  MSP430FR57x Demo - MPU Write protection violation - PUC
;
;  Description: The MPU segment boundaries are defined by:
;  Border 1 = 0xC800 [segment #: 4]
;  Border 2 = 0xD000 [segment #: 8]
;  Segment 1 = 0xC200 - 0xC7FF
;  Segment 2 = 0xC800 - 0xCFFF
;  Segment 3 = 0xD000 - 0xFFFF
;  Segment 2 is write protected. Any write to an address in the segment 2 range
;  causes a PUC. The LED toggles due to repeated PUCs. A delay is included
;  so the debugger can gain access via JTAG.
;
;  ACLK = n/a, MCLK = SMCLK = TACLK = default DCO = ~625 KHz
;
;           MSP430FR5739
;         ---------------
;     /|\|               |
;      | |               |
;      --|RST            |
;        |               |
;        |           P1.0|-->LED
;
;   Tyler Witt
;   Texas Instruments Inc.
;   September 2011
;   Built with Code Composer Studio V4.2
;******************************************************************************
 .cdecls C,LIST,  "msp430fr5739.h"
ptr		.set	R5
data	.set	R6
;------------------------------------------------------------------------------
			.global _main
            .text                  			; Program reset
;------------------------------------------------------------------------------
_main
RESET       mov.w   #1DFEh,SP               ; Initialize stack pointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
			bis.b	#BIT0,&P1DIR			; Configure P1.0 for LED
			bit.b	#MPUSEG2IFG,&MPUCTL1
			jz		Delay
			xor.b	#BIT0,&P1OUT			; Toggle LED
Delay		mov.w	#15000,R15
L1			dec.w	R15
			jnz		L1
SetupMPU	mov.w	#MPUPW,&MPUCTL0			;Write PWD to acces MPU registers
			mov.w 	#0x0804,&MPUSEG			; B1 = 0xC800; B2 = 0xD000
											; Borders are assigned to segments
			bic.w	#MPUSEG2WE,&MPUSAM		; Segment 2 is protected from write
			bis.w	#MPUSEG2VS,&MPUSAM		; Violation select on write access
			mov.w	#MPUPW+MPUENA+MPULOCK,&MPUCTL0 ; Enable MPU protection
											; MPU registers locked until BOR
			mov.w	#0x88,data
			mov.w	#0xC802,ptr
			mov.w	data,0(ptr)

Mainloop	jmp		Mainloop				; Code never gets here
			nop
			
;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET                   ;
            .end
 