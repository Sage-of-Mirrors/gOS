; Simple boot sector that prints "Hello!" to the screen.

[org 0x7C00]

	mov bp, 0x9000 ; Put the stack above us in memory, at address 0x9000.
	mov sp, bp
	
	mov bx, REAL_MODE_MSG
	call print_string
	call print_newline
	
	call switch_to_pm
	
	jmp $
	
%include "print_util.asm"
%include "gdt.asm"
%include "print_util_pm.asm"
%include "switch_to_pm.asm"

[bits 32]
BEGIN_PM:
	mov ebx, PROT_MODE_MSG
	call print_string_pm
	
	jmp $

REAL_MODE_MSG: db "Booted into 16-bit mode...", 0
PROT_MODE_MSG: db "Successfully switched to 32-bit protected mode!", 0

; Padding/magic
times 510-($-$$) db 0
dw 0xaa55