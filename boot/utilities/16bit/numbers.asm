print_hex:
    mov cx, 5
    pusha 

_generate_hex:
    mov ax, dx 
    and ax, 0x0F            ; get remainder 
    shr dx, 4               ; divide by 16

    mov bx, HEX_OUT         ; move to start of string
    add bx, cx

    call _convert_to_ascii  ; get value to add to bx
    add [bx], ax

    cmp cx, 2               ; sanity check for me
    je _print_hex_end

    dec cx

    cmp dx, 0               ; no more remainders
    jne _generate_hex

_print_hex_end:
    mov bx, HEX_OUT         ; go back to beggining of string
    call print_string 
    mov cx, 2
    call _clear_buffer
    popa
    ret

_clear_buffer:
    mov bx, HEX_OUT
    add bx, cx
    mov byte [bx], '0'
    inc cx 
    cmp cx, 6
    jne _clear_buffer
    ret 

_convert_to_ascii:
    cmp ax, 0xA
    jge _digit_to_hex_char
    ret 

_digit_to_hex_char:
    add ax, 0x7             ; '0' = 48 in ascii + remainder (0xA for example) = 58; 'A' in ascii = 65
    ret

HEX_OUT db '0x0000', 0