; load DH sectors to ES:BX from drive DL
disk_load :
    pusha 

    push dx  
    mov ah, 0x2             ; BIOS Read Sector
    mov al, dh              ; DH = num of sectors
    mov ch, 0x0             ; Cylinder 0
    mov dh, 0x0             ; Head 0
    mov cl, 0x2             ; Reading from second sector (omit boot sector)
    int 0x13

    pop dx                  ; for dh
    jc _disk_error          ; carry flag = error
    cmp dh, al              ; al = sectors read, dh = sectors expected to be read
    jne disk_error ; display error message
    ret

_disk_error :
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

DISK_ERROR_MSG db " Disk read error !" , 0