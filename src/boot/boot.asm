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

times 70 - ($ - $$) db 0

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    mov byte [DriveNumber], dl

    mov si, msgLoading
    call Print

    xor bx, bx
    mov es, bx
    mov bx, 0x500
    
    mov ax, 1
    mov cx, [loaderSectors]
    mov dl, [DriveNumber]
    call ReadSectors
    mov dl, [DriveNumber]

    xor ax, ax
    mov ds, ax
    mov es, ax

    jmp 0x0:0x500

.halt:
    cli
    jmp .halt

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

ReadSectors:
    push ax
    push bx
    push dx
    push cx
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
    jnz .loop

.fail:
    jmp ReadError

.ret:
    pop di
    pop cx
    pop dx
    pop bx
    pop ax
    popa

    ret

ReadError:
    mov si, msgError
    call Print
    jmp Reboot

Reboot:
    xor ax, ax
    int 16h
    jmp 0xFFFF:0x0

msgLoading:             db 'Booting OS...', 13, 10, 0
msgError:               db 'Read disk failed!', 13, 10, 0

times 508 - ($ - $$) db 0

loaderSectors:          dw 0

times 510 - ($ - $$) db 0
dw 0AA55h

buffer: