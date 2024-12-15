; Codename-TGV-Bootloader-Part-2
; > Version 0.0.4 (main.beta.alpha)
; > Author: bl4ze4447

[org 0x800]
.KERNEL_OFFSET equ 0x1000

    call switch_to_pm
    jmp $

%include "boot/protected_mode/gdt.asm"
%include "boot/protected_mode/protected_mode.asm"

[bits 32]
switch_to_kernel:
    call .KERNEL_OFFSET
    jmp $

times 512-($-$$) db 0

