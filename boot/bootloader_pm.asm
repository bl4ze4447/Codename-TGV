; cnb_bloader_pm
; > Version 0.0.4 (main.beta.alpha)
; > Author: bl4ze4447

[org 0x800]
KERNEL_OFFSET equ 0x1000
    ; Make the switch to protected mode
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    call switch_to_pm

%include "boot/gdt.asm"
%include "boot/utilities/32bit/protected_mode.asm"

[bits 32]
switch_to_kernel:
    ; Bootloader's job is done, it's time for the Kernel
    call KERNEL_OFFSET
    jmp $

times 512-($-$$) db 0   ; padding

