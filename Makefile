CROSS=arm-none-eabi-
CC=$(CROSS)gcc
OBJCPY=$(CROSS)objcopy
CFLAG=-mcpu=cortex-a7 -fpic -ffreestanding -std=gnu99 -O2 -Wall -Wextra

OBJS = boot.o \
	   kernel.o \
	   lib/string.o

RPI2OBJS = device/rpi2/uart.o \
	       device/rpi2/mmu.o  \
	       device/rpi2/timer.o \
	       device/rpi2/interrupts.o

%.o: %.c
	$(CC) $(CFLAG) -c -o $@ $<

%.o: %.S
	$(CC) -mcpu=cortex-a7 -fpic -ffreestanding -c -o $@ $<

RPI2: $(OBJS) $(RPI2OBJS) rpi2.ld
	$(CC) -D RPI2 -T rpi2.ld -o kernel7.elf -ffreestanding -O2 -nostdlib $(OBJS) $(RPI2OBJS)
	$(OBJCPY) kernel7.elf -O binary kernel7.img

qemu: $(OBJS) $(QEMUOBJS)

clean:
	rm -rf *.o
	rm -rf lib/*.o
	rm -rf device/rpi2/*.o
	rm -rf device/rpi2/*.gch
	rm kernel7.elf kernel7.img
