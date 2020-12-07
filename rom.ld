_ROM_START	= 0x00fc0000;
_RAM_START	= 0x00000400;

SECTIONS {
	. = _ROM_START;

	TEXT : {
		_TEXT_START = .;
		*(TEXT);
		*(RODATA);
		_TEXT_END = .;
	}

	DATA _RAM_START : AT(ADDR(TEXT) + SIZEOF(TEXT)) {
		_DATA_START = (. - _RAM_START) + _TEXT_END;
		*(DATA);
		_DATA_END = (. - _RAM_START) + _TEXT_END;
	}

	BSS ALIGN(0x2) : {
		_BSS_START = .;
		*(COMMON);
		*(BSS);
		_BSS_END = .;
	}
}
