ASMFLAGS += -I$(PROJ_DIR)/include -f elf32
CFLAGS += -I$(PROJ_DIR)/include -ffreestanding -nostdlib
LINKFLAGS += -Tlinker.ld -nostdlib

SRC_FILES=$(shell find -L . -type f)
C_FILES=$(filter %.c, $(SRC_FILES))
ASM_FILES=$(filter %.asm, $(SRC_FILES))
OBJ_FILES=$(patsubst %.c, $(BUILD_DIR)/kernel/%.o, $(C_FILES)) \
		  $(patsubst %.asm, $(BUILD_DIR)/kernel/%.o, $(ASM_FILES))

.PHONY: all

all: $(BUILD_DIR)/kernel.sys

$(BUILD_DIR)/kernel.sys: $(OBJ_FILES)
	@echo "LD " $@
	@$(LINK) $(LINKFLAGS) -o $@ $^

$(BUILD_DIR)/kernel/%.o: %.asm
	@mkdir -p $(@D)
	@echo "ASM" $@
	@$(ASM) $(ASMFLAGS) -o $@ $<

$(BUILD_DIR)/kernel/%.o: %.c
	@mkdir -p $(@D)
	@echo "CC " $@
	@$(CC) $(CFLAGS) -c -o $@ $<