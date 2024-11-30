; cnb_bloader_pm
; > Version 0.0.4 (main.beta.alpha)
; > Author: bl4ze4447

[org 0x800]
.KERNEL_OFFSET equ 0x1000

    call switch_to_pm

%include "boot/gdt.asm"
%include "boot/utilities/32bit/protected_mode.asm"

[bits 32]
switch_to_kernel:
    call .KERNEL_OFFSET
    jmp $

times 512-($-$$) db 0

