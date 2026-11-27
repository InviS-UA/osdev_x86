ASMFLAGS += -f elf
CFLAGS16 += -I$(PROJ_DIR)/include -ffreestanding -nostdlib -mcmodel=small
LDFLAGS16 += -nostdlib -Tlinker.ld -Wl,-Map=$(BUILD_DIR)/loader.map

SRC_C=$(wildcard *.c)
SRC_ASM=$(wildcard *.asm)
OBJ_C=$(patsubst %.c, $(BUILD_DIR)/loader/%.o, $(SRC_C))
OBJ_ASM=$(patsubst %.asm, $(BUILD_DIR)/loader/%.o, $(SRC_ASM))

.PHONY: all

all: $(BUILD_DIR)/loader.bin

$(BUILD_DIR)/loader.bin: $(OBJ_ASM) $(OBJ_C)
	@echo "LD " $@
	@$(LD16) $(LDFLAGS16) -o $@ $^ -lgcc

$(BUILD_DIR)/loader/%.o: %.c
	@mkdir -p $(@D)
	@echo "CC " $@
	@$(CC16) $(CFLAGS16) -c -o $@ $<

$(BUILD_DIR)/loader/%.o: %.asm
	@mkdir -p $(@D)
	@echo "ASM" $@
	@$(ASM) $(ASMFLAGS) -o $@ $<