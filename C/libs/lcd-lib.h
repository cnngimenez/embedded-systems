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

void lcd_ddram_addr(uint8_t addr);

void lcd_send_command(int rs, uint8_t bin);

void lcd_send_char(char c);

void lcd_send_string(char *s, unsigned int delay);

void lcd_display_left(unsigned int amount, unsigned int delay);
void lcd_display_right(unsigned int amount, unsigned int delay);

void lcd_cursor_left(unsigned int amount, unsigned int delay);
void lcd_cursor_right(unsigned int amount, unsigned int delay);

#endif // _LCD_LIB_H