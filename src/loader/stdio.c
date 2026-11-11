#include "stdio.h"
#include "vga.h"

void cputc(uint8_t color, char c)
{
    VgaPutc(c, 1, color);
}

void putc(char c)
{
    VgaPutc(c, 0, 0);
}

void cputs(uint8_t color, const char* str)
{
    while (*str)
    {
        cputc(color, *str);
        str++;
    }
}

void puts(const char* str)
{
    while (*str)
    {
        putc(*str);
        str++;
    }
}