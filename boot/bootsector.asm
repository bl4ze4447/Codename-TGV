[org 0x7c00]
KERNEL_OFFSET equ 0x1000

    mov [BOOT_DRIVE], dl            ; DL is used to store the bootdrive

    mov bp, 0x9000                  ; Set up the stack
    mov sp, bp

    mov bx, MSG_REAL_MODE        
    call print_line                 ; show message to user      

    call is_a20_enabled
    cmp ax, 1
    jne $                           

    call load_kernel                ; load our kenel into memory

    call switch_to_pm               ; everything is set up, we can switch to protected mode now

    jmp $

%include "boot/gdt.asm"
%include "boot/utilities/16bit/a20_line.asm"
%include "boot/utilities/16bit/string.asm"
%include "boot/utilities/16bit/disk.asm"
%include "boot/utilities/32bit/string.asm"
%include "boot/utilities/32bit/protected_mode.asm"

[bits 16]

load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_line
    
    mov bx, KERNEL_OFFSET  
    mov dh, 15                  ; first 15 sectors
    mov dl, [BOOT_DRIVE]        ; boot_drive
    call disk_load              ; load first 15 sectors from the boot_drive

    mov bx, MSG_KERNEL_LOADED
    call print_line

    ret

[bits 32]

BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string32

    call KERNEL_OFFSET          ; give control to kernel

    jmp $

BOOT_DRIVE              db 0
MSG_REAL_MODE           db '(16-bit) Real Mode loaded.', 0
MSG_PROT_MODE           db '(32-bit) Protected Mode loaded.', 0
MSG_LOAD_KERNEL         db '(16-bit) Trying to load kernel in memory.', 0
MSG_KERNEL_LOADED       db '(16-bit) Succesfully loaded kernel in memory.'

times 510-($-$$) db 0   ; padding
dw 0xaa55               ; magic number