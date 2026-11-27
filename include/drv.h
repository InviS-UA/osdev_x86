#pragma once

#include <common.h>
#include <stdbool.h>

typedef struct {
    u8 id;
    u16 cylinders;
    u16 heads;
    u16 sectors;
} drv;

bool drv_init(drv* drive, u8 id);
bool drv_read(drv* drive, u32 lba, u8 count, void FAR* data);