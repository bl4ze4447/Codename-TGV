; start
print_string:
    pusha 
    mov ah, 0x0e ; bios teletype mode
    jmp _print_loop

_print_loop:
    mov al, [bx]
    cmp al, 0
    je _print_end
    int 0x10
    inc bx
    jmp _print_loop

_print_end:
    popa
    ret
; end

; start
new_line:
    pusha
    ; print newline
    mov al, 10 
    mov ah, 0x0e
    int 0x10
    ; get current row and column
    mov ah, 0x03
    mov bh, 0
    int 0x10
    ; set cursor position
    mov ah, 0x02
    mov dl, 0
    int 0x10
    popa
    ret
; end