	INCLUDE	"definitions.i"

	SECTION DATA

blitter_tty::
	DC.B	%00001010	; flags_0
	DC.B	%00000000	; flags_1
	DC.B	%01010110	; size
	DC.B	%00000000	; unused
	DC.W	$00		; x
	DC.W	$10		; y
	DC.W	C64_LIGHTBLUE	; foreground color
	DC.W	$0		; background color
	DC.L	$0		; pixel data
	DC.L	$0		; tiles
	DC.L	$0		; tiles color
	DC.L	$0		; tiles backgr color
	DC.L	$0		; user data


	SECTION	TEXT

blitter_init::
	LEA	blitter_tty,A0
	MOVE.L	char_ram,(BLIT_PIXEL_DATA,A0)

	RTS
