[bits 16]
switch_to_pm:
    cli                     ; disable interrupts until we set-up the protected mode interrupt vector
    lgdt [gdt_descriptor]   ; load GDT
    mov eax, cr0            ; cannot modify cr0 directly
    or eax, 0x1             ; set first bit to 1 to make the switch
    mov cr0, eax

    jmp CODE_SEG:init_pm    ; far jump (to new segment) to flush the cache of pre-fetched and real-mode decoded instructions

[bits 32]
init_pm:

    mov ax, DATA_SEG        ; update old segments
    mov ds, ax
    mov ss, ax
    mov es, ax 
    mov fs, ax 
    mov gs, ax 

    mov ebp, 0x90000        ; update stack position at top of free space
    mov esp, ebp 

    call BEGIN_PM