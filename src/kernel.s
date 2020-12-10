	SECTION	BSS

heap_start::	DS.L	1
heap_end::	DS.L	1


	SECTION	TEXT

; void *malloc(size_t chunk);
malloc::
	MOVE.L	($4,SP),D1	; load chunk size parameter from stack
	BTST.L	#$0,D1		; test bit zero
	BEQ	.1
	ADDQ	#$1,D1		; add one for word alignment
.1	MOVE.L	heap_end,D0	; return value in D0
	ADD.L	D1,heap_end	; update heap pointer
	RTS


memcpy::
	MOVEA.L	($4,SP),A1	; dest
	MOVEA.L	($8,SP),A0	; src
	MOVE.L	($c,SP),D0	; no of bytes
	BEQ	.2		; if no of bytes=0 then return
.1	MOVE.B	(A0)+,(A1)+
	SUBQ	#$1,D0
	BNE	.1
.2	RTS

;u8 *memcpy(u8 *dest, const u8 *src, size_t count)
;{
;	for (u32 i=0; i<count; i++)
;		dest[i] = src[i];
;	return dest;
;}

memset::
	MOVEA.L	($4,SP),A0	; destination
	MOVE.B	($8,SP),D0	; value
	MOVE.L	($a,SP),D1	; no of bytes
	BEQ	.2		; if no of bytes=0 then return
.1	MOVE.B	D0,(A0)+
	SUBQ	#$1,D1
	BNE	.1
.2	RTS

;u8 *memset(u8 *dest, u8 val, size_t count)
;{
;	for (u32 i=0; i<count; i++)
;		dest[i] = val;
;	return dest;
;}


**************************************
* void set_interrupt_mask(word mask) *
**************************************
set_interrupt_mask::
	MOVE.W	($4,SP),D0	; get word value from stack
	ANDI.W	#$7,D0		; between 0 and 7
	LSL.W	#$8,D0		; leftshift 8 bits
	MOVE	SR,D1		; get current status
	ANDI.W	#$f8ff,D1
	OR.W	D0,D1		; apply new level
	MOVE	D1,SR
	RTS


*****************************
* word get_interrupt_mask() *
*****************************
get_interrupt_mask::
	MOVE	SR,D0
	ANDI.W	#$0700,D0
	LSR.W	#$8,D0		; current priority is in D0 = return value
	RTS


*****************************************************************
* void update_exception_vector(byte vectornumber, long address) *
*****************************************************************
update_exception_vector::
	LINK	A6,#-$2		; local storage for current ipl
	JSR	get_interrupt_mask
	MOVE.W	D0,(-$2,A6)	; store it
	MOVE.W	#$7,-(SP)	; mask all incoming irq's
	JSR	set_interrupt_mask
	LEA	($2,SP),SP
	CLR.L	D0
	MOVE.B	($8,SP),D0
	ADD.L	D0,D0
	ADD.L	D0,D0		; times 4 to get address
	MOVEA.L	D0,A0
	MOVE.L	($a,SP),D0
	MOVE.L	D0,(A0)
	UNLK	A6
	RTS
