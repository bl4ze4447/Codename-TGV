[org 0x7c00]

    mov bp, 0x9000
    mov sp, bp

    mov bx, [MSG_REAL_MODE]
    call print_string
    call new_line

    call switch_to_pm

    jmp $

%include "nasm/utilities/16bit/string.asm"
%include "nasm/bootloader/gdt.asm"
%include "nasm/utilities/32bit/string.asm"
%include "nasm/utilities/32bit/protected_mode.asm"

[bits 32]

BEGIN_PM:

    mov ebx, MSG_PROT_MODE
    call print_string32

    jmp $

MSG_REAL_MODE db 'Operating system succesfully started 16-bit Real Mode', 0
MSG_PROT_MODE db 'Succesfully switched to 32-bit Protected Mode', 0

times 510-($-$$) db 0   ; padding
dw 0xaa55               ; magic number