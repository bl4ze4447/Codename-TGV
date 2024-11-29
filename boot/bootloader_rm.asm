; cnb_bloader_rm
; > Version 0.0.4 (main.beta.alpha)
; > Author: bl4ze4447

[org 0x7c00]
BOOTLOADER_PM equ 0x800
KERNEL_OFFSET equ 0x1000
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; BIOS stores the bootdrive in DL
    mov [BOOTDRIVE], dl            

    ; Setup the stack
    mov bp, 0x9000                  
    mov sp, bp    

    ; Check if the A20 line and jump to a20_enabled if it is
    ; otherwise, hang with a message shown to the user
    call get_a20_state
    cmp ax, 1
    jz a20_enabled
    
    ; Safe to jump since if a20 is disabled it cannot continue running
    call enable_a20
    jmp a20_enabled
    
    ; Also hangs
    call print_a20_disabled

; A20 Enabled, we can continue running the bootloader
a20_enabled:
    call load_boot_pm
    call load_kernel
    call BOOTLOADER_PM
    
    jmp $

%include "boot/utilities/16bit/a20_line.asm"
%include "boot/utilities/16bit/string.asm"
%include "boot/utilities/16bit/disk.asm"

[bits 16]
; Load the second part of the bootloader
load_boot_pm:
    mov bx, BOOTLOADER_PM  
    mov dh, 1                 
    mov dl, [BOOTDRIVE]  
    mov cl, 0x02     
    call load_sectors
    
    ret

[bits 16]
; Load the kernel (7680 bytes is enough)
load_kernel:
    mov bx, KERNEL_OFFSET  
    mov dh, 15                 
    mov dl, [BOOTDRIVE] 
    mov cl, 0x03      
    call load_sectors
    
    ret

BOOTDRIVE               db 0

times 510-($-$$) db 0   ; padding
dw 0xaa55               ; magic number