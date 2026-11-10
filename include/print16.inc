%ifndef PRINT_INC
%define PRINT_INC

[bits 16]

;
; Print string to the screen
;   ds:si <- target string
;
Print:
    PUSH_MULTI ax, bx, si

.loop:
    lodsb
    or al, al
    jz .ret

    mov ah, 0Eh
    mov bh, 0
    int 0x10

    jmp .loop

.ret:
    POP_MULTI ax, bx, si
    
    ret

%endif