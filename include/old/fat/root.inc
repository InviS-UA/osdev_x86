FATLoadRoot:
    push es

    push dx
    mov ax, [SectorsPerFAT]
    mov bl, [FATCount]
    xor bh, bh
    mul bx
    add ax, [ReservedSectors]
    push ax

    mov ax, [RootDirEntries]
    shr ax, 5
    xor dx, dx
    div word [BytesPerSector]

    test dx, dx
    jz .load

    inc ax

.load:
    mov cl, al
    pop ax
    xor bx, bx
    mov es, bx
    mov bx, FAT_DIRECTORY_OFFSET
    pop dx
    call ReadSectors

    pop es
    ret