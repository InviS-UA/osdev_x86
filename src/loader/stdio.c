#include <stdio.h>
#include <x86.h>

void puts(const char* str)
{
    while (*str) x86_con(*(str++));
}