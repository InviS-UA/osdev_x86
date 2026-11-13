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


def install_boot(target: str, boot: str, loader_size: int, offset=0):
    with open(boot, "rb") as fboot:
        with os.fdopen(os.open(target, os.O_WRONLY | os.O_CREAT), "wb+") as ftarget:
            ftarget.seek(offset * SECTOR_SIZE, SEEK_SET)
            
            ftarget.write(fboot.read(3))
            
            ftarget.seek(70, SEEK_SET)
            fboot.seek(70, SEEK_SET)
            ftarget.write(fboot.read())
            
            ftarget.seek(508, SEEK_SET)
            ftarget.write(loader_size.to_bytes(2, byteorder='little'))


def install_loader(target: str, loader: str, offset=0):
    with open(loader, "rb") as floader:
        with os.fdopen(os.open(target, os.O_WRONLY | os.O_CREAT), "wb+") as ftarget:
            ftarget.seek(offset * SECTOR_SIZE, SEEK_SET)
            ftarget.write(floader.read())


target = argv[1]

create_file(target, 2880)

loader_size = os.stat(f'{BUILD_DIR}/loader.bin').st_size
loader_sectors = (loader_size + SECTOR_SIZE - 1) // SECTOR_SIZE

mkfs_fat = sh.Command('mkfs.fat')
mkfs_fat(target,
         F=12,
         R=loader_sectors + 1,
         n='OSDEV')

install_boot(target, f'{BUILD_DIR}/boot.bin', loader_sectors)
install_loader(target, f'{BUILD_DIR}/loader.bin', 1)

sh.mcopy('-i', target, f'{BUILD_DIR}/kernel.sys', '::/kernel.sys')

for file in glob.glob(f'{PROJ_DIR}/image/*', recursive=True):
    sh.mcopy('-i', target, '-s', file, '::/')