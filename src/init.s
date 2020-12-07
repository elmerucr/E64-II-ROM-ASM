	SECTION BSS

aa::	DS.B	1
bb::	DS.W	1


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

.1	BRA	.1

relocate_sections
	; move data section
	MOVE.L	#_DATA_END,D0
	SUB.L	#_DATA_START,D0
	MOVE.L	D0,-(SP)	; push number of bytes
	PEA	_DATA_START	; push source address
	PEA	_RAM_START	; push destination address
	JSR	memcpy
	LEA	($c,SP),SP	; cleanup stack

	; zero bss section
	MOVE.L	#_BSS_END,D0
	SUB.L	#_BSS_START,D0
	MOVE.L	D0,-(SP)	; push number of bytes
	MOVE.B	#$be,-(SP)	; push value
	PEA	_BSS_START
	JSR	memset
	LEA	($a,SP),SP

	RTS

update_vector_table
	RTS
