bits 16

global x86_wrt_chr_tty
x86_wrt_chr_tty:
    push bp
    mov bp, sp

    push bx

    mov ah, 0Eh
    mov al, [bp + 4]
    mov bh, 0
    int 10h
    
    pop bx

    mov sp, bp
    pop bp
    ret