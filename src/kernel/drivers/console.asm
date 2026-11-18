bits 16

section .text

global _con
_con:
    push bp
    mov bp, sp

    push bx

    mov al, [bp + 4]
    mov ah, 0Eh
    mov bx, 0x0007
    int 10h

    pop bx

    mov sp, bp
    pop bp
    ret