AS = vasmm68k_mot
LD = vlink

VPATH = src

OBJECTS = obj/init.o obj/kernel.o obj/vicv.o

ASFLAGS = -align -no-opt -Felf -m68000 -quiet
LDFLAGS = -b rawbin1 -Trom.ld -Mrom.map

CCNATIVE = gcc

all: rom.bin

rom.bin: rom_unpatched.bin mk_rom
	./mk_rom

rom_unpatched.bin: $(OBJECTS) rom.ld
	$(LD) $(LDFLAGS) $(OBJECTS) -o rom_unpatched.bin

obj/%.o : %.s
	$(AS) $(ASFLAGS) $< -o $@ -L $@.list

.PHONY: clean
clean:
	rm rom.bin rom_unpatched.bin rom.map rom.cpp $(OBJECTS)
	cd obj && rm *.list && cd ..

mk_rom: tools/mk_rom.c
	$(CCNATIVE) -o mk_rom tools/mk_rom.c
