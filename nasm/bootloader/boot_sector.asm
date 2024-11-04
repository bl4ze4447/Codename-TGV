[org 0x7c00]

mov dx, 4095
call print_hex
call new_line
mov dx, 16
call print_hex
call new_line 
mov dx, 10
call print_hex




jmp $ ; Hang

%include "nasm/utilities/string.asm"
%include "nasm/utilities/numbers.asm"

; Data
SZ_GREET:
    db 'Hello, World!', 0

SZ_BYE:
    db 'Well, this is all!', 0

times 510-($-$$) db 0   ; padding
dw 0xaa55               ; magic number