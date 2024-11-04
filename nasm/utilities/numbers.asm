; start
print_hex:
    pusha
    mov ah, 5 ; end of HEX_OUT
    jmp get_hex_remainder

get_hex_remainder:
    ; push remainder
    mov al, [dx]
    and al, 0x0F
    call convert_to_ascii
    mov [HEX_OUT+ah], al
    sub ah, 1
    
    ; divide by 16
    mov al, [dx]
    shr al, 4
    mov [dx], al
    ; compare
    cmp [dx], 0
    jne get_hex_remainder
    je print_hex_end

convert_to_ascii:
    cmp al, 9
    jg digit_to_char ; >9
    add al, 48
    ret
    
digit_to_char:
    add al, 55
    ret

print_hex_end:
    mov bx, HEX_OUT
    call print_string
    mov ah, 2
    call clear_buffer
    popa
    ret
; end

clear_buffer:
    mov [HEX_OUT+ah], '0'
    inc ah
    cmp ah, 6
    jle clear_buffer
    ret
   

HEX_OUT:
    db '0x0000', 0