#include <stdint.h>
#include "vga.h"
#include "stdio.h"

void main(uint16_t bootDrive)
{
    VgaClear();

    printf("Executing loader...\n");
    printf("bootDrive=%xh\n", bootDrive);

    for (;;);
}