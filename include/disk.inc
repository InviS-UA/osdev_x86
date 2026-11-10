%ifndef DISK_INC
%define DISK_INC

[bits 16]

;
; Disk initialization
;   dl <- drive number
;
DiskInit:
    PUSH_MULTI ax, bx, cx, di, es

    mov ah, 08h
    xor di, di
    mov es, di
    int 13h

    inc dh
    mov [Heads], dh

    and cl, 0x3F
    xor ch, ch
    mov [Sectors], cx

    POP_MULTI ax, bx, cx, di, es

    ret

ReadSectors:
    PUSH_MULTI ax, bx, dx, cx, di

    push cx
    call LBA2CHS
    pop ax

    mov ah, 02h
    mov di, 3

.loop:
    pusha
    stc
    int 13h
    jnc .ret

    mov ah, 0
    stc
    int 13h
    popa

    dec di
    jnz .loop

.fail:
    cli
    jmp .fail

.ret:
    POP_MULTI ax, bx, dx, cx, di
    popa

    ret

LBA2CHS:
    push ax
    push dx

    xor dx, dx
    div word [Sectors]

    inc dx
    mov cx, dx

    xor dx, dx
    div word [Heads]

    mov dh, dl
    mov ch, al
    shr ah, 6
    or cl, ah

    pop ax
    mov dl, al
    pop ax

    ret

; Cluster2LBA:
;     sub ax, 2
;     movzx cx, byte [Clusters]
;     mul cx
;     ret

Sectors:    dw 18
Heads:      dw 2

%endif