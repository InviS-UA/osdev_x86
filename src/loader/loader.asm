%include "defs.inc"
%include "macro.inc"

org 0x500
bits 16

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

    mov al, 0x0E
    call ScreenClear

    mov si, msg
    call Print

    mov dl, [bootDrive]
    call DiskInit

.halt:
    cli
    jmp .halt

%include "a20.inc"
%include "screen.inc"
%include "disk.inc"
%include "print16.inc"

bootDrive:  db 0
msg:        db 'Loading files...', ENDL, ENDL, 0