	INCLUDE	"definitions.i"

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

	MOVE.L	#$8000,-(SP)	; 32kb heap reservation for char ram
	JSR	malloc		; D0 will contain address
	LEA	($4,SP),SP	; restore stack
	MOVE.L	D0,-(SP)	; move address of char ram onto stack
	JSR	init_create_character_ram
	LEA	($4,SP),SP	; restore stack

	MOVE.B	#$10,VICV_HOR_BORDER_SIZE
	MOVE.W	#C64_BLACK,VICV_HOR_BORDER_COLOR

	JSR	sids_reset
	JSR	sids_welcome_sound

	JSR	update_exception_vector

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

init_create_character_ram
	; Copy char rom to ram (from 2k to 32k). Expands charset 1 to 16 bit.
	; Scratch register Usage:
	; D0 current_byte, holds a byte from the original rom charset
	; D1 i, counter from 7 to 0 (for 8 bits per byte)
	; A0 must contain *char_ram pointer
	; A1 will contain *char_rom pointer
	MOVEQ	#0,D0			; current_byte = 0;
	MOVEA.L	($4,SP),A0		; get char_ram pointer from stack
	LEA	CHAR_ROM,A1
.1	CMPA.L	#CHAR_ROM+$800,A1	; end of rom?
	BEQ	.5			; return if end of rom is reached
	MOVE.B	(A1)+,D0		; load byte from rom
	MOVEQ	#8,D1			; start counter
.2	BTST	#$7,D0			; leftmost bit turned on?
	BEQ	.3			; no, goto .3
	MOVE.W	#C64_GREY,(A0)+		; yes, make ram pixel grey
	BRA	.4
.3	MOVE.W	#$0000,(A0)+		; no, make ram pixel transparent
.4	LSL.B	#$01,D0			; bitshift original byte 1 pix to left
	SUBQ	#$01,D1			; counter--
	BEQ	.1			; finish byte? Then goto .1
	BRA	.2
.5	RTS
