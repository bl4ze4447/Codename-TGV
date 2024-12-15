[bits 16]
; function print_hex
; Description: Uses the defined print_string function in 16bit/string.asm
;           to convert and print a decimal number to hexadecimal in the
;           0000h format
;           
; @params_registers         ->  (DX)        = Decimal number
; @returns                  ->  none
print_hex:
    ; Store initial values for restoration later
    pushf 
    push ax
    push bx
    ; Mark the start of our stack with the value 0xFFFF
    xor ax, ax 
    not ax
    push ax

.hex_loop:
    ; Get number from DX
    mov ax, dx
    ; Get the remainder of diving by 16
    and ax, 0x0F
    ; Store it in the stack
    push ax

    ; Divide DX by 16
    shr dx, 4
    
    ; Check if there are any remainders left
    cmp dx, 0
    jnz hex_loop

.hex_out:
    ; Get remainder from stack and check if it's the set start of our stack
    pop ax
    cmp ax, 0xFFFF
    jz .cleanup

    ; Check if it's a number or a char
    cmp ax, 10
    jl .is_number
    add byte ax, 'A'

; Print the digit
.out_char:
    mov bx, ax
    call print_string
    jmp .hex_out

; Cleanup everything
.cleanup
    mov byte bx, 'h'
    call print_string 

    pop bx
    pop ax
    popf
    ret

.is_number:
    add byte ax, '0'
    jmp .out_char