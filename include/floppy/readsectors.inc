ReadSectors:
    PUSH_MULTI ax, bx, dx, cx, di

    push cx
    call LBA2CHS
    pop ax

    mov ah, 02h
    mov dl, [DriveNumber]
    mov di, 3

.loop:
    pusha
    stc
    int 13h
    jnc .success

    mov ah, 0
    stc
    int 13h
    popa

    dec di
    jnz .loop

.fail:
    pop cx
    POP_MULTI ax, bx, dx, cx, di
    mov ax, 1
    stc
    ret

.success:
    popa
    POP_MULTI ax, bx, dx, cx, di
    xor ax, ax
    clc
    ret