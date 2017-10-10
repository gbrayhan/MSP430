/**
 * @file pcd8544.h
 * 
 * This is a complete driver for the Philips PCD8544 LCD driver, used
 * in the Nokia 3310 displays and subsequently in Olimex MOD-LCD3310
 * LCD extension.
 * 
 * Expected port/pin mappings:
 * 
 *   - D/_C on P2.0
 *   - SDIN on P2.1
 *   - SCE  on P2.2
 *   - SCK  on P2.3
 *   - RES  on P2.4
 * 
 * If the display on your device is offset by 5 pixels, causing the
 * top row of the display to be 5 pixels down, then add the define
 * PCD8544_FIX_YALIGN to your project or -DPCD8544_FIX_YALIGN to your
 * compiler flags in the makefile to fix this problem. This will also implement
 * soft wrapping for all drawing operations to mimic the behavior of the
 * original controller.
 *
 * When compiled, the driver can link putchar() to lcd_putchar(), allowing it
 * to integrate with the printf() present in mspgcc. If you do not wish to have
 * this link put in place, define -DPCD8544_NO_PRINTF in the makefile.
 * 
 * Based on code by TopHatHacker (github.com/tophathacker) and rewritten
 * and commented for tidyness and modularity.
 * 
 * Licensed under GNU GPL version 3
 * 
 * @version 1.0
 * @author Christopher Vagnetoft (noccylabs.info)
 */
#ifndef __PCD8544_H__
#define __PCD8544_H__

#include <msp430.h>
#include <string.h>

// D/C flag
#define LCD_SEND_COMMAND  0
#define LCD_SEND_DATA     1

// Helpful defines
#define LCD_X_RES  84
#define LCD_Y_RES  48
#define LCD_ROWS   6

// Apply pin mappings
#define DCPORT P2OUT
#define SDINPORT P2OUT
#define SCEPORT P2OUT
#define SCKPORT P2OUT
#define RESPORT P2OUT
#define GNDPORT P2OUT
// Bits for each of the pins
#define DC   BIT0
#define SDIN BIT1
#define SCE  BIT2
#define SCK  BIT3
#define RES  BIT4
#define GND	 BIT6


/**
 * @brief Send data or command to LCD
 * 
 * @param unsigned char The command or data byte
 * @param unsigned char LCD_SEND_COMMAND|LCD_SEND_DATA
 */
void lcd_send(unsigned char,unsigned char);

/**
 * @brief Clear the LCD
 * 
 * 
 */
void lcd_clear(void);

/**
 * @brief
 * 
 * @param unsigned char The line to clear (0-5)
 */
void lcd_clear_line(unsigned char l);

/**
 * @brief Initialize the LCD
 * 
 */
void lcd_init(void);

/**
 * @brief Set the cursor position
 * 
 * @param unsigned char Column offset (0-83)
 * @param unsigned char Row offset (0-5)
 */
void lcd_cursor(unsigned char,unsigned char);

/**
 * @brief Set the LCD contrast
 * 
 * @param char The contrast level (0-127)
 */
void lcd_contrast(char c);

/**
 * @brief Draw a glyph from a const char*
 * 
 * @param const char* The glyph to draw
 * @param unsigned char x The vertical offset (0-83)
 * @param unsigned char y The row (0-6)
 */
void lcd_draw_glyph(const char* glyph, unsigned char x, unsigned char y);

/**
 * @brief Draw a glyph from a const char and repeat it
 * 
 * @param const char* The glyph to draw
 * @param unsigned char x The vertical offset (0-83)
 * @param unsigned char y The row (0-6)
 * @param unsigned char w The number of columns to repeat
 */
void lcd_tile_glyph(const char* glyph, unsigned char x, unsigned char y, unsigned char w);

/**
 * @brief Draw text using the 5x8 font.
 *
 * This function will draw the provided string to the LCD at the specified
 * position. It will only consume as many columns as the text fills, so if you
 * want to draw a menu or such, instead see lcd_draw_text_block()
 * 
 * @see lcd_draw_text_block()
 * @param const char* The text to draw
 * @param unsigned char x The vertical offset (0-83)
 * @param unsigned char y The row (0-6)
 */
void lcd_draw_text(const char* string, unsigned char x, unsigned char y);

/**
 * @brief Draw text using the 5x8 font as a block.
 * 
 * This function will allow for updating menus and the likes, where you need
 * to remove the text or graphics that was in a spot when updating the menu
 * entries. Optional inverted text for extra spiffiness.
 *
 * @param const char* The text to draw
 * @param unsigned char x The vertical offset (0-83)
 * @param unsigned char y The row (0-6)
 * @param int If non-zero the text will be inversed
 * @param int The number of pixels to draw including the text
 */
void lcd_draw_text_block(const char* string, unsigned char x, unsigned char y, int inverse, int length);

/**
 * @brief Draw text using the 5x8 font at the current cursor position.
 *
 * This function will draw the provided string to the LCD at the current cursor
 * position. 
 * 
 * @param const char* The text to draw
 */
void lcd_put_char(const char c);

/**
 * @brief Write a byte to the display at the current position
 * 
 * @param unsigned char The byte to write
 */
void lcd_write_byte(unsigned char v);

#endif
