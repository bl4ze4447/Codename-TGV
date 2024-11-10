[org 0x7c00]
KERNEL_OFFSET equ 0x1000

    mov [BOOT_DRIVE], dl

    mov bp, 0x9000
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print_string
    call new_line

    call load_kernel

    call switch_to_pm

    jmp $


%include "boot/gdt.asm"
%include "boot/utilities/16bit/string.asm"
%include "boot/utilities/16bit/disk.asm"
%include "boot/utilities/32bit/string.asm"
%include "boot/utilities/32bit/protected_mode.asm"

[bits 16]

load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_string
    call new_line
    
    mov bx, KERNEL_OFFSET
    mov dh, 15                  ; first 15 sectors
    mov dl, [BOOT_DRIVE]
    call disk_load 

    ret

[bits 32]

BEGIN_PM:

    mov ebx, MSG_PROT_MODE
    call print_string32

    call KERNEL_OFFSET

    jmp $

BOOT_DRIVE      db 0
MSG_REAL_MODE   db 'Operating system succesfully started 16-bit Real Mode', 0
MSG_PROT_MODE   db 'Succesfully switched to 32-bit Protected Mode', 0
MSG_LOAD_KERNEL db 'Loading kernel into memory...', 0

times 510-($-$$) db 0   ; padding
dw 0xaa55               ; magic number