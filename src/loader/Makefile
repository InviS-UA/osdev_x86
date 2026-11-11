TARGET_ASMFLAGS += -f elf
TARGET_CFLAGS += -ffreestanding -nostdlib
TARGET_LIBS += -lgcc
TARGET_LINKFLAGS += -T linker.ld -nostdlib

SRC_C=$(wildcard *.c)
SRC_ASM=$(wildcard *.asm)
OBJ_C=$(patsubst %.c, $(BUILD_DIR)/loader/%.o, $(SRC_C))
OBJ_ASM=$(patsubst %.asm, $(BUILD_DIR)/loader/%.o, $(SRC_ASM))

.PHONY: all

all: $(BUILD_DIR)/loader.bin

$(BUILD_DIR)/loader.bin: $(OBJ_ASM) $(OBJ_C)
	@$(TARGET_LD) $(TARGET_LINKFLAGS) -Wl,-Map=$(BUILD_DIR)/loader.map -o $@ $^ $(TARGET_LIBS)
	@echo "LD " $@

$(BUILD_DIR)/loader/%.o: %.c
	@mkdir -p $(@D)
	@$(TARGET_CC) $(TARGET_CFLAGS) -c -o $@ $<
	@echo "CC " $@

$(BUILD_DIR)/loader/%.o: %.asm
	@mkdir -p $(@D)
	@$(TARGET_ASM) $(TARGET_ASMFLAGS) -o $@ $<
	@echo "ASM" $@