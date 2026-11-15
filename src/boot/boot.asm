org 0x7C00
bits 16

jmp short start
nop

Oem:                db 'abcdefgh'
BytesPerSector:     dw 512
SectorsPerCluster:  db 1
ReservedSectors:    dw 1
FATCount:           db 2
RootDirEntries:     dw 0E0h
TotalSectors:       dw 2880
MediaDescType:      db 0F0h
SectorsPerFAT:      dw 9
SectorsPerTrack:    dw 18
Heads:              dw 2
HiddenSectors:      dd 0
LargeSectorCount:   dd 0

DriveNumber:        db 0
                    db 0
Signature:          db 0x29
VolumeId:           db 0x11, 0x22, 0x33, 0x44
VolumeLabel:        db 'OSDEV      '
SystemId:           db 'FAT12   '

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    mov byte [DriveNumber], dl

    mov si, msgLoading
    call Print

    mov ax, [SectorsPerFAT]
    mov bl, [FATCount]
    xor bh, bh
    mul bx
    add ax, [ReservedSectors]
    mov word [dataSector], ax
    push ax

    mov ax, [RootDirEntries]
    shl ax, 5
    xor dx, dx
    div word [BytesPerSector]

    test dx, dx
    jz .loadRoot
    inc ax

.loadRoot:
    add word [dataSector], ax
    mov cl, al
    pop ax
    mov dl, [DriveNumber]
    mov bx, buffer
    call ReadSectors
    
    xor bx, bx
    mov di, buffer

.searchKernel:
    mov si, fileKernelSys
    mov cx, 11
    push di
    repe cmpsb
    pop di
    je .found

    add di, 32
    inc bx
    cmp bx, [RootDirEntries]
    jl .searchKernel

    jmp KernelNotFound

.found:
    mov ax, [di + 26]
    mov [cluster], ax

    mov dl, [DriveNumber]
    mov ax, [ReservedSectors]
    mov cl, [SectorsPerFAT]
    mov bx, buffer
    call ReadSectors

    xor bx, bx
    mov es, bx
    mov bx, 0x500
    
.loadKernel:
    mov ax, [cluster]
    call Cluster2LBA
    add ax, [dataSector]

    mov dl, [DriveNumber]
    mov cl, 1
    call ReadSectors

    add bx, [BytesPerSector]

    mov ax, [cluster]
    mov cx, 3
    mul cx
    mov cx, 2
    div cx

    mov si, buffer
    add si, ax
    mov ax, [ds:si]

    or dx, dx
    jz .evenCluster

    shr ax, 4
    jmp .nextCluster

.evenCluster:
    and ax, 0x0FFF

.nextCluster:
    cmp ax, 0x0FF8
    jae .finish

    mov [cluster], ax
    jmp .loadKernel

.finish:
    mov dl, [DriveNumber]

    xor ax, ax
    mov ds, ax
    mov es, ax

    jmp 0x0:0x500

    cli
    hlt

Print:
    push si
    push ax
    push bx

.loop:
    lodsb
    or al, al
    jz .ret

    mov ah, 0Eh
    mov bh, 0
    int 0x10

    jmp .loop

.ret:
    pop bx
    pop ax
    pop si
    ret

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

ReadSectors:
    push ax
    push bx
    push cx
    push dx
    push di

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
    test di, di
    jnz .loop

.fail:
    jmp ReadError

.ret:
    popa

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

ReadError:
    mov si, msgReadError
    call Print
    jmp Reboot

KernelNotFound:
    mov si, msgKernelNotFound
    call Print
    jmp Reboot

Reboot:
    xor ax, ax
    int 16h
    jmp 0xFFFF:0x0

msgLoading:             db 'Booting OS...', 13, 10, 0
msgReadError:           db 'Read disk failed!', 13, 10, 0
msgKernelNotFound:      db 'KERNEL.SYS not found!', 13, 10, 0
fileKernelSys:          db 'KERNEL  SYS'
cluster:                dw 0
dataSector:             dw 0

times 510 - ($ - $$) db 0
dw 0AA55h

buffer: