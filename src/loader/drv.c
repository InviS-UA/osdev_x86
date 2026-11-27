#include <drv.h>
#include <x86.h>

bool drv_init(drv* drive, u8 id)
{
    u8 drvType;
    u16 cylinders, heads, sectors;

    if (!x86_drv_params(id, &drvType, &cylinders, &heads, &sectors))
        return false;

    drive->id = id;
    drive->cylinders = cylinders + 1;
    drive->heads = heads + 1;
    drive->sectors = sectors;

    return true;
}

void lba2chs(drv* drive, u32 lba, u16* cylinder, u16* head, u16* sector)
{
    // sector = (LBA % sectors per track + 1)
    *sector = lba % drive->sectors + 1;

    // cylinder = (LBA / sectors per track) / heads
    *cylinder = (lba / drive->sectors) / drive->heads;

    // head = (LBA / sectors per track) % heads
    *head = (lba / drive->sectors) % drive->heads;
}

bool drv_read(drv* drive, u32 lba, u8 count, void FAR* data)
{
    u16 cylinder, head, sector;

    lba2chs(drive, lba, &cylinder, &head, &sector);

    for (usize i = 0; i < 3; i++) {
        if (x86_drv_read(drive->id, cylinder, head, sector, count, data))
            return true;

        x86_drv_reset(drive->id);
    }

    return false;
}