ENTRY(_start)
OUTPUT_FORMAT("binary")
phys = 0x00000500;

SECTIONS
{
    . = phys;

    .text : {
        __text_start = .;
        *(.text.entry)
        *(.text)
    }
    .data : {
        __data_start = .;
        *(.data)
    }
    .rodata : {
        __rodata_start = .;
        *(.rodata)
    }
    .bss : {
        __bss_start = .;
        *(.bss)
    }

    __end = .;
}