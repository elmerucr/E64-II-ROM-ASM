# E64-II-ROM
![E64](./docs/E64-II_icon.png)
## Introduction
[E64-II](https://github.com/elmerucr/E64-II) is a virtual computer system that runs on macOS and linux. It's mainly inspired by the Commodore 64 but implements significant parts of Amiga 500 and Atari ST technology as well. Without any form of operating system inside this virtual machine, it wouldn't do much and the software in this repository forms the ROM & Kernel of E64-II.
## Building
Make sure the `vasmm68k_mot` assembler and the `vlink` linker are available from the command line. Building instructions for the assembler can be found [here](http://sun.hasenbraten.de/vasm/index.php?view=compile). The final products after running `make` will be a `rom.bin` file (64kb) and a `rom.cpp` source file. To use the `rom.bin` instead of the standard rom delivered with `E64-II`, copy it to the `$HOME/.E64-II/` settings directory.
## Links
* [E64-II](https://github.com/elmerucr/E64-II) - A virtual computer system that runs on macOS and Linux.
* [OSDev.org](https://wiki.osdev.org/Main_Page) - Website about the creation of operating systems.
* [vasm assembler](http://sun.hasenbraten.de/vasm/) - A portable and retargetable assembler.
* [vlink linker](http://sun.hasenbraten.de/vlink/) - A portable linker for multiple file formats.
