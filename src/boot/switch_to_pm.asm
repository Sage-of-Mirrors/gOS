[bits 16]

switch_to_pm:
	cli ; Disable interrupts
	lgdt [gdt_descriptor] ; Upload GDT to the CPU
	
	; Set bit 0 of register CR0. This switches us into 32-bit mode.
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	
	jmp CODE_SEG:init_pm ; Perform a far jump to force the CPU to flush its cache. Far jumps are preceded by the segment index.
	
[bits 32]

init_pm:
	; Update the segment registers with our new 32-bit addresses.
	mov ax, DATA_SEG
	mov ds, ax ; Data segment
	mov ss, ax ; Stack segment
	mov es, ax ; User segment register e, no defined use
	mov fs, ax ; User segment register f, no defined use
	mov gs, ax ; User segment register g, no defined use
	
	mov ebp, 0x90000
	mov esp, ebp
	
	call BEGIN_PM