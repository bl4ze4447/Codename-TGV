[bits 16]
; function switch_to_pm
; Description: Disables interrupts, loads the GDT Descriptor, sets the
;           Protection Enable bit to 1 and does a far jump to switch the
;           CPU to 32 bit mode
;           
; @params_registers         ->  none
; @returns                  ->  none
switch_to_pm:
    ; Disable BIOS Interrupts and load the GDT Descriptor
    cli                     
    lgdt [gdt_descriptor]   

    ; Set the Protection Enable bit to 1 to make the switch to 32bit mode
    mov eax, cr0            
    or eax, 0x1            
    mov cr0, eax

    ; Do a far jump to flush the cache of pre-feetched instructions
    jmp CODE_SEG:init_pm

[bits 32]
; function init_pm
; Description: Updates the segments and stack pointer and returns to the bootloader
;           where it gives control to the kernel
;           
; @params_registers         ->  none
; @returns                  ->  none
init_pm:
    ; Update the old segments to the new GDT offsets
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax 
    mov fs, ax 
    mov gs, ax 

    ; Update the stack
    mov ebp, 0x90000
    mov esp, ebp 

    ; Go back to bootloader and give control to the kernel
    call switch_to_kernel
    jmp $
    