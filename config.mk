export PATH := /home/invis/watcom/binl64/:$(PATH) # change path, if compiler installed in other place

export ASM = nasm
export ASMFLAGS =
export CC16 = wcc
export CFLAGS16 = -za99
export LD16 = wlink

export PROJ_DIR = $(abspath .)
export BUILD_DIR = $(abspath build)