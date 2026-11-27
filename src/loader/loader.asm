bits 16

section .text.entry

extern main
extern BootDrive

global _start

_start:
    cli

    mov byte [BootDrive], dl

    mov ax, ds
    mov ss, ax
    mov sp, 0xFFF0
    mov bp, sp

    sti
    
    call main

.halt:
    cli
    jmp .halt

BootDrive: db 0