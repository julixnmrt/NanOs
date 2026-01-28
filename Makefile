# Répertoires
SRC_BOOT=boot
SRC_KERNEL=kernel
BIN=bin

# Fichiers sources
BOOT_SRC=$(SRC_BOOT)/boot.asm
KERNEL_SRC=$(SRC_KERNEL)/kernel.c

# Fichiers binaires intermédiaires
BOOT_BIN=$(BIN)/boot.bin
KERNEL_O=$(BIN)/kernel.o
KERNEL_ELF=$(BIN)/kernel.elf
KERNEL_BIN=$(BIN)/kernel.bin
OS_IMAGE=$(BIN)/os-image.bin

# Cible par défaut
all: $(OS_IMAGE)

# Crée le dossier bin s'il n'existe pas
$(BIN):
	mkdir -p $(BIN)

# Assembleur bootloader
$(BOOT_BIN): $(BOOT_SRC) | $(BIN)
	nasm -f bin $< -o $@

# Compile kernel C
$(KERNEL_O): $(KERNEL_SRC) | $(BIN)
	gcc -m32 -ffreestanding -c $< -o $@

# Link kernel ELF
$(KERNEL_ELF): $(KERNEL_O)
	ld -m elf_i386 -Ttext 0x1000 -o $@ $<

# Convert ELF -> binaire
$(KERNEL_BIN): $(KERNEL_ELF)
	objcopy -O binary $< $@

# Merge bootloader + kernel
$(OS_IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	cat $^ > $@

# Lance QEMU
run: all
	qemu-system-i386 -drive format=raw,file=$(OS_IMAGE)

# Nettoyage
clean:
	rm -rf $(BIN)
