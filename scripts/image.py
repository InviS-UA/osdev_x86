from sys import argv

import os
import sh
import glob

from io import SEEK_SET


PROJ_DIR = os.environ.get("PROJ_DIR", default=".")
BUILD_DIR = os.environ.get("BUILD_DIR", default="build")

SECTOR_SIZE: int = 512


def create_file(target: str, sectors: int):
    with open(target, "wb+") as f:
        f.write(bytes(sectors * SECTOR_SIZE))
        f.close()


def install_boot(target: str, boot: str, offset=0):
    with open(boot, "rb") as fboot:
        with os.fdopen(os.open(target, os.O_WRONLY | os.O_CREAT), "wb+") as ftarget:
            ftarget.seek(offset * SECTOR_SIZE, SEEK_SET)
            
            ftarget.write(fboot.read(3))
            
            ftarget.seek(70, SEEK_SET)
            fboot.seek(70, SEEK_SET)
            ftarget.write(fboot.read())


target = argv[1]

create_file(target, 2880)

mkfs_fat = sh.Command('mkfs.fat')
mkfs_fat(target,
         F=12,
         n='OSDEV')

install_boot(target, f'{BUILD_DIR}/boot.bin')

sh.mcopy('-i', target, f'{BUILD_DIR}/kernel.sys', '::/kernel.sys')

for file in glob.glob(f'{PROJ_DIR}/image/*', recursive=True):
    sh.mcopy('-i', target, '-s', file, '::/')