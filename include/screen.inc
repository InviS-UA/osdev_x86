%ifndef SCREEN_INC
%define SCREEN_INC

[bits 16]

;
; Clear the screen and fill with color
;   al <- color code
;
ScreenClear:
    PUSH_MULTI ax, cx, di, es

    mov di, SCREEN_BUFFER
    mov es, di
    mov di, 1

    mov cx, 2000

.loop:
    mov byte [es:di], al
    add di, 2

    loop .loop

    POP_MULTI ax, cx, di, es

    ret

%endif