include config.mk

.PHONY: all image boot loader kernel run debug clean

all: image

image: $(BUILD_DIR)/floppy.img

$(BUILD_DIR)/floppy.img: boot loader kernel
	@python3 scripts/image.py $@

boot:
	@$(MAKE) -C src/boot

loader:
	@$(MAKE) -C src/loader

kernel:
	@$(MAKE) -C src/kernel

run: $(BUILD_DIR)/floppy.img
	@qemu-system-i386 -fda $<

debug: $(BUILD_DIR)/floppy.img
	@bochs -f bochsrc.cfg

clean:
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR)/*