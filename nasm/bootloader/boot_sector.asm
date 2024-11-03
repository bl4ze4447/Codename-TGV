[org 0x7c00]


mov bx, SZ_GREET    ; fun parameter
call print_string   

call new_line

mov bx, SZ_BYE      ; fun parameter
call print_string

jmp $ ; Hang

%include "nasm/utilities/string.asm"

; Data
SZ_GREET:
    db 'Hello, World!', 0

SZ_BYE:
    db 'Well, this is all!', 0

times 510-($-$$) db 0   ; padding
dw 0xaa55               ; magic number