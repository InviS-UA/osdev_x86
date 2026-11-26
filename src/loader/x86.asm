section _TEXT class=CODE

global _x86_con
_x86_con:
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