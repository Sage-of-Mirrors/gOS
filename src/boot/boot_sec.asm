; Placeholder asm file for the boot sector.

loop:
	jmp loop           ; Dummy code

times  510-($-$$) db 0 ; NASM macro for filling a file with zeroes

dw 0xaa55              ; The x86 BIOS looks for disk sectors with this value at the end; the BIOS treats sectors that have it as boot sectors.