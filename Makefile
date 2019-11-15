C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}

all: os-image

run: all
	bochs
	
os-image: src/boot/boot_sector.bin kernel.bin
	cat $^ > os-image
	
kernel.bin: src/kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary
	
%.o: %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@
	
%.o: %.asm
	nasm $< -f elf -o $@
	
%.bin: %.asm
	nasm $< -f bin -I $(@D) -o $@
	
clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr src/kernel/*.o src/boot/*.bin src/drivers/*.o
	
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@