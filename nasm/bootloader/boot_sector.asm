[org 0x7c00]

%include "nasm/utilities/32bit/gdt.asm"
%include "nasm/utilities/32bit/string.asm"
%include "nasm/utilities/32bit/protected_mode.asm"

times 510-($-$$) db 0   ; padding
dw 0xaa55               ; magic number