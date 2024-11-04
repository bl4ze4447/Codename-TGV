[org 0x7c00]

    mov [BOOT_DRIVE], dl

    mov bp, 0x8000
    mov sp, bp                  ; setup stack

    mov bx, 0x9000              ; load 5 sectors (0x0000(ES):0x9000(BX))
    mov dh, 5                   ; from boot disk
    mov dl, [BOOT_DRIVE]
    call disk_load

    mov dx, [0x9000]            ; first read sector
    call print_hex 

    call new_line

    mov dx, [0x9000 + 512]
    call print_hex              ; 2nd loaded sector

jmp $

%include "nasm/utilities/string.asm"
%include "nasm/utilities/numbers.asm"
%include "nasm/utilities/disk.asm"

BOOT_DRIVE db 0

times 510-($-$$) db 0   ; padding
dw 0xaa55               ; magic number

times 256 dw 0xdada     ; 2 bytes * 256
times 256 dw 0xface     ; 2 bytes * 256; used for checking disk_load