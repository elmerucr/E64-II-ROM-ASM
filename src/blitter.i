BLIT_STRUCT_SIZE		equ	$20	; in bytes

BLIT_FLAGS_0			equ	$0	; byte
BLIT_FLAGS_1			equ	$1	; byte
BLIT_SIZE_IN_TILES_LOG2		equ	$2	; byte
BLIT_CURRENTLY_UNUSED		equ	$3	; byte
BLIT_X				equ	$4	; word
BLIT_Y				equ	$6	; word
BLIT_FOREGROUND_COLOR		equ	$8	; word
BLIT_BACKGROUND_COLOR		equ	$a	; word
BLIT_PIXEL_DATA			equ	$c	; long (pointer to word)
BLIT_TILES			equ	$10	; long (pointer to byte)
BLIT_TILES_COLOR		equ	$14	; long (pointer to word)
BLIT_TILES_BACKGROUND_COLOR	equ	$18	; long (pointer to word)
BLIT_USER_DATA			equ	$1c	; long (pointer to void)
