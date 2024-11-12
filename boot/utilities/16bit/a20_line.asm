[bits 16]
; bootsector 0xAA55 located at 0000:7DFE
is_a20_enabled:
    pushf           
    push ds
    push es 
    push di
    push si
    cli 

    ; ds:si 0x0000:0x0500
    xor ax, ax          
    mov ds, ax  
    mov si, 0x0500

    ; es:di 0xFFFF:0x0510
    not ax              
    mov es, ax
    mov di, 0x0510

    ; save values on ds:si
    mov al, [ds:si]
    mov byte [a20_below], al
    mov al, [es:di]
    mov byte [a20_above], al

    mov ah, 1
    mov byte [ds:si], 1 ; [0x0000:0x0500]
    mov byte [es:di], 0 ; [0xFFFF:0x0510]

    mov al, byte [ds:si]
    cmp al, [es:di]
    mov ah, 1
    jne _a20_enabled
    dec ah

_a20_enabled:
    mov al, [a20_below]
    mov [ds:si], al
    mov al, [a20_above]
    mov [es:di], al
    shr ax, 8
    sti
    pop ds
    pop es
    pop di
    pop si
    popf
    ret

a20_below: db 0
a20_above db 0
