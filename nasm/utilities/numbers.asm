; start
print_hex:
    pusha
    mov ah, 0x0e
    push 0
    jmp hex_loop

hex_loop:
    shr bx, 4
    mov al, [bx]
    and al, 3
    push al
    cmp [bx], 0
    jne hex_loop

print_hex_loop:
    pop al
    int 0x10
    cmp al, 0
    jne print_hex_loop

print_hex_end:
    popa
    ret
    
; end