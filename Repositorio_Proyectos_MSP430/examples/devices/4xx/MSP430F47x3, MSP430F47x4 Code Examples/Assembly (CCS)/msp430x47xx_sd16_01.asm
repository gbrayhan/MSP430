;******************************************************************************
;   MSP430x47xx Demo - SD16, Continuous Conversion on a Group of Channels
;
;   Description: This program uses the SD16 module to perform continuous
;   conversions on a group of channels (0, 1, and 2). A SD16 interrupt occurs
;   whenever the conversions have completed. Test by applying voltages to the
;   three input channels and setting a breakpoint at the "nop" instruction as
;   indicated below. Run program until it reaches the breakpoint, then use
;   the debugger's memory window to view the conversion results.
;   Results (upper 16 bits only) are stored for each channel.
;   CH0 results are stored at RAM addresses 0x200 - 0x20E, CH1 results are
;   stored at addresses 0x210 - 0x21E, and CH2 results are stored at
;   addresses 0x220 - 0x22E.
;   ACLK = LFXT1 = 32768Hz, MCLK = SMCLK = default DCO = 32 x ACLK = 1048576Hz
;   //* An external watch crystal between XIN & XOUT is required for ACLK *//	
;   //* For minimum Vcc required for SD16 module - see datasheet        *//
;   //* 100nF cap btw Vref and AVss is recommended when using 1.2V ref *//
;
;                 MSP430x47xx
;             -----------------
;          /|\|              XIN|-
;           | |                 | 32kHz
;           --|RST          XOUT|-
;             |                 |
;    Vin1+ -->|A0.0+            |
;    Vin1- -->|A0.0-            |
;    Vin2+ -->|A1.0+            |
;    Vin2- -->|A1.0-            |
;    Vin3+ -->|A2.0+            |
;    Vin3- -->|A2.0-            |
;             |                 |
;             |            VREF |---+
;             |                 |   |
;             |                 |  -+- 100nF
;             |                 |  -+-
;             |                 |   |
;             |            AVss |---+
;             |                 |
;
;  JL Bile
;  Texas Instruments Inc.
;  June 2008
;  Built Code Composer Essentials: v3 FET
;*******************************************************************************
 .cdecls C,LIST, "msp430x47x4.h"

;-----------RAM Variables------------------------------------------------------
Ch0result   .equ     0200h                   ; Channel CH0 results
Ch1result   .equ     0210h                   ; Channel CH1 results
Ch2result   .equ     0220h                   ; Channel CH2 results

;-----------CPU Registers Used-------------------------------------------------
;           R5 - Table index
;           R15 - Temporary working register

;-------------------------------------------------------------------------------
			.text							; Program Start
;-------------------------------------------------------------------------------
RESET       mov.w   #900h,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupFLL    bis.b   #XCAP14PF,&FLL_CTL0     ; Configure load caps
            mov.w   #10000,R15              ;
Xtal_Wait   dec.w   R15                     ; Delay for 32 kHz crystal to
            jnz     Xtal_Wait		    ; stabilize
SetupSD16   mov.w   #SD16REFON+SD16SSEL0,&SD16CTL  ; 1.2V ref, SMCLK
            bis.w   #SD16GRP,&SD16CCTL0     ; Group CH0 with CH1
            bis.w   #SD16GRP,&SD16CCTL1     ; Group CH1 with CH2,
                                            ; CH2 is master of channel group
            mov.w   #03600h,R15             ; Delay needed for 1.2V ref startup
L$1         dec.w   R15                     ;
            jnz     L$1                     ;
            clr.w   R5                      ; Initialize table index
            bis.w   #SD16IE,&SD16CCTL2      ; Enable CH2 interrupt
Mainloop    bis.w   #SD16SC,&SD16CCTL2      ; Start conversion for all channels
            bis.w   #LPM0+GIE,SR            ; Enter LPM0 (disable CPU)
                                            ;
;------------------------------------------------------------------------------
SD16A_ISR   ; SD16 Interrupt Service Routine
;------------------------------------------------------------------------------
            add.w   &SD16IV,PC              ; Add offset to PC
            reti                            ; Vector 0: No interrupt
            jmp     SD_OV                   ; Vector 2: Overflow
            jmp     SD_CH0                  ; Vector 4: CH0 IFG
            jmp     SD_CH1                  ; Vector 6: CH1 IFG
                                            ; Vector 8: CH2 IFG
                                            ;
;-----------SD16 Channel 2 Interrupt Handler-----------------------------------
SD_CH2      mov.w   &SD16MEM2,Ch2result(R5) ; Save CH2 result
            mov.w   &SD16MEM1,Ch1result(R5) ; Save CH1 result
            mov.w   &SD16MEM0,Ch0result(R5) ; Save CH0 result
            incd    R5                      ; Double increment table index
            and.w   #0Eh,R5                 ; Modulo table index
            cmp.w   #0000h,R5               ; Does index = 0?
            jne     SD_CH2_END              ; No, return from interrupt
            nop                             ; SET BREAKPOINT HERE
SD_CH2_END  reti                            ; Return from interrupt
                                            ;
;-----------SD16 Memory Overflow Interrupt Handler-----------------------------
SD_OV       reti                            ; Return from interrupt
                                            ;
;-----------SD16 Channel 0 Interrupt Handler-----------------------------------
SD_CH0      reti                            ; Return from interrupt
                                            ;
;-----------SD16 Channel 1 Interrupt Handler-----------------------------------
SD_CH1      reti                            ; Return from interrupt
                                            ;
;------------------------------------------------------------------------------
;			Interrupt Vectors
;------------------------------------------------------------------------------
            .sect     ".reset"            	; RESET Vector
            .short   RESET                  ;
            .sect   ".int07"            	; SD16 Vector
            .short   SD16A_ISR             	;
            .end
