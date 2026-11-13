LBA2CHS:
    push ax
    push dx

    xor dx, dx
    div word [SectorsPerTrack]

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

Cluster2LBA:
    sub ax, 2
    movzx cx, byte [SectorsPerCluster]
    mul cx
    ret