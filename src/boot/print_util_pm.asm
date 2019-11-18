[bits 32]
; Constants
VRAM equ 0xB8000

print_string_pm:
	pusha
	mov edx, VRAM ; This is the location of video memory, which is in text mode by default.
	
	print_string_pm_loop:
		mov al, [ebx] ; Store character to al
		mov ah, 0x0f  ; Store attributes to ah (0x0f is white foreground, black background)
		
		cmp al, 0 ; Check if we reached \0
		je print_string_pm_finish
		
		mov [edx], ax ; Copy the character and format bytes to video memory
		
		add ebx, 1 ; Increment to next character in the string
		add edx, 2 ; Increment to next character (char byte + format byte) in video memory
		
		jmp print_string_pm_loop
	
	print_string_pm_finish:
		popa
		ret