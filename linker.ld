ENTRY(_start)
SECTIONS
{
  . = 0x1000;
  .text :
  {
    *(.text)
    . = 0x2000; /* Align the end of the .text section to 0x2000 */
  }
  .data :
  {
    *(.data)
  }
  .bss :
  {
    *(.bss)
    . = 0x4000; /* Align the end of the .bss section to 0x4000 (padding) */
  }
  /DISCARD/ : { *(.eh_frame) }
}
