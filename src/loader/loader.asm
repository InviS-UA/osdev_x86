%include "defs.inc"
%include "macro.inc"

org 0x500
bits 16

jmp start

%include "a20.inc"
%include "screen.inc"
%include "floppy.inc"
%include "fat.inc"
%include "print16.inc"

start:
    cli

    mov [bootDrive], dl

    mov ax, 0x3000
    mov ss, ax
    mov sp, 0x0FFF

    call EnableA20

    sti

    mov ax, 0x0003
    int 10h

    mov al, 0x07
    call ScreenClear

    mov si, msg
    call Print

    call UpdateBPB
    test ax, ax
    jnz ReadError

    call FATLoadChain
    test ax, ax
    jnz ReadError

    call FATLoadRoot
    test ax, ax
    jnz ReadError

    mov si, fileKernelSys
    xor bp, bp
    mov bx, 0x9000
    call FATReadFile
    jc ReadError

    jmp 0x0:0x9000

.halt:
    cli
    jmp .halt

ReadError:
    mov si, msgError
    call Print
    cli
    hlt

UpdateBPB:
    mov ax, 0
    mov dl, [bootDrive]
    mov cl, 1
    mov bx, 0x7C00
    call ReadSectors
    add bx, 0x0E
    mov cx, word [es:bx]
    mov [ReservedSectors], cx
    ret

bootDrive:          db 0
msg:                db 'Loading kernel...', ENDL, ENDL, 0
msgError:           db 'Floppy read failed!', ENDL, 0
fileKernelSys:      db 'KERNEL  SYS'