/* 
   Copyright 2019 Christian Gimenez
   
   Author: Christian Gimenez   

   lcd-lib.h
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _LCD_LIB_H
#define _LCD_LIB_H 1

#include <stdint.h>

/**
 Interface data is 8/4 bits.
 */
#define DL 0
/** 
  Number of line is 2/1.
*/
#define N 1
/**
 Font size is 5x11/5x8.
 */
#define F 1
/**
 D=1: Entire display on
 */
#define D 1
/**
 C=1: Cursor on
 */
#define C 1
/**
 B=1: cursor position on
 */
#define B 1

/**
 Cursor move direction
 */
#define ID 1
/**
 Display shift
*/
#define S 1

void lcd_init();

void lcd_clear();

void lcd_return_home();

void lcd_send_command(int rs, uint8_t bin);

void lcd_send_char(char c, uint8_t addr);

void lcd_send_string(char *s, unsigned int delay, uint8_t addr);

void lcd_display_left(unsigned int amount, unsigned int delay);
void lcd_display_right(unsigned int amount, unsigned int delay);

void lcd_cursor_left(unsigned int amount, unsigned int delay);
void lcd_cursor_right(unsigned int amount, unsigned int delay);

void lcd_set_cgram(uint8_t num, uint8_t pattern[8]);

void lcd_print_cgram(uint8_t num, uint8_t ddra_addr);

#define CURSOR_DECREMENT 0
#define CURSOR_INCREMENT 1
#define SHIFT_ENABLE 1
#define SHIFT_STATIC 0
void lcd_entry_mode(uint8_t cursor, uint8_t shift);

#define DISPLAY_ON 1
#define DISPLAY_OFF 0
#define CURSOR_ON 1
#define CURSOR_OFF 0
#define BLINK_ON 1
#define BLINK_OFF 0
void lcd_display_mode(uint8_t display, uint8_t cursor, uint8_t blink);

#define N_DOUBLE_LINES 1
#define N_SINGLE_LINE 0
#define FONT_LARGE 1
#define FONT_SMALL 0
void lcd_function_set(uint8_t lines, uint8_t font);

#endif // _LCD_LIB_H
