; b-ost-loader
; > Version 0.0.1 (main.beta.alpha)
; > Author: Belu D. Antonie-Gabriel (bl4ze4447)
; > Release date: 18/11/2024

[org 0x7c00]
; Kernel is located at 0x1000
KERNEL_OFFSET equ 0x1000

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
    
    mov bx, MSG_A20_INACTIVE
    call print_string
    jmp $

; A20 Enabled, we can continue running the bootloader
a20_enabled:
    call load_kernel         
    call switch_to_pm

    jmp $

%include "boot/gdt.asm"
%include "boot/utilities/16bit/a20_line.asm"
%include "boot/utilities/16bit/string.asm"
%include "boot/utilities/16bit/disk.asm"
%include "boot/utilities/32bit/string.asm"
%include "boot/utilities/32bit/protected_mode.asm"

[bits 16]
; Loading 15 sectors is enough for the kernel to be loaded in
load_kernel:
    mov bx, KERNEL_OFFSET  
    mov dh, 15                 
    mov dl, [BOOTDRIVE]       
    call load_sectors
    
    ret

[bits 32]
switch_to_kernel:
    ; Show user that we succesfully got into Protected Mode
    mov ebx, MSG_PM_SWITCHED
    call print_string32

    ; Bootloader's job is done, it's time for the Kernel
    call KERNEL_OFFSET         
    jmp $

BOOTDRIVE               db 0
MSG_A20_INACTIVE        db 'ERR16: A20 cannot be enabled', 0
MSG_PM_SWITCHED         db '32: Protected mode enabled', 0

times 510-($-$$) db 0   ; padding
dw 0xaa55               ; magic number