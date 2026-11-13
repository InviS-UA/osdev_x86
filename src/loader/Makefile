ASMFLAGS += -I$(PROJ_DIR)/include -f bin

.PHONY: all

all: $(BUILD_DIR)/loader.bin

$(BUILD_DIR)/loader.bin: loader.asm
	@mkdir -p $(@D)
	@echo "ASM" $@
	@$(ASM) $(ASMFLAGS) -o $@ $<