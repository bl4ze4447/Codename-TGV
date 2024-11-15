[org 0x7c00]
KERNEL_OFFSET equ 0x1000
    mov [BOOT_DRIVE], dl            ; DL is used to store the bootdrive

    mov bp, 0x9000                  ; Set up the stack
    mov sp, bp    

    call is_a20_enabled
    cmp ax, 1
    je a20_enabled
    
    call enable_a20
    cmp ax, 1
    je a20_enabled

    mov bx, MSG_A20_INACTIVE
    call print_line
    jmp $

a20_enabled:
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
    mov bx, KERNEL_OFFSET  
    mov dh, 15                  ; first 15 sectors
    mov dl, [BOOT_DRIVE]        ; boot_drive
    call disk_load              ; load first 15 sectors from the boot_drive

    mov bx, MSG_KERNEL_LOADED
    call print_line

    ret

[bits 32]

BEGIN_PM:
    mov ebx, MSG_PM_SWITCHED
    call print_string32
    
    call KERNEL_OFFSET          ; give control to kernel

    jmp $

BOOT_DRIVE              db 0
MSG_KERNEL_LOADED       db '16: Kernel loaded in memory', 0
MSG_A20_INACTIVE        db 'ERR16: A20 cannot be enabled', 0
MSG_PM_SWITCHED         db '32: Protected mode enabled', 0

times 510-($-$$) db 0   ; padding
dw 0xaa55               ; magic number