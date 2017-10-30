//Parpadeo de led en lenguaje C
//Brayhan Gabriel
//gbrayhan@gmail.com


#include "msp430g2553.h"

int main( void )
{
  // Stop watchdog timer to prevent time out reset
  WDTCTL = WDTPW + WDTHOLD;
  
  P1DIR |= BIT0;           // P1.0 as o/p
     P1OUT = 0x00;            // clear Port 1
     int i;
     while(1){ //infinite loop
       for(i=0;i<0x1000;i++); // delay ~1 Second
      
       P1OUT ^= BIT0;         // toggle P1.0
    
       for(i=0;i<0x1000;i++); // delay ~1 Second
     }

  return 0;
}
