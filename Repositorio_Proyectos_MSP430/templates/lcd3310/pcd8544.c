
#include "pcd8544.h"
#include "font5x8.h"

#ifndef PCD8544_FIX_YALIGN
#warning If your display is offset by 5 pixels, add -DPCD8544_FIX_YALIGN to CXXFLAGS
#endif

unsigned char cx, cy;
 
void lcd_send(unsigned char data, unsigned char cd) {
 
	volatile unsigned char bits;
	unsigned short cnt=8;
	// assume clk is hi
	// Enable display controller (active low).
	SCEPORT &= ~SCE;  //RESET SCE

	// command or data
	if(cd == LCD_SEND_DATA) {
		DCPORT |= DC;  //set to send data
	} else {  // reset to send command
		DCPORT &= ~DC;
	}

	///// SEND SPI /////
	bits=0x80; // bits is mask to select bit to send. select bit msb first

#ifdef PCD8544_USE_ASM
/*
 * Warning! This code is experimental and untested
 */
	__asm__(
		"1:	bic.b %5,%6;"
		"	mov.b %1,r11;"
		"	and r11,[bits];"
		"	cmp r11,[bits];"
		"	jne 2f;"
		"	bic.b [sdinport],[sdin];"
		"	jmp 3f;"
		"2:	bis.b [sdinport],[sdin];"
		"3:	dec cnt; rrc.b [bits];"
		"	bis.b %5,%6;"
		"	dec.b [cnt]; cmp [cnt],0; jne 1b;"
		:
		: [cnt] "r" (cnt), [data] "r" (data), [bits] "r" (bits), 
		  [sdinport] "m" (SDINPORT), [sdin] "r" (SDIN), 
		  [sckport] "m" (SCKPORT), [sck] "r" (SCK)
		: "r11"
	);
#else
	//send data
	while (0<cnt--) {
		// put bit on line
		// cycle clock
		SCKPORT &= ~SCK;
		if ((data & bits)>0) SDINPORT |= SDIN; else SDINPORT &= ~SDIN;
		//Delay(1);
		SCKPORT |= SCK;
		//Delay(2);
		// SHIFT BIT MASK 1 right
		bits >>= 1;
	}
#endif

	// Disable display controller.
	SCEPORT |= SCE;
	
	if (cd == LCD_SEND_DATA) {
		cx++;
		if (cx > (LCD_X_RES - 1)) {
			cx = 0; cy++;
			#ifdef PCD8544_FIX_YALIGN
			// Soft wrapping when FIX_YALIGN is defined
			lcd_cursor(cx,cy);
			#endif
		}
	}
	 
}
 
void lcd_clear(void) {
	for (int i=0;i<LCD_ROWS;i++) { // number of rows
		lcd_cursor(0,i);
		for (int j=0;j<LCD_X_RES;j++)  // number of columns
			lcd_send(0x00, LCD_SEND_DATA);
	}
}
 
void lcd_clear_line(unsigned char l) {
	lcd_cursor(0,l);
	for (int j=0;j<LCD_X_RES;j++)  // number of columns
		lcd_send(0x00, LCD_SEND_DATA);
}
 
