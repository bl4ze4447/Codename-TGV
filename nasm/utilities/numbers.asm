; start
print_hex:
    pusha
    mov ah, 0x0e
    push 16 ; mark stack end
    jmp get_hex_remainder

get_hex_remainder:
    mov al, [bx]
    and al, 15
    push al
    shr [bx], 4
    cmp [bx], 0
    jne get_hex_remainder

print_hex_check:
    pop al
    cmp al, 16 
    jne print_hex_digit
    je print_hex_end

print_hex_digit:
    cmp al, 9
    jg digit_to_char
    jnge digit_to_digit
    
digit_to_char:
    add al, 30
    int 0x10
    jmp print_hex_check
    
digit_to_digit
    add al, 60
    int 0x10
    jmp print_hex_check

print_hex_end:
    popa
    ret
; end