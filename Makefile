ROOT_DIR= .
LINK_DIR= $(ROOT_DIR)/link
LINK_FILE= $(LINK_DIR)/Linkerfile.ld
C_INCLUDE_DIR= $(ROOT_DIR)/include/c

CC= gcc
CFLAGS= -m32 -c -I$(C_INCLUDE_DIR) 
LD= ld
LDFLAGS= -m elf_i386 -T $(LINK_FILE)
ASM= nasm
ASMFLAGS= -f elf32
COPY= cp
GRUB= grub-mkrescue
GRUBFLAGS=
QEMU= qemu-system-x86_64
QEMUFLAGS= -kernel


SRC_DIR= $(ROOT_DIR)/src
OUTPUT_DIR= $(ROOT_DIR)/output
OBJ_DIR= $(ROOT_DIR)/obj

C_SRC_DIR= $(SRC_DIR)/c
ASM_SRC_DIR= $(SRC_DIR)/asm
C_OBJ_DIR= $(OBJ_DIR)/c
ASM_OBJ_DIR= $(OBJ_DIR)/asm

C_SRC_FILES= $(shell find $(C_SRC_DIR) -type f -name *.c)  
C_OBJ_FILES= $(patsubst $(C_SRC_DIR)/%.c, $(C_OBJ_DIR)/%.o, $(C_SRC_FILES)) 

ASM_SRC_FILES= $(shell find $(ASM_SRC_DIR) -type f -name *.asm) 
ASM_OBJ_FILES= $(patsubst $(ASM_SRC_DIR)/%.asm, $(ASM_OBJ_DIR)/%.o, $(ASM_SRC_FILES)) 


OUTPUT_FILE_NAME= kernel.bin

OUTPUT_FILE_PATH= $(OUTPUT_DIR)/$(OUTPUT_FILE_NAME)

ISO_FILE= $(OUTPUT_DIR)/kernel.iso

ISO_DIR= $(ROOT_DIR)/ISO

.PHONY: all buildiso clean cleanobj cleaniso rebuild run cleanall

all: $(OUTPUT_FILE_PATH)
	@echo all build !


$(OUTPUT_FILE_PATH): $(C_OBJ_FILES) $(ASM_OBJ_FILES)	
	mkdir -p $(OUTPUT_DIR)
	$(LD) $(LDFLAGS) -o $(OUTPUT_FILE_PATH) $(C_OBJ_FILES) $(ASM_OBJ_FILES)


$(C_OBJ_FILES): $(C_OBJ_DIR)/%.o: $(C_SRC_DIR)/%.c
	mkdir -p $(OBJ_DIR)
	mkdir -p $(C_OBJ_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(ASM_OBJ_FILES): $(ASM_OBJ_DIR)/%.o: $(ASM_SRC_DIR)/%.asm
	mkdir -p $(OBJ_DIR)
	mkdir -p $(ASM_OBJ_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@

clean: cleanobj
	rm -r -f $(OUTPUT_DIR)

cleanobj:
	rm -r -f $(OBJ_DIR)

cleaniso:
	rm -r -f $(ISO_DIR)

buildiso: all
	$(COPY) $(OUTPUT_FILE_PATH) $(ISO_DIR)/boot/$(OUTPUT_FILE_NAME)
	$(GRUB) $(GRUBFLAGS) -o $(ISO_FILE) $(ISO_DIR)

rebuild: clean all

run: all
	$(QEMU) $(QEMUFLAGS) $(OUTPUT_FILE_PATH)

cleanall: cleaniso clean
