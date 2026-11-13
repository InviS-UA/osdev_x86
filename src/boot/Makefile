ASMFLAGS += -f bin

.PHONY: all

all: $(BUILD_DIR)/boot.bin

$(BUILD_DIR)/boot.bin: boot.asm
	@mkdir -p $(@D)
	@echo "ASM" $@
	@$(ASM) $(ASMFLAGS) -o $@ $<