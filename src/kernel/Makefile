ASMFLAGS += -I$(PROJ_DIR)/include -f bin

.PHONY: all

all: $(BUILD_DIR)/kernel.sys

$(BUILD_DIR)/kernel.sys: kernel.asm
	@mkdir -p $(@D)
	@echo "ASM" $@
	@$(ASM) $(ASMFLAGS) -o $@ $<