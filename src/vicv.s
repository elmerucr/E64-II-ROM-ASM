	INCLUDE	"definitions.i"

	SECTION	TEXT

vicv_vblank_exception_handler::
	MOVEM.L	D0-D1/A0-A1,-(SP)	; save scratch registers

	MOVE.B	#$1,VICV_ISR
	MOVE.B	#$1,VICV_BUFFERSWAP

	MOVE.L	#$80000000,BLITTER_DATA
	MOVE.B	#$1,BLITTER_CONTROL

	; TODO blitter_tty must be removed later on! need function to add operations
	MOVE.L	#blitter_tty,BLITTER_DATA
	MOVE.B	#$1,BLITTER_CONTROL

	MOVEM.L	(SP)+,D0-D1/A0-A1	; restore scratch registers
	RTE

vicv_init::
	MOVE.B	#$10,VICV_HOR_BORDER_SIZE
	MOVE.W	#C64_BLACK,VICV_HOR_BORDER_COLOR
	MOVE.W	#C64_BLUE,BLITTER_CLEAR_COLOR
	RTS

	SECTION	DATA
