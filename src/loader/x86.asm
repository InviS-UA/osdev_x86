bits 16

global x86_tty_write
x86_tty_write:
    push bp
    mov bp, sp

    push bx

    mov ah, 0Eh
    mov al, [bp + 4]
    mov bx, 0x0007
    int 10h
    
    pop bx

    mov sp, bp
    pop bp
    ret

global x86_drv_read
x86_drv_read:
    push bp
    mov bp, sp

    push bx
    push es

    mov dl, [bp + 4]        ; dl - drive number

    mov ch, [bp + 6]        ; ch - cylinder (lower 8 bits)
    mov cl, [bp + 7]        ; cl - cylinder to bits 6-7
    shl cl, 6

    mov dh, [bp + 8]        ; dh - head

    mov al, [bp + 10]       ; cl - sector to bits 0-5
    and al, 3Fh
    or cl, al
    
    mov al, [bp + 12]       ; al - count

    mov bx, [bp + 16]       ; es:bx - far pointer to data
    mov es, bx
    mov bx, [bp + 14]

    mov ah, 02h
    stc
    int 13h

    mov ax, 1
    sbb ax, 0               ; 1 on success, 0 on fail

    pop es
    pop bx

    mov sp, bp
    pop bp
    ret

global x86_drv_reset
x86_drv_reset:
    push bp
    mov bp, sp

    mov ah, 0
    mov dl, [bp + 4]
    stc
    int 13h

    mov ax, 1
    sbb ax, 0               ; 1 on success, 0 on fail

    mov sp, bp
    pop bp
    ret

global x86_drv_params
x86_drv_params:
    push bp             ; save old call frame
    mov bp, sp          ; initialize new call frame

    ; save regs
    push es
    push bx
    push si
    push di

    ; call int13h
    mov dl, [bp + 4]    ; dl - disk drive
    mov ah, 08h
    mov di, 0           ; es:di - 0000:0000
    mov es, di
    stc
    int 13h

    ; return
    mov ax, 1
    sbb ax, 0

    ; out params
    mov si, [bp + 6]    ; drive type from bl
    mov [si], bl

    mov bl, ch          ; cylinders - lower bits in ch
    mov bh, cl          ; cylinders - upper bits in cl (6-7)
    shr bh, 6
    mov si, [bp + 8]
    mov [si], bx

    xor ch, ch          ; sectors - lower 5 bits in cl
    and cl, 3Fh
    mov si, [bp + 12]
    mov [si], cx

    mov cl, dh          ; heads - dh
    mov si, [bp + 10]
    mov [si], cx

    ; restore regs
    pop di
    pop si
    pop bx
    pop es

    ; restore old call frame
    mov sp, bp
    pop bp
    ret