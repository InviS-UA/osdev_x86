bits 16

global x86_tty_write
x86_tty_write:
    push bp
    mov bp, sp

    push bx

    mov ah, 0Eh
    mov al, [bp + 4]
    mov bx, 0x0007
    int 10h
    
    pop bx

    mov sp, bp
    pop bp
    ret