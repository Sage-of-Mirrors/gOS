; Simple boot sector that prints "Hello!" to the screen.

[org 0x7c00]

	mov bx, HELLO_MSG
	call print_string
	
	mov bx, GOODBYE_MSG
	call print_string
	
	mov dx, 0xfffe
	call print_hex
	
	mov dx, 0xabcd
	call print_hex
	
	mov dx, 0x012e
	call print_hex
	
	nop
	jmp $
	
%include "print_string.asm"

;data
HELLO_MSG:
	db 'Hello, world!', 0x0D, 0x0A, 0x00

GOODBYE_MSG:
	db 'Goodbye!', 0x0D, 0x0A, 0x00
	
HEX_OUT:
	db '0x0000', 0x0D, 0x0A, 0x00

; Padding/magic
times 510-($-$$) db 0
dw 0xaa55