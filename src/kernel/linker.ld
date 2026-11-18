ENTRY(start)
OUTPUT_FORMAT("binary")
phys = 0x500;

SECTIONS
{
    . = phys;

    .entry              : { _entry_seg = .;      *(.entry)   }
    .text               : { _text_seg =  .;       *(.text)   }
    .data               : { _data_seg =  .;       *(.data)   }
    .bss                : { _bss_seg =   .;        *(.bss)   }

    _end = .;
}