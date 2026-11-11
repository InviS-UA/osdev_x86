#pragma once

#include <stdint.h>

void cputc(uint8_t color, char c);
void putc(char c);

void cputs(uint8_t color, const char* str);
void puts(const char* str);