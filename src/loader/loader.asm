bits 16

section .entry

extern __bss_start
extern __end

extern main
global start

start:
    cli

    mov [bootDrive], dl

    mov ax, ds
    mov ss, ax
    mov sp, 0xFFF0
    mov bp, sp

    call EnableA20
    call LoadGDT

    mov eax, cr0
    or al, 1
    mov cr0, eax

    jmp dword 0x08:.pmode

.pmode:
    [bits 32]

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov edi, __bss_start
    mov ecx, __end
    sub ecx, edi
    mov al, 0
    cld
    rep stosb

    xor edx, edx
    mov dl, [bootDrive]
    push edx
    call main

    cli
    hlt

EnableA20:
    [bits 16]
    ; disable keyboard
    call A20WaitInput
    mov al, KbdControllerDisableKeyboard
    out KbdControllerCommandPort, al

    ; read control output port
    call A20WaitInput
    mov al, KbdControllerReadCtrlOutputPort
    out KbdControllerCommandPort, al

    call A20WaitOutput
    in al, KbdControllerDataPort
    push eax

    ; write control output port
    call A20WaitInput
    mov al, KbdControllerWriteCtrlOutputPort
    out KbdControllerCommandPort, al
    
    call A20WaitInput
    pop eax
    or al, 2                                    ; bit 2 = A20 bit
    out KbdControllerDataPort, al

    ; enable keyboard
    call A20WaitInput
    mov al, KbdControllerEnableKeyboard
    out KbdControllerCommandPort, al

    call A20WaitInput
    ret

A20WaitInput:
    [bits 16]
    ; wait until status bit 2 (input buffer) is 0
    ; by reading from command port, we read status byte
    in al, KbdControllerCommandPort
    test al, 2
    jnz A20WaitInput
    ret

A20WaitOutput:
    [bits 16]
    ; wait until status bit 1 (output buffer) is 1 so it can be read
    in al, KbdControllerCommandPort
    test al, 1
    jz A20WaitOutput
    ret

LoadGDT:
    [bits 16]
    lgdt [GDTDesc]
    ret

KbdControllerDataPort               equ 0x60
KbdControllerCommandPort            equ 0x64
KbdControllerDisableKeyboard        equ 0xAD
KbdControllerEnableKeyboard         equ 0xAE
KbdControllerReadCtrlOutputPort     equ 0xD0
KbdControllerWriteCtrlOutputPort    equ 0xD1

GDTTable:   ; NULL descriptor
            dq 0x0000000000000000

            ; 32-bit code segment
            dq 0x00CF9A000000FFFF

            ; 32-bit data segment
            dq 0x00CF92000000FFFF

            ; 16-bit code segment
            dq 0x000F9A000000FFFF

            ; 16-bit data segment
            dq 0x000F92000000FFFF

GDTDesc:    dw GDTDesc - GDTTable - 1
            dd GDTTable

bootDrive:  db 0