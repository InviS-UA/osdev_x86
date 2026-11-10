include config.mk

.PHONY: all image boot loader run clean

all: image

image: $(BUILD_DIR)/floppy.img

$(BUILD_DIR)/floppy.img: boot loader
	@python3 scripts/image.py $@

boot:
	@$(MAKE) -C src/boot

loader:
	@$(MAKE) -C src/loader

run: $(BUILD_DIR)/floppy.img
	@qemu-system-i386 -fda $<

clean:
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR)/*