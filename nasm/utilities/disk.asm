; load DH sectors to ES:BX from drive DL
disk_load :
    push dx  

    mov ah, 0x02            ; BIOS Read Sector
    mov al, dh              ; DH = num of sectors
    mov ch, 0x00            ; Cylinder 0
    mov dh, 0x00            ; Head 0
    mov cl, 0x02            ; Reading from second sector (omit boot sector)
    
    int 0x13
    jc _disk_error          ; carry flag = error

    pop dx                  ; for dh
    cmp dh, al              ; al = sectors read, dh = sectors expected to be read
    jne _disk_error         ; display error message
    ret

_disk_error :
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

DISK_ERROR_MSG db " Disk read error !" , 0