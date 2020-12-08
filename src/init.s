	INCLUDE	"definitions.inc"

	SECTION	DATA

onzin_info
	DC.L    $deadbeef
	DC.L	$b00b1e22

	SECTION TEXT
	DC.L	$00100000	; initial SSP
	DC.L	init_kernel	; initial PC

init_kernel
	MOVE.W	#$2700,SR
	JSR	init_relocate_sections
	JSR	init_update_vector_table
	JSR	init_heap_pointers

	MOVE.B	#$10,VICV_HOR_BORDER_SIZE
	MOVE.W	#C64_BLACK,VICV_HOR_BORDER_COLOR

	JSR	sids_reset
	JSR	sids_welcome_sound

.1	BRA	.1

init_relocate_sections
	; move data section
	MOVE.L	#_DATA_END,D0
	SUB.L	#_DATA_START,D0
	MOVE.L	D0,-(SP)	; push number of bytes
	PEA	_DATA_START	; push source address
	PEA	_RAM_START	; push destination address
	JSR	memcpy
	LEA	($c,SP),SP	; clean up stack

	; zero bss section
	MOVE.L	#_BSS_END,D0
	SUB.L	#_BSS_START,D0
	MOVE.L	D0,-(SP)	; push number of bytes
	MOVE.B	#$00,-(SP)	; push the clear value
	PEA	_BSS_START	; push address
	JSR	memset
	LEA	($a,SP),SP	; clean up stack

	RTS

init_update_vector_table
	RTS

init_heap_pointers
	MOVE.L	#_BSS_END,heap_start
	MOVE.L	#_BSS_END,heap_end
	RTS

; pseudo declaration:
; void init_copy_...(u8 *rom, u8 *ram); ==> Need malloc to work
init_copy_char_rom_to_char_ram
	; Copy char rom to ram (go from 2k to 32k)
	; Note: this is a very special copy routine
	; that expands a charset from 1 bit into 16 bit
	; format.
	;
	;	Register Usage
	;
	;	D0	current_byte, holds a byte from the original rom charset
	;	D1	i, counter from 7 to 0 (8 bits per byte have to be processed)
	;	A0	*char_ram, pointer
	;	A1	*char_rom, pointer
	;
	MOVEM.L	D0-D1/A0-A1,-(SP)

	MOVEQ	#0,D0			;    current_byte = 0;
	;LEA	CHAR_RAM,A0		;    char_ram = CHAR_RAM;
	LEA	CHAR_ROM,A1		;    char_rom = CHAR_ROM;

.1	CMPA.L	#CHAR_ROM+$800,A1	;    while(char_ram != CHAR_ROM+$800)
	BEQ	.5			;    {   //	branch to end of compound statement
					;        // load a byte from charset and incr pntr
	MOVE.B	(A1)+,D0		;        current_byte = char_rom++;
	MOVEQ	#8,D1			;        i = 8;
.2	BTST	#$7,D0
	BEQ	.3			;    bit 7 not set
	MOVE.W	#C64_GREY,(A0)+		;    bit 7 is set, so set color
	BRA	.4
.3	MOVE.W	#$0000,(A0)+		;    bit 7 not set, make empty
.4	LSL.B	#$01,D0			;    move all the bits one place to the left
	SUBQ	#$01,D1			;    i = i - 1;
	BEQ	.1			;    did i reach zero? goto .1
	BRA	.2
					;    }
.5	MOVEM.L	(SP)+,D0-D1/A0-A1
	RTS