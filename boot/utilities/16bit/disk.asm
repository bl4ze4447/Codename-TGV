[bits 16]
; function load_sectors
; Description: Uses the BIOS interrupt 0x13 with AH=0x02
;           to read a number of sectors from a drive's
;           Cylinder 0, Head 0, ignoring the bootsector
;           
; @params_registers         ->  (ES:BX)     = Buffer Address Pointer
;                           ->  (DL)        = Drive
;                           ->  (DH)        = Number of sectors 
; @returns                  ->  (ES:BX=Sectors read) if function is successful
;                           ->  Hangs if unsuccessful
load_sectors:
    push dx 

    ; Setup parameters
    mov ah, 0x02
    ; Sectors to be read
    mov al, dh  
    ; Cylinder 0       
    mov ch, 0x00
    ; Head 0
    mov dh, 0x00
    ; Jump past the bootsector
    mov cl, 0x02            
    
    ; BIOS Interrupt
    int 0x13

    ; CF is set if function was unsucessful
    jc .sector_load_error

    ; Restore DX to get back the original count of sectors to be read 
    ; and compare it to the actual sectors read
    pop dx
    cmp dh, al              
    jne .sector_load_error
    ret

.sector_load_error:
    mov bx, .SECTOR_LOAD_ERROR
    call print_string
    jmp $

.SECTOR_LOAD_ERROR db "bER1", 0