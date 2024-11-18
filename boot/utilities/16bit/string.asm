[bits 16]
; function print_string
; Description: Uses the BIOS interrupt 0x10 with AH=0x0E to print a string
;           
; @params_registers         ->  (BX)        = Pointer to string
; @returns                  ->  none
print_string:
    ; Save old values for restoration later on
    pushf 
    push ax
    push bx

    ; Set BIOS interrupt 0x10 to Tele-Type Mode
    mov ah, 0x0e

.print_loop:
    ; Get current character from BX
    mov al, [bx]
    
    ; Check if it's the null terminator and jump accordingly
    cmp al, 0
    jz .print_end

    ; Print the character
    int 0x10

    ; Increment the string pointer
    inc bx

    ; Do the same for the next character
    jmp .print_loop

; Cleanup
.print_end:
    pop bx
    pop ax
    popf
    ret

; function new_line
; Description: Uses the BIOS Interrupt 0x10 with AH=0x0e,
;           0x03 and 0x02 to modify the cursor position
;           
; @params_registers         ->  none
; @returns                  ->  none
new_line:
    ; Store original values
    push ax
    push bx

    ; Print a newline
    mov al, 10 
    mov ah, 0x0e
    int 0x10

    ; Get the cursor position
    mov ah, 0x03
    mov bh, 0
    int 0x10

    ; Update the cursor position to the start of the newline
    mov ah, 0x02
    mov dl, 0
    int 0x10

    ; Cleanup
    pop bx
    pop ax
    ret

; function print_line
; Description: Uses the defined print_string and new_line function
;           to print a string and a newline
;           
; @params_registers         ->  (BX)        = Pointer to string
; @returns                  ->  none
print_line:
    call print_string
    call new_line
    ret