void lcd_init(void) {

 	// set up ports and initialize to output
 	P2DIR = 0xFF;

	// Reset LCD
	SCEPORT &= ~SCE;          // RESET SCE to enable
	// toggle RES
	RESPORT |= RES;           // Set RES
	__delay_cycles(300);
	RESPORT &= ~RES;          // reset RES
	__delay_cycles(300);
	RESPORT |= RES;           // Set RES

	// Cycle Clock
	SCKPORT &= ~SCK;
	SCKPORT |= SCK;

	// Disable display controller.
	SCEPORT |= SCE;           // bring high to disable 

	__delay_cycles(300);

	// Send sequence of command
	lcd_send( 0x21, LCD_SEND_COMMAND );  // LCD Extended Commands.
	// lcd_send( 0xC8, LCD_SEND_COMMAND );  // Set LCD Vop (Contrast).
	lcd_send( 0x80 | 0x70, LCD_SEND_COMMAND );  // Set LCD Vop (Contrast).
	lcd_send( 0x06, LCD_SEND_COMMAND );  // Set Temp coefficent to 2.
	lcd_send( 0x13, LCD_SEND_COMMAND );  // LCD bias mode 1:100.
	#ifdef PCD8544_FIX_YALIGN
	lcd_send( 0x45, LCD_SEND_COMMAND );  // LCD blank - Shift LCD 5 up (row starts at 1)
	#endif
	lcd_send( 0x20, LCD_SEND_COMMAND );  // LCD Standard Commands, Horizontal addressing mode.
	lcd_send( 0x40, LCD_SEND_COMMAND );  // LCD blank
	lcd_send( 0x08, LCD_SEND_COMMAND );  // LCD blank
	lcd_send( 0x0C, LCD_SEND_COMMAND );  // LCD in inverse mode.

	lcd_clear();
 
}
 
void lcd_contrast(char c) {
	lcd_send( 0x21, LCD_SEND_COMMAND );  // LCD Extended Commands.
	lcd_send( c, LCD_SEND_COMMAND );  // Set LCD Vop (Contrast).
	lcd_send( 0x20, LCD_SEND_COMMAND );  // LCD Standard Commands, Horizontal addressing mode.
}
 
void lcd_cursor(unsigned char x, unsigned char y) {
	if (!((x >= 0) && (x <= 83) && (y>=0) && (y<=5))) return;
    lcd_send(0x80|x,LCD_SEND_COMMAND);
	#ifdef PCD8544_FIX_YALIGN
    lcd_send(0x40|(y+1),LCD_SEND_COMMAND);
	#else
    lcd_send(0x40|y,LCD_SEND_COMMAND);
	#endif
	cx = x; cy = y;
}
 
void lcd_draw_glyph(const char* glyph, unsigned char x, unsigned char y) {
	lcd_cursor(x,y);
	for (int c = 0; c < glyph[0]; c++) {
		lcd_send(glyph[c+1], LCD_SEND_DATA);
	}
}

void lcd_tile_glyph(const char* glyph, unsigned char x, unsigned char y, unsigned char w) {
	lcd_cursor(x,y);
	int c = 0;
	for (int p = 0; p < w; p++) {
		lcd_send(glyph[c+1], LCD_SEND_DATA);
		if (++c >= glyph[0]) c = 0;
	}
}

void lcd_put_char(const char c) {
	for (int n = 0; n < 6; n++) {
		lcd_send(font5x8[(unsigned char)c][n], LCD_SEND_DATA);
	}
}

void lcd_draw_text(const char* string, unsigned char x, unsigned char y) {
	lcd_cursor(x,y);
	for (int c = 0; c < strlen(string); c++) {
		for (int n = 0; n < 6; n++) {
			lcd_send(font5x8[(unsigned char)string[c]][n], LCD_SEND_DATA);
		}
	}
}

void lcd_draw_text_block(const char* string, unsigned char x, unsigned char y, int inverse, int length) {
	int mask = (inverse!=0)?0xFF:0x00;
	lcd_cursor(x,y);
	for (int c = 0; c < strlen(string); c++) {
		for (int n = 0; n < 6; n++) {
			lcd_send(font5x8[(unsigned char)string[c]][n]^mask, LCD_SEND_DATA);
		}
	}
	for (int n = length; n > strlen(string)*5; n--) {
        lcd_send(mask, LCD_SEND_DATA);	
	}
}

void lcd_write_byte(unsigned char v) {
	lcd_send(v,LCD_SEND_DATA);
}

#ifndef PCD8544_NO_PRINTF
int putchar(int c) { 
	lcd_put_char((char)c&0xFF); 
	return 1; 
}
#endif

