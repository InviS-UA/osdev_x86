%include "defs.inc"
%include "macro.inc"

org 0x9000
bits 16

jmp start

%include "print16.inc"

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, msg
    call Print

.halt:
    cli
    jmp .halt

msg: db 'Hello from kernel!', ENDL, 0