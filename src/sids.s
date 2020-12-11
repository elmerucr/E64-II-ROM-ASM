	INCLUDE "definitions.i"

	SECTION	TEXT

sids_reset::
	MOVE.L	#$80,-(SP)
	MOVE.B	#$0,-(SP)
	PEA	SID0_BASE
	JSR	memset
	LEA	($a,SP),SP
	MOVE.B	#$f,SID0_VOLUME
	MOVE.B	#$f,SID1_VOLUME
	RTS

sids_welcome_sound::
	; play a welcome sound on SID0
	LEA	SID0_BASE,A0
	LEA	sids_notes,A1
	MOVE.W	(N_D3_,A1),(A0)		; set frequency of voice 1
	MOVE.B	#%00001001,($5,A0)	; attack and decay of voice 1
	MOVE.W	#$f0f,$02(A0)		; pulse width of voice 1
	MOVE.B	#$ff,SID0_LEFT		; left channel mix
	MOVE.B	#$10,SID0_RGHT		; right channel mix
	MOVE.B	#%01000001,($4,A0)	; pulse (bit 6) and open gate (bit 0)
	; play a welcome sound on SID1
	LEA	SID1_BASE,A0
	LEA	sids_notes,A1
	MOVE.W	(N_A3_,A1),(A0)		; set frequency of voice 1
	MOVE.B	#%00001001,($5,A0)	; attack and decay of voice 1
	MOVE.W	#$f0f,($2,A0)		; pulse width of voice 1
	MOVE.B	#$10,SID1_LEFT		; left channel mix
	MOVE.B	#$ff,SID1_RGHT		; right channel mix
	MOVE.B	#%01000001,($4,A0)	; pulse (bit 6) and open gate (bit 0)
	RTS


	SECTION	RODATA

sids_notes::
	DC.W	$0116,$0127,$0139,$014B,$015F,$0174,$018A,$01A1,$01BA,$01D4,$01F0,$020E	; N_C0_ to N_B0_
	DC.W	$022D,$024E,$0271,$0296,$02BE,$02E7,$0314,$0342,$0374,$03A9,$03E0,$041B	; N_C1_ to N_B1_
	DC.W	$045A,$049C,$04E2,$052D,$057B,$05CF,$0627,$0685,$06E8,$0751,$07C1,$0837	; N_C2_ to N_B2_
	DC.W	$08B4,$0938,$09C4,$0A59,$0AF7,$0B9D,$0C4E,$0D0A,$0DD0,$0EA2,$0F81,$106D	; N_C3_ to N_B3_
	DC.W	$1167,$1270,$1389,$14B2,$15ED,$173B,$189C,$1A13,$1BA0,$1D45,$1F02,$20DA	; N_C4_ to N_B4_
	DC.W	$22CE,$24E0,$2711,$2964,$2BDA,$2E76,$3139,$3426,$3740,$3A89,$3E04,$41B4	; N_C5_ to N_B5_
	DC.W	$459C,$49C0,$4E23,$52C8,$57B4,$5CEB,$6272,$684C,$6E80,$7512,$7C08,$8368	; N_C6_ to N_B6_
	DC.W	$8B39,$9380,$9C45,$A590,$AF68,$B9D6,$C4E3,$D099,$DD00,$EA24,$F810	; N_C7_	to N_A7S
