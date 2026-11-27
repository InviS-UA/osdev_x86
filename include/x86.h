#pragma once

#include <common.h>
#include <stdbool.h>

void x86_tty_write(char c);

bool x86_drv_read(u8 id,
                  u16 cylinder,
                  u16 head,
                  u16 sector,
                  u8 sectors,
                  u8 FAR* data);

bool x86_drv_reset(u8 id);

bool x86_drv_params(u8 id,
                    u8* drvType,
                    u16* cylinders,
                    u16* heads,
                    u16* sectors);