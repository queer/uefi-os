EFI_INCLUDES = -I/usr/include/efi -I/usr/include/efi/x86_64 -I/usr/include/efi/protocol
CFLAGS = 
LDFLAGS = 
OBJCOPYFLAGS = 

CFLAGS += -fno-stack-protector -fpic -fshort-wchar -mno-red-zone -DHAVE_USE_MS_ABI -ffreestanding -c
LDFLAGS += -nostdlib -znocombreloc -T /usr/lib/elf_x86_64_efi.lds -shared -Bsymbolic -L /usr/lib /usr/lib/crt0-efi-x86_64.o -lefi -lgnuefi
OBJCOPYFLAGS += -j .text -j .sdata -j .data -j .dynamic -j .dynsym  -j .rel -j .rela -j .reloc --target=efi-app-x86_64

KERNEL = main.c
OBJECT = main.o
SHARED_OBJECT = main.so
EFI = main.efi
IMG = uefi.img
CC = gcc

all: clean
	$(CC) $(EFI_INCLUDES) $(CFLAGS) src/$(KERNEL) -o $(OBJECT)
	$(CC) $(EFI_INCLUDES) $(CFLAGS) src/data.c -o data.o
	$(CC) -nostdlib -Wl,-dll -shared -e efi_main -o $(EFI) $(OBJECT) data.o -lgcc
	dd if=/dev/zero of=$(IMG) bs=1k count=1440
	mformat -i $(IMG) -f 1440 ::
	mmd -i $(IMG) ::/EFI
	mmd -i $(IMG) ::/EFI/BOOT
	mcopy -i $(IMG) $(EFI) ::/EFI/BOOT



#	ld $(LDFLAGS) $(OBJECT) -o $(SHARED_OBJECT)
#	objcopy $(OBJCOPYFLAGS) $(SHARED_OBJECT) $(EFI)
#	dd if=/dev/zero of=$(IMG) bs=512 count=93750
#	parted $(IMG) -s -a minimal mklabel gpt
#	parted $(IMG) -s -a minimal mkpart EFI FAT16 2048s 93716s
#	parted $(IMG) -s -a minimal toggle 1 boot
#	dd if=/dev/zero of=/tmp/part.img bs=512 count=91669
#	mformat -i /tmp/part.img -h 32 -t 32 -n 64 -c 1
#	mmd -i /tmp/part.img ::/EFI
#	mmd -i /tmp/part.img ::/EFI/BOOT
#	mcopy -i /tmp/part.img $(EFI) ::/EFI/BOOT
#	dd if=/tmp/part.img of=$(IMG) bs=512 count=91669 seek=2048 conv=notrunc

clean:
	rm -f *.o *.so *.efi *.img

