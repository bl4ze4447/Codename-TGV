[org 0x7c00]



jmp $ ; Hang

%include "nasm/utilities/string.asm"
%include "nasm/utilities/numbers.asm"
%include "nasm/utilities/disk.asm"

times 510-($-$$) db 0   ; padding
dw 0xaa55               ; magic number