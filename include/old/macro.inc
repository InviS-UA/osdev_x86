%ifndef MACRO_INC
%define MACRO_INC

[bits 16]

%macro PUSH_MULTI 1-*
    %rep %0
        push %1
        %rotate 1
    %endrep
%endmacro

%macro POP_MULTI 1-*
    %rep %0
        %rotate -1
        pop %1
    %endrep
%endmacro

%endif