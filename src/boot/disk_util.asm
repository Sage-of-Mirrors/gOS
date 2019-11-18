disk_load:
	push dx ; This contains the number of sectors we wanted to read. Push it to the stack so we can grab it later.
	
	mov ah, 0x02 ; Tells the BIOS to run the read sector function.
	mov al, dh   ; Tells the BIOS how many sectors to read.
	mov ch, 0x00 ; Read from Cylinder 0...
	mov dh, 0x00 ; Read from Head 0...
	mov cl, 0x02 ; Starting at the second sector. (Skips the boot sector)
	
	int 0x13     ; Generate BIOS interrupt
	
	jc disk_read_error ; Display an error message if the carry flag is set. (generic disk read failure)
	
	pop dx ; Grab the number of sectors we actually wanted to read from the stack.
	cmp dh, al ; Compare the desired number of sectors to the actual number of sectors read.
	jne disk_sector_error ; Display an error message if the desired sector and the read sector counts do no match. (sector read error)
	ret
	
disk_read_error:
	mov bx, DISK_READ_ERROR_MSG
	call print_string
	jmp $
	
disk_sector_error:
	mov bx, DISK_SECTOR_ERROR_MSG
	call print_string
	jmp $

; Variables
DISK_READ_ERROR_MSG: db "Disk error: The disk could not be read.", 0
DISK_SECTOR_ERROR_MSG: db "Disk error: Could not read all sectors.", 0