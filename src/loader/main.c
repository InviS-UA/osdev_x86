#include <common.h>
#include <stdio.h>
#include <drv.h>

extern u8 BootDrive;

drv bootdrv;

u8 FAR* data = (u8 FAR*)0x20000000;

void main()
{
    printf("\r\nLOADER: Initialization boot drive...\r\n");

    if (!drv_init(&bootdrv, BootDrive)) {
        printf("Drive init error!\r\n");
        return;
    }

    printf("LOADER: BootDrive=%xh cyls=%u heads=%u sects=%u\r\n",
           bootdrv.id,
           bootdrv.cylinders,
           bootdrv.heads,
           bootdrv.sectors);
}