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
	JSR	relocate_sections
	JSR	update_vector_table

	MOVE.B	#$10,VICV_HOR_BORDER_SIZE
	MOVE.W	#C64_BLUE,VICV_HOR_BORDER_COLOR

	JSR	sids_reset

.1	BRA	.1

relocate_sections
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

update_vector_table
	RTS
