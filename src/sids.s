	INCLUDE "definitions.inc"

	SECTION	TEXT

sids_reset::
	MOVE.L	#$80,-(SP)
	MOVE.B	#$0,-(SP)
	PEA	SID0_BASE
	JSR	memset
	LEA	($a,SP),SP
	RTS
