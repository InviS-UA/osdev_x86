org 0x500
bits 16

main:
    cli

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ax, ds
    mov ss, ax
    mov sp, 0xFFF0

    sti

    mov si, msg
    call Print

    cli
    hlt

;
; Prints string to the screen
;   ds:si <- target string
;
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