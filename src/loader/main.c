#include <stdint.h>
#include "vga.h"
#include "stdio.h"

void main(uint16_t bootDrive)
{
    VgaClear(0x0E);

    puts("Executing loader...\n");

    for (;;);
}