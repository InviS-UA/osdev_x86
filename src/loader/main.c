#include <common.h>
#include <print.h>

extern u8 BootDrive;

void main()
{
    printf("LOADING...\r\n");
    printf("BootDrive=%xh\r\n", BootDrive);
}