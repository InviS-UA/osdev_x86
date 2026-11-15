FATLoadChain:
    pusha
    push es

    mov ax, [ReservedSectors]
    mov cl, [SectorsPerFAT]
    xor bx, bx
    mov es, bx
    mov bx, FAT_CHAIN_OFFSET
    call ReadSectors

    pop es
    popa

    ret