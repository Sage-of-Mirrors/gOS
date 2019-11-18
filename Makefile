C_SOURCES = $(wildcard src/kernel/*.c src/driver/*.c)
HEADERS = $(wildcard src/kernel/*.h src/driver/*.h)

OBJ = ${C_SOURCES:.c=.o}

all: os-image

run: all
	bochs
	
os-image: src/boot/boot_sector.bin kernel.bin
	cat $^ > os-image
	
kernel.bin: src/kernel/kernel_entry.o ${OBJ}
	ld -T NUL -o ./src/kernel/kernel.tmp -Ttext 0x1000 $^
	objcopy -O binary -j .text src/kernel/kernel.tmp kernel.bin
	
%.o: %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@
	
%.o: %.asm
	nasm $< -f elf -o $@
	
%.bin: %.asm
	nasm $< -f bin -I $(@D) -o $@
	
clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr src/kernel/*.o src/kernel/*.tmp src/boot/*.bin src/drivers/*.o
	
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@