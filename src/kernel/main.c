#include <stdint.h>
#include <prf.h>

extern uint8_t BootDrive;

void main()
{
    printf("BootDrive = %xh\r\n", BootDrive);
}