gdt_start:

	gdt_null: ; This is the null descriptor. Required for error handling.
		dd 0x0
		dd 0x0
	
	gdt_code: ; Simple code segment
		; base = 0x0, limit (size) = 0xFFFFF
		; 1st flags: present = 1, privilege = 00, type = 1 -> 1001b
		; type flags: code = 1, conforming = 0, readable = 1, accessed = 0 -> 1010b
		; 2nd flags: granularity = 1, 32-bit = 1, 64-bit = 0, AVL = 0 -> 1100b
		dw 0xffff    ; Limit (bits 0-15)
		dw 0x0       ; Base (bits 0-15)
		db 0x0       ; Base (bits 16-23)
		db 10011010b ; 1st flags (1001b) + type flags (1010b)
		db 11001111b ; 2nd flags (1100) + limit (bits 16-19, 1111b)
		db 0x0       ; Base (bits 24-31)
		
	gdt_data: ; Simple data segment
		; base = 0x0, limit (size) = 0xFFFFF
		; 1st flags: present = 1, privilege = 00, type = 1 -> 1001b
		; type flags: code = 0, conforming = 0, readable = 1, accessed = 0 -> 0010b
		; 2nd flags: granularity = 1, 32-bit = 1, 64-bit = 0, AVL = 0 -> 1100b
		dw 0xffff    ; Limit (bits 0-15)
		dw 0x0       ; Base (bits 0-15)
		db 0x0       ; Base (bits 16-23)
		db 10010010b ; 1st flags (1001b) + type flags (0010b)
		db 11001111b ; 2nd flags (1100) + limit (bits 16-19, 1111b)
		db 0x0       ; Base (bits 24-31)
		
gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start
	
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start