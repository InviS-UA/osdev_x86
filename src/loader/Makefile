ASMFLAGS += -f obj
CFLAGS16 += -I$(PROJ_DIR)/include -0 -d3 -s -wx -ms -zl -zq -fr

SRC_C=$(wildcard *.c)
SRC_ASM=$(wildcard *.asm)
OBJ_C=$(patsubst %.c, $(BUILD_DIR)/loader/c/%.obj, $(SRC_C))
OBJ_ASM=$(patsubst %.asm, $(BUILD_DIR)/loader/asm/%.obj, $(SRC_ASM))

.PHONY: all

all: $(BUILD_DIR)/loader.bin

$(BUILD_DIR)/loader.bin: $(OBJ_ASM) $(OBJ_C)
	$(LD16) NAME $(BUILD_DIR)/loader.bin FILE \{ $^ \} OPTION MAP=$(BUILD_DIR)/loader.map @linker.lnk

$(BUILD_DIR)/loader/c/%.obj: %.c
	@mkdir -p $(@D)
	@echo "CC " $@
	@$(CC16) $(CFLAGS16) -fo=$@ $<

$(BUILD_DIR)/loader/asm/%.obj: %.asm
	@mkdir -p $(@D)
	@echo "ASM" $@
	@$(ASM) $(ASMFLAGS) -o $@ $<