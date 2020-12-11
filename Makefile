AS = vasmm68k_mot
LD = vlink

VPATH = src

# The init.o object must be first to ensure proper start of the executable code.
OBJECTS = obj/init.o

# Order of the rest of the objects doesn't matter.
OBJECTS += obj/blitter.o obj/kernel.o obj/sids.o obj/tty.o obj/vicv.o

# Sometimes there seems be strange behaviour related to the -align option. Now
# it seems ok. Another way would be to use the -devpac option?
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
	rm mk_rom rom.bin rom_unpatched.bin rom.map rom.cpp $(OBJECTS)
	cd obj && rm *.list && cd ..

mk_rom: tools/mk_rom.c
	$(CCNATIVE) -o mk_rom tools/mk_rom.c
