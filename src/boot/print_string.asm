; Prints a null-terminated string to the screen.
print_string:
	pusha ; Store register state to the stack.
	
	string_iterate:
		mov cx, [bx] ; Move the value at the pointer in register B to register C.
		cmp cl, 0    ; Compare the lower 8 bits of register C to 0. The lower 8 bits contain the character we're going to print.
		je string_finish    ; If the lower 8 bits of register C == 0, jump to finish.
		
		mov al, cl   ; Move the lower 8 bits of register C to the lower 8 bits of register A.
		mov ah, 0x0e ; Move the value 0x0e into the upper 8 bits of register A. This tells the BIOS interrupt to print in tele-type mode.
		int 0x10     ; Cause interrupt 0x10 to print to the screen.
		
		add bx, 1    ; Increment the pointer in register B by 1. NOTE: this moves it forward one word, which is 16 bits, not one byte. So "add bx, 1" actually adds 2 to the pointer.
		jmp string_iterate  ; Return to the start of the loop.
	
	string_finish:
		popa  ; Restore register state from the stack.
		ret   ; Return to caller.
		
; Prints out a hex code.
print_hex:
	pusha ; Store register state to the stack.
	
	mov bx, HEX_OUT ; Load the address of our template hex string to register B.
	add bx, 5       ; Move our address pointer to the last character.
	mov ax, 3       ; Initialize our loop counter.
	
	hex_iterate:
		mov cx, dx     ; Copy our input number to register C.
		and cx, 0x000F ; AND our input number to get a nybble.
		cmp cx, 9      ; compare this nybble to 9.
		jle hex_number_add ; If the nybble <= 9, then we treat it as a number, adding 0x30 to it.
		jmp hex_char_add   ; If the nybble > 9, then we treat it as a letter, subtracting 0xA and adding 0x41 to it.
		
		hex_number_add:
			add cx, 0x0030
			jmp hex_continue
		hex_char_add:
			sub cx, 0xA
			add cx, 0x0041
			jmp hex_continue
		
	hex_continue:
		mov byte [bx], cl ; Set the byte at the address in register B to our new character.
		
		shr dx, 4 ; Shift our input number right by 4 bits to get the next nybble.
		sub bx, 1 ; Move back to the next character in our template string.
		
		cmp ax, 0 ; Compare register A to 0.
		je hex_print ; If register A == 0, then our loop is done and we skip to printing the string.
		
		sub ax, 1 ; If register A != 0, we subtract 1 from it and jump back up to our loop.
		jmp hex_iterate
	
	hex_print:
		mov bx, HEX_OUT ; Move the proper address to register B.
		call print_string
	
	hex_finish:
		popa ; Restore register state from the stack.
		ret ; Return to caller.