[bits 32]
; VGA memory is located at 0xb8000
VIDEO_MEMORY        equ 0xb8000
; White text on black background     
WHITE_ON_BLACK      equ 0x0f


; function print_string32
; Description: Prints a string using VGA Text Mode by
;           rewriting the VIDEO_MEMORY's char and attribute,
;           making this function usable for debugging only
;           
; @params_registers         ->  (EBX)        = Pointer to string
; @returns                  ->  none
print_string32:
    ; Store original values
    pushf
    push ax
    push edx

    ; Set attribute and the video memory pointer
    mov ah, WHITE_ON_BLACK          
    mov edx, VIDEO_MEMORY           

.print_loop:
    ; Get next character from EBX and check if it's the null terminator
    mov al, [ebx]
    cmp al, 0                        
    jz .cleanup

    ; Write character(al) and attribute(ah) = 2 bytes
    mov [edx], ax                  

    ; Increment the string pointer by one and the memory pointer by two bytes 
    inc ebx                        
    add edx, 2

    jmp .print_loop

.cleanup: 
    pop edx 
    pop ax 
    popf
    ret