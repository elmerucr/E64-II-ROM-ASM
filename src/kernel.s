	GLOBAL	memcpy
	GLOBAL	memset


	SECTION	TEXT

memcpy
	MOVEA.L	($4,SP),A1	; dest
	MOVEA.L	($8,SP),A0	; src
	MOVE.L	($c,SP),D0	; no of bytes
.1	MOVE.B	(A0)+,(A1)+
	SUBQ	#$1,D0
	BNE	.1
	RTS

;u8 *memcpy(u8 *dest, const u8 *src, size_t count)
;{
;	for (u32 i=0; i<count; i++)
;		dest[i] = src[i];
;	return dest;
;}

memset
	MOVEA.L	($4,SP),A0	; destination
	MOVE.B	($8,SP),D0	; value
	MOVE.L	($a,SP),D1	; no of bytes
.1	MOVE.B	D0,(A0)+
	SUBQ	#$1,D1
	BNE	.1
	RTS

;u8 *memset(u8 *dest, u8 val, size_t count)
;{
;	for (u32 i=0; i<count; i++)
;		dest[i] = val;
;	return dest;
;}