; Simple boot sector that prints "Hello!" to the screen.

[org 0x7C00]
KERNEL_OFFSET equ 0x1000
	mov [BOOT_DRIVE], dl
	
	mov bp, 0x9000 ; Put the stack above us in memory, at address 0x9000.
	mov sp, bp
	
	mov bx, REAL_MODE_MSG
	call print_string
	call load_kernel
	call switch_to_pm
	
	jmp $
	
%include "print_util.asm"
%include "disk_util.asm"
%include "gdt.asm"
%include "print_util_pm.asm"
%include "switch_to_pm.asm"

[bits 16]

load_kernel:
	; Print loading string
	mov bx, KERNEL_LOAD_MSG
	call print_string
	
	; Load the first 15 sectors after the boot sector into memory at KERNEL_OFFSET
	mov bx, KERNEL_OFFSET
	mov dh, 3
	mov dl, [BOOT_DRIVE]
	call disk_load
	
	ret

[bits 32]
BEGIN_PM:
	mov ebx, PROT_MODE_MSG
	call print_string_pm
	call KERNEL_OFFSET
	
	jmp $

; Variables
BOOT_DRIVE: db 0
REAL_MODE_MSG: db "Booted into 16-bit mode...", 0
PROT_MODE_MSG: db "Successfully switched to 32-bit protected mode!", 0
KERNEL_LOAD_MSG: db "Loading kernel into memory...", 0


; Padding/magic
times 510-($-$$) db 0
dw 0xaa55