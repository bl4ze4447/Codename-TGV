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

; TODO: A20 Enabling code