[bits 32]
VIDEO_MEMORY        equ 0xb8000     ; start of vga mem address
WHITE_ON_BLACK      equ 0x0f        ; white text, black background

print_string32:
    mov ah, WHITE_ON_BLACK          ; set attribute
    mov edx, VIDEO_MEMORY           ; set memory offset
    pusha

_print_string32_loop:
    mov al, [ebx]

    cmp al, 0                       ; is it end of string
    je _print_string32_done

    mov [edx], ax                   ; write character (1 byte char + 1 byte attribute)
    inc ebx                         ; increment string pointer
    add edx, 2                      ; increase by 2 (char + attribute)

    jmp _print_string32_loop

_print_string32_done: 
    popa 
    ret