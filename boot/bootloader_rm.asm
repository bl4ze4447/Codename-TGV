; cnb_bloader_rm
; > Version 0.0.4 (main.beta.alpha)
; > Author: bl4ze4447

[org 0x7c00]
.BOOTLOADER_PM equ 0x800
.KERNEL_OFFSET equ 0x1000
    
    ; Initialize the segments with 0
    ; since BIOS does not do it for us 
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; BIOS stores the bootdrive in DL
    mov [.BOOTDRIVE], dl            

    ; Setup the stack
    mov bp, 0x7c00                  
    mov sp, bp
    mov ss, ax

    ; Verify the state of A20 Line
    call get_a20_state
    cmp ax, 1
    je .a20_enabled
    
    ; Tries to enable A20 (if it fails, the program hangs)
    call enable_a20
    jmp .a20_enabled
    
    jmp $

.a20_enabled:
    call .load_bootloader2
    call .load_kernel
    call .BOOTLOADER_PM
    
    jmp $

%include "boot/utilities/16bit/a20_line.asm"
%include "boot/utilities/16bit/string.asm"
%include "boot/utilities/16bit/disk.asm"

[bits 16]
; Load the second sector of the bootloader
.load_bootloader2:
    mov bx, .BOOTLOADER_PM  
    mov dh, 1                 
    mov dl, [.BOOTDRIVE]  
    mov cl, 0x02     
    call load_sectors
    ret

[bits 16]
; Load the kernel (3072 bytes is enough)
.load_kernel:
    mov bx, .KERNEL_OFFSET  
    mov dh, 6                 
    mov dl, [.BOOTDRIVE] 
    mov cl, 0x03      
    call load_sectors
    ret

.BOOTDRIVE               db 0

; Fill the rest of the bootloader to fill a sector
times 510-($-$$) db 0
; BIOS looks for these two bytes at the end of a sector 
; to check if its a bootable one
dw 0xaa55