org 0x9000
bits 16

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, msg
    call Print

.halt:
    cli
    jmp .halt

Print:
    push ax
    push bx
    push si

.loop:
    lodsb
    or al, al
    jz .ret

    mov ah, 0Eh
    mov bh, 0
    int 0x10

    jmp .loop

.ret:
    pop si
    pop bx
    pop ax
    ret

msg: db 'Hello from kernel!', 13, 10, 0