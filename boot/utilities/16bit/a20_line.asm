[bits 16]
; function get_a20_state
; Description: Checks if the A20 Line is enabled by writing different
;           values in memory below 1MB and its warp equivalent above 1MB,
;           after which it compares the values. Different values mean
;           the A20 Line is enabled and no warp is happening. Same
;           values mean the A20 Line is disabled.
;           
; @params_registers         ->  none
; @returns                  ->  (AX=1) if A20 Line is enabled
;                               (AX=0) if A20 Line is disabled
get_a20_state:
    ; Disable the BIOS interrupts and save the segment registers/flags value
    cli 
    pushf           
    push ds
    push es 
    push di
    push si

    ; ES:DI will point to 0000:7DFE, the bootsector identifier precisely
    xor ax, ax          
    mov es, ax  
    mov di, 0x7DFE

    ; DS:SI will point to FFFF:7E0E, its warp equivalent above 1MB
    not ax              
    mov ds, ax
    mov si, 0x7E0E

    ; Assume that the A20 is enabled
    mov ah, 1

    ; Store original values of the segments to restore them after
    ; the function call
    mov al, [es:di]
    mov byte [.BELOW_1MB], al
    mov al, [ds:si]
    mov byte [.ABOVE_1MB], al

    ; Write different values
    mov byte [ds:si], 0xF 
    mov byte [es:di], 0x0  

    ; Get the value stored in DS:SI after the write
    ; and compare it to the one stored in ES:DI
    ; to check if it wrote to the same memory address
    mov al, byte [ds:si]
    cmp al, [es:di]
    jne .a20_cleanup

    ; If we did not jump it means the A20 is not enabled
    ; and our assumption was not right, we must decrease AH
    dec ah

.a20_cleanup:
    ; Restore original values
    mov al, [.BELOW_1MB]
    mov [es:di], al
    mov al, [.ABOVE_1MB]
    mov [ds:si], al

    ; Move the return value from AH into AL
    ; while also clearing previous AL
    shr ax, 8

    pop si
    pop di
    pop es
    pop ds
    popf
    ; Re-enable BIOS interrupts
    sti
    ret

.BELOW_1MB: db 0
.ABOVE_1MB: db 0

; function enable_a20
; Description: Tries to enable the A20 line using various methods such
;           as FAST A20, BIOS Interrupts and the Keyboard Controller one.
;           This function is not a guarantee and it can fail, in such case
;           hanging the boot process with an error message displayed.
;           
; @params_registers         ->  none
; @returns                  ->  none
enable_a20:
    pushf
    pop bx
    clc
    mov ax, 0x2403
    int 0x15
    jc print_a20_disabled
    cmp ah, 0x00
    jne print_a20_disabled

;   Bit(s)  Description     (Table 00462)
;   0      supported on keyboard controller
;   1      supported with bit 1 of I/O port 92h
;   14-2   reserved
;   15     additional data is available (location not yet defined)
    test bx, 0x1
    jz .a20_keyboard

    test bx, 0x2
    jz .a20_fast

    ; Get a20 gate status
    mov ax, 0x2402
    int 0x15
    jc print_a20_disabled
    cmp ah, 0x00
    jne print_a20_disabled

    ; Try to enable a20
    mov ax, 0x2401
    int 0x15
    jc print_a20_disabled
    cmp ah, 0x00
    jne print_a20_disabled

    pop bx
    popf
    ret

; Fast A20 Method
.a20_fast:
    in al, 0x92
    or al, 2
    and al, 0x0FE
    out 0x92, al
    jmp .a20_delayed_check

[bits 32]
.a20_keyboard:
    cli

    ; Disable the keyboard
    call .kyb_out_wait
    mov al, 0xAD
    out 0x64, al

    ; Save output port state
    call .kyb_out_wait
    mov al, 0xD0
    out 0x64, al
    call .kyb_in_wait
    in al, 0x60
    push eax

    ; Change back to write mode
    call .kyb_out_wait
    mov al, 0xD1
    out 0x64, al
    
    ; Write modified port state to enable A20
    call .kyb_out_wait
    pop eax
    or al, 2
    out 0x60, al
    
    ; Enable keyboard
    call .kyb_out_wait
    mov al, 0xAE
    out 0x64, al

    call .kyb_out_wait
    sti

    jmp .a20_delayed_check

.kyb_in_wait:
    in al, 0x64
    test al, 1
    jz .kyb_in_wait
    ret
.kyb_out_wait:
    in al, 0x64
    test al, 2
    jnz .kyb_out_wait
    ret

[bits 16]
.a20_delayed_check:
    mov ax, 5
    call .delay
    call get_a20_state
    cmp ax, 1
    je .done
    jmp print_a20_disabled 

.delay:
    test ax, 0
    jnz .delay
    ret

.done:
    pop bx
    popf
    ret

; function print_a20_disabled
; Description: Prints the associated A20 Disabled error message and hangs
;           the program.
;           
; @params_registers         ->  none
; @returns                  ->  none
print_a20_disabled:
    mov bx, MSG_A20_INACTIVE
    call print_string
    jmp $

MSG_A20_INACTIVE db 'ERR20', 0