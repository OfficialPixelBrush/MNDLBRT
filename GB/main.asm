;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.0 #12072 (MINGW32)
;--------------------------------------------------------
	.module main
	.optsdcc -mgbz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _drawSetInMode
	.globl _funcY
	.globl _funcX
	.globl _mapRange
	.globl _smoothColor
	.globl _getAbs
	.globl _intMod
	.globl _plot
	.globl _multi
	.globl _Zoom
	.globl _yCoord
	.globl _xCoord
	.globl _factor
	.globl _res
	.globl _y
	.globl _x
	.globl _funcNum
	.globl _juliaMode
	.globl _t
	.globl _ySize
	.globl _xSize
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_xSize::
	.ds 2
_ySize::
	.ds 2
_t::
	.ds 2
_juliaMode::
	.ds 2
_funcNum::
	.ds 2
_x::
	.ds 2
_y::
	.ds 2
_res::
	.ds 2
_factor::
	.ds 2
_xCoord::
	.ds 4
_yCoord::
	.ds 4
_Zoom::
	.ds 4
_multi::
	.ds 4
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;main.c:11: int intMod(int x, int y) {
;	---------------------------------
; Function intMod
; ---------------------------------
_intMod::
;main.c:12: return (x - y*(x/y));
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__divsint
	add	sp, #4
	push	de
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mulint
	add	sp, #4
	ld	c, e
	ld	b, d
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	d, a
;main.c:13: }
	ret
;main.c:16: long getAbs(long n) {
;	---------------------------------
; Function getAbs
; ---------------------------------
_getAbs::
;main.c:17: if (n < 0) {
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x00
	inc	hl
	ld	a, (hl)
	sbc	a, #0x00
	inc	hl
	ld	a, (hl)
	sbc	a, #0x00
	inc	hl
	ld	a, (hl)
	sbc	a, #0x00
	ld	d, (hl)
	ld	a, #0x00
	bit	7,a
	jr	Z, 00110$
	bit	7, d
	jr	NZ, 00111$
	cp	a, a
	jr	00111$
00110$:
	bit	7, d
	jr	Z, 00111$
	scf
00111$:
	jr	NC, 00102$
;main.c:18: n = (-1) * n;
	ld	de, #0x0000
	ld	a, e
	ldhl	sp,	#2
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ld	(hl-), a
	ld	(hl), e
	ld	de, #0x0000
	inc	hl
	inc	hl
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ld	(hl-), a
	ld	(hl), e
00102$:
;main.c:20: return n;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
;main.c:21: }
	ret
;main.c:24: int smoothColor(int i, int x, int y) {	
;	---------------------------------
; Function smoothColor
; ---------------------------------
_smoothColor::
	add	sp, #-13
;main.c:25: int out = intMod(i/4, NUM_COLORS)+COLOR_OFFSET;
	ldhl	sp,#15
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	bit	7, b
	jr	Z, 00153$
	inc	bc
	inc	bc
	inc	bc
00153$:
	sra	b
	rr	c
	sra	b
	rr	c
	ld	hl, #0x0004
	push	hl
	push	bc
	call	_intMod
	add	sp, #4
	ldhl	sp,	#11
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;main.c:26: int iModFour = i%4;
	ld	hl, #0x0004
	push	hl
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__modsint
	add	sp, #4
	inc	sp
	inc	sp
	push	de
;main.c:32: if (out > NUM_COLORS+COLOR_OFFSET) {
	ldhl	sp,	#11
	ld	a, #0x04
	sub	a, (hl)
	inc	hl
	ld	a, #0x00
	sbc	a, (hl)
	ld	a, #0x00
	ld	d, a
	bit	7, (hl)
	jr	Z, 00274$
	bit	7, d
	jr	NZ, 00275$
	cp	a, a
	jr	00275$
00274$:
	bit	7, d
	jr	Z, 00275$
	scf
00275$:
	ld	a, #0x00
	rla
	ldhl	sp,	#2
	ld	(hl), a
;main.c:33: out = out-NUM_COLORS+COLOR_OFFSET;
;c
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0xfffc
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl), a
;main.c:29: switch (iModFour) {
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	inc	hl
	or	a, (hl)
	jr	Z, 00101$
;main.c:38: if (y%2) {
	ld	hl, #0x0002
	push	hl
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
;main.c:39: if (x%2) {
	call	__modsint
	add	sp, #4
	push	hl
	ldhl	sp,	#7
	ld	(hl), e
	ldhl	sp,	#8
	ld	(hl), d
	pop	hl
	ld	hl, #0x0002
	push	hl
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
;main.c:44: ++out;
	call	__modsint
	add	sp, #4
	push	hl
	ldhl	sp,	#9
	ld	(hl), e
	ldhl	sp,	#10
	ld	(hl), d
	pop	hl
;c
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl), a
;main.c:29: switch (iModFour) {
	ldhl	sp,	#0
	ld	a, (hl)
	dec	a
	inc	hl
	or	a, (hl)
	jr	Z, 00104$
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x02
	inc	hl
	or	a, (hl)
	jp	Z,00117$
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x03
	inc	hl
	or	a, (hl)
	jp	Z,00135$
	jp	00150$
;main.c:30: case 0:
00101$:
;main.c:32: if (out > NUM_COLORS+COLOR_OFFSET) {
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
;main.c:33: out = out-NUM_COLORS+COLOR_OFFSET;
	inc	hl
	ld	a, (hl+)
	ld	e, (hl)
	ldhl	sp,	#11
	ld	(hl+), a
	ld	(hl), e
00103$:
;main.c:35: return out;
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	jp	00151$
;main.c:36: case 1:
00104$:
;main.c:38: if (y%2) {
	ldhl	sp,	#6
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00115$
;main.c:39: if (x%2) {
	ldhl	sp,	#8
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00110$
;main.c:40: if (out > NUM_COLORS+COLOR_OFFSET) {
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00116$
;main.c:41: out = out-NUM_COLORS+COLOR_OFFSET;
	inc	hl
	ld	a, (hl+)
	ld	e, (hl)
	ldhl	sp,	#11
	ld	(hl+), a
	ld	(hl), e
	jr	00116$
00110$:
;main.c:44: ++out;
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, (hl)
	inc	hl
	ld	(hl+), a
;main.c:45: if (out > NUM_COLORS+COLOR_OFFSET) {
	ld	a, e
	ld	(hl-), a
	ld	a, #0x04
	sub	a, (hl)
	inc	hl
	ld	a, #0x00
	sbc	a, (hl)
	ld	a, #0x00
	ld	d, a
	bit	7, (hl)
	jr	Z, 00280$
	bit	7, d
	jr	NZ, 00281$
	cp	a, a
	jr	00281$
00280$:
	bit	7, d
	jr	Z, 00281$
	scf
00281$:
	jr	NC, 00116$
;main.c:46: out = out-NUM_COLORS+COLOR_OFFSET;
;c
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0xfffc
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl), a
	jr	00116$
00115$:
;main.c:50: if (out > NUM_COLORS+COLOR_OFFSET) {
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00116$
;main.c:51: out = out-NUM_COLORS+COLOR_OFFSET;
	inc	hl
	ld	a, (hl+)
	ld	e, (hl)
	ldhl	sp,	#11
	ld	(hl+), a
	ld	(hl), e
00116$:
;main.c:55: return out;
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	jp	00151$
;main.c:56: case 2:
00117$:
;main.c:58: if (y%2) {
	ldhl	sp,	#6
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00133$
;main.c:59: if (x%2) {
	ldhl	sp,	#8
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00123$
;main.c:60: if (out > NUM_COLORS+COLOR_OFFSET) {
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jp	Z, 00134$
;main.c:61: out = out-NUM_COLORS+COLOR_OFFSET;
	inc	hl
	ld	a, (hl+)
	ld	e, (hl)
	ldhl	sp,	#11
	ld	(hl+), a
	ld	(hl), e
	jp	00134$
00123$:
;main.c:64: ++out;
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, (hl)
	inc	hl
	ld	(hl+), a
;main.c:65: if (out > NUM_COLORS+COLOR_OFFSET) {
	ld	a, e
	ld	(hl-), a
	ld	a, #0x04
	sub	a, (hl)
	inc	hl
	ld	a, #0x00
	sbc	a, (hl)
	ld	a, #0x00
	ld	d, a
	bit	7, (hl)
	jr	Z, 00282$
	bit	7, d
	jr	NZ, 00283$
	cp	a, a
	jr	00283$
00282$:
	bit	7, d
	jr	Z, 00283$
	scf
00283$:
	jr	NC, 00134$
;main.c:66: out = out-NUM_COLORS+COLOR_OFFSET;
;c
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0xfffc
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl), a
	jr	00134$
00133$:
;main.c:70: if (x%2) {
	ldhl	sp,	#8
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00130$
;main.c:71: ++out;
	inc	hl
	inc	hl
	ld	a, (hl+)
	ld	e, (hl)
	inc	hl
	ld	(hl+), a
;main.c:72: if (out > NUM_COLORS+COLOR_OFFSET) {
	ld	a, e
	ld	(hl-), a
	ld	a, #0x04
	sub	a, (hl)
	inc	hl
	ld	a, #0x00
	sbc	a, (hl)
	ld	a, #0x00
	ld	d, a
	bit	7, (hl)
	jr	Z, 00284$
	bit	7, d
	jr	NZ, 00285$
	cp	a, a
	jr	00285$
00284$:
	bit	7, d
	jr	Z, 00285$
	scf
00285$:
	jr	NC, 00134$
;main.c:73: out = out-NUM_COLORS+COLOR_OFFSET;
;c
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0xfffc
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl), a
	jr	00134$
00130$:
;main.c:76: if (out > NUM_COLORS+COLOR_OFFSET) {
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00134$
;main.c:77: out = out-NUM_COLORS+COLOR_OFFSET;
	inc	hl
	ld	a, (hl+)
	ld	e, (hl)
	ldhl	sp,	#11
	ld	(hl+), a
	ld	(hl), e
00134$:
;main.c:82: return out;
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	jp	00151$
;main.c:83: case 3:
00135$:
;main.c:85: if (y%2) {
	ldhl	sp,	#6
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00146$
;main.c:86: if (x%2) {
	ldhl	sp,	#8
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00141$
;main.c:87: ++out;
	inc	hl
	inc	hl
	ld	a, (hl+)
	ld	e, (hl)
	inc	hl
	ld	(hl+), a
;main.c:88: if (out > NUM_COLORS+COLOR_OFFSET) {
	ld	a, e
	ld	(hl-), a
	ld	a, #0x04
	sub	a, (hl)
	inc	hl
	ld	a, #0x00
	sbc	a, (hl)
	ld	a, #0x00
	ld	d, a
	bit	7, (hl)
	jr	Z, 00286$
	bit	7, d
	jr	NZ, 00287$
	cp	a, a
	jr	00287$
00286$:
	bit	7, d
	jr	Z, 00287$
	scf
00287$:
	jr	NC, 00147$
;main.c:89: out = out-NUM_COLORS;
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#12
	ld	(hl-), a
	ld	(hl), e
	jr	00147$
00141$:
;main.c:92: if (out > NUM_COLORS+COLOR_OFFSET) {
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00147$
;main.c:93: out = out-NUM_COLORS;
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#12
	ld	(hl-), a
	ld	(hl), e
	jr	00147$
00146$:
;main.c:97: ++out;
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, (hl)
	inc	hl
	ld	(hl+), a
;main.c:98: if (out > NUM_COLORS+COLOR_OFFSET) {
	ld	a, e
	ld	(hl-), a
	ld	a, #0x04
	sub	a, (hl)
	inc	hl
	ld	a, #0x00
	sbc	a, (hl)
	ld	a, #0x00
	ld	d, a
	bit	7, (hl)
	jr	Z, 00288$
	bit	7, d
	jr	NZ, 00289$
	cp	a, a
	jr	00289$
00288$:
	bit	7, d
	jr	Z, 00289$
	scf
00289$:
	jr	NC, 00147$
;main.c:99: out = out-NUM_COLORS;
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#12
	ld	(hl-), a
	ld	(hl), e
00147$:
;main.c:103: if (out < COLOR_OFFSET) {
	ldhl	sp,	#11
	ld	a, (hl)
	sub	a, #0x00
	inc	hl
	ld	a, (hl)
	sbc	a, #0x00
	ld	d, (hl)
	ld	a, #0x00
	bit	7,a
	jr	Z, 00290$
	bit	7, d
	jr	NZ, 00291$
	cp	a, a
	jr	00291$
00290$:
	bit	7, d
	jr	Z, 00291$
	scf
00291$:
	jr	NC, 00150$
;main.c:104: out = out-1;
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	dec	de
	dec	hl
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;main.c:106: }
00150$:
;main.c:107: return out;
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
00151$:
;main.c:108: }
	add	sp, #13
	ret
;main.c:114: long mapRange(long a1, long a2, long b1, long b2, long s) {
;	---------------------------------
; Function mapRange
; ---------------------------------
_mapRange::
	add	sp, #-8
;main.c:115: return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
	ldhl	sp,#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#10
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#3
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#30
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#14
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#18
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#7
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#22
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#7
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	inc	sp
	inc	sp
	push	de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#10
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#7
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#14
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#7
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__divslong
	add	sp, #8
	inc	sp
	inc	sp
	push	de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#0
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#7
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#4
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
;main.c:116: }
	add	sp, #8
	ret
;main.c:119: long funcX(long function, long zx, long zy, long cx) {
;	---------------------------------
; Function funcX
; ---------------------------------
_funcX::
	add	sp, #-24
;main.c:122: return ((zx*zx - zy*zy)/factor + cx);
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	inc	sp
	inc	sp
	push	de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#6
	ld	(hl), e
	ldhl	sp,	#7
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
	ld	a, (#_factor)
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, (#_factor + 1)
	ldhl	sp,	#9
	ld	(hl), a
	rla
	sbc	a, a
	inc	hl
	ld	(hl+), a
	ld	(hl), a
	pop	de
	push	de
	ld	a, e
	ldhl	sp,	#4
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#8
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__divslong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#38
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#42
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
;main.c:120: switch ( function ) {
	ldhl	sp,	#26
	ld	a, (hl)
	dec	a
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00101$
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x02
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00102$
;main.c:126: return ((zx*zx*zx - 3*zx*zy*zy)/factor + cx);
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
;main.c:120: switch ( function ) {
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#22
	ld	(hl), e
	ldhl	sp,	#23
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#24
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#23
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x03
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00103$
;main.c:128: return ((zx*zx*zx*zx - (6*zx*zx - zy*zy)*zy*zy)/factor + cx);
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
;main.c:120: switch ( function ) {
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x04
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00104$
;main.c:130: return ((zx*zx*zx*zx*zx + zx*zy*zy*(5*zy*zy - 10*zx*zx))/factor + cx);
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
;main.c:120: switch ( function ) {
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#22
	ld	(hl), e
	ldhl	sp,	#23
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#24
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#23
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x05
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00105$
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x06
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00106$
	jp	00107$
;main.c:121: case 1:
00101$:
;main.c:122: return ((zx*zx - zy*zy)/factor + cx);
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jp	00108$
;main.c:123: case 2:
00102$:
;main.c:124: return (zx*zx - zy*zy)/factor + cx;
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jp	00108$
;main.c:125: case 3:
00103$:
;main.c:126: return ((zx*zx*zx - 3*zx*zy*zy)/factor + cx);
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0003
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#14
	ld	(hl), e
	ldhl	sp,	#15
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#12
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#16
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__divslong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#38
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#42
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jp	00108$
;main.c:127: case 4:
00104$:
;main.c:128: return ((zx*zx*zx*zx - (6*zx*zx - zy*zy)*zy*zy)/factor + cx);
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0006
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#14
	ld	(hl), e
	ldhl	sp,	#15
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#4
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#8
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#14
	ld	(hl), e
	ldhl	sp,	#15
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#12
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#16
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__divslong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#38
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#42
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jp	00108$
;main.c:129: case 5:
00105$:
;main.c:130: return ((zx*zx*zx*zx*zx + zx*zy*zy*(5*zy*zy - 10*zx*zx))/factor + cx);
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	inc	sp
	inc	sp
	push	de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0005
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#6
	ld	(hl), e
	ldhl	sp,	#7
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x000a
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#14
	ld	(hl), e
	ldhl	sp,	#15
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#12
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#16
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#14
	ld	(hl), e
	ldhl	sp,	#15
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#12
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#16
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__divslong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#38
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#42
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jp	00108$
;main.c:131: case 6:
00106$:
;main.c:132: return (zx*zx*zx*zx*zx*zx - 15*((zx*zx*zx*zx)*(zy*zy)) + 15*((zx*zx)*(zy*zy*zy*zy)) - zy*zy*zy*zy*zy*zy)/factor + cx;
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#14
	ld	(hl), e
	ldhl	sp,	#15
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	push	de
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x000f
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#16
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#20
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	push	de
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x000f
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#6
	ld	(hl), e
	ldhl	sp,	#7
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#4
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#15
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#8
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#15
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#16
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#20
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__divslong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#38
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#42
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jr	00108$
;main.c:133: }
00107$:
;main.c:134: return 0;
	ld	de, #0x0000
	ld	hl, #0x0000
00108$:
;main.c:135: }
	add	sp, #24
	ret
;main.c:137: long funcY(long function, long zy, long cy, long tmp) {
;	---------------------------------
; Function funcY
; ---------------------------------
_funcY::
	add	sp, #-24
;main.c:140: return (getAbs((2*tmp*zy))/factor + cy);
	ldhl	sp,	#38
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	sla	c
	rl	b
	rl	e
	rl	d
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	de
	push	bc
;main.c:138: switch ( function ) {
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#22
	ld	(hl), e
	ldhl	sp,	#23
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#24
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#23
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	dec	a
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00101$
;main.c:140: return (getAbs((2*tmp*zy))/factor + cy);
	ld	a, (#_factor)
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, (#_factor + 1)
	ldhl	sp,	#1
	ld	(hl), a
	rla
	sbc	a, a
	inc	hl
	ld	(hl+), a
	ld	(hl), a
;main.c:138: switch ( function ) {
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x02
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00102$
;main.c:144: return (3*tmp*tmp*zy - zy*zy*zy)/factor + cy;
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
;main.c:138: switch ( function ) {
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#22
	ld	(hl), e
	ldhl	sp,	#23
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#24
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#23
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x03
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00103$
;main.c:146: return (4*tmp*zy*(tmp*tmp - zy*zy))/factor + cy;
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#44
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#44
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
;main.c:138: switch ( function ) {
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#6
	ld	(hl), e
	ldhl	sp,	#7
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x04
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00104$
;main.c:148: return (zy*(5*tmp*tmp*(tmp*tmp - 2*zy*zy) + zy*zy*zy*zy))/factor + cy;
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
;main.c:138: switch ( function ) {
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#10
	ld	(hl), e
	ldhl	sp,	#11
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x05
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00105$
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x06
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	inc	hl
	or	a, (hl)
	jp	Z,00106$
	jp	00107$
;main.c:139: case 1:
00101$:
;main.c:140: return (getAbs((2*tmp*zy))/factor + cy);
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	_getAbs
	add	sp, #4
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ld	a, (#_factor)
	ldhl	sp,	#20
	ld	(hl), a
	ld	a, (#_factor + 1)
	ldhl	sp,	#21
	ld	(hl), a
	rla
	sbc	a, a
	inc	hl
	ld	(hl+), a
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__divslong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#34
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#38
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jp	00108$
;main.c:141: case 2:
00102$:
;main.c:142: return 2*tmp*zy/factor + cy;
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	c, l
	ld	b, h
	pop	hl
	push	hl
	push	bc
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__divslong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#34
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#38
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jp	00108$
;main.c:143: case 3:
00103$:
;main.c:144: return (3*tmp*tmp*zy - zy*zy*zy)/factor + cy;
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0003
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#14
	ld	(hl), e
	ldhl	sp,	#15
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#20
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#19
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#24
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	c, l
	ld	b, h
	pop	hl
	push	hl
	push	bc
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__divslong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#34
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#38
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jp	00108$
;main.c:145: case 4:
00104$:
;main.c:146: return (4*tmp*zy*(tmp*tmp - zy*zy))/factor + cy;
	ldhl	sp,	#38
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, #0x02
00148$:
	sla	c
	rl	b
	rl	e
	rl	d
	dec	a
	jr	NZ,00148$
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	de
	push	bc
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#14
	ld	(hl), e
	ldhl	sp,	#15
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#16
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#20
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__divslong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#34
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#38
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jp	00108$
;main.c:147: case 5:
00105$:
;main.c:148: return (zy*(5*tmp*tmp*(tmp*tmp - 2*zy*zy) + zy*zy*zy*zy))/factor + cy;
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0005
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#14
	ld	(hl), e
	ldhl	sp,	#15
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#30
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	sla	c
	rl	b
	rl	e
	rl	d
	dec	hl
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	de
	push	bc
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#16
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#20
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#8
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#12
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__divslong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#34
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#38
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jp	00108$
;main.c:149: case 6:
00106$:
;main.c:150: return (6*(tmp*tmp*tmp*tmp*tmp)*zy-20*(tmp*tmp*tmp)*(zy*zy*zy)+6*tmp*(zy*zy*zy*zy*zy))/factor + cy;
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	push	hl
	push	de
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0006
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#14
	ld	(hl), e
	ldhl	sp,	#15
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0014
	push	hl
	call	__mullong
	add	sp, #8
	ld	c, l
	ld	b, h
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#16
	sub	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#20
	pop	af
	ld	a, e
	sbc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	sbc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0006
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#32
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	push	de
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#14
	ld	(hl), e
	ldhl	sp,	#15
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#12
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#16
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#19
	ld	(hl-), a
	ld	(hl), e
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	c, l
	ld	b, h
	pop	hl
	push	hl
	push	bc
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__divslong
	add	sp, #8
	push	hl
	ldhl	sp,	#18
	ld	(hl), e
	ldhl	sp,	#19
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#34
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#38
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, e
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	jr	00108$
;main.c:151: }
00107$:
;main.c:152: return 0;
	ld	de, #0x0000
	ld	hl, #0x0000
00108$:
;main.c:153: }
	add	sp, #24
	ret
;main.c:155: void drawSetInMode() {
;	---------------------------------
; Function drawSetInMode
; ---------------------------------
_drawSetInMode::
	add	sp, #-32
;main.c:156: for (y = 0; y < SCREEN_HEIGHT; y++) {
	ld	hl, #_y
	ld	a, #0x00
	ld	(hl+), a
	ld	(hl), #0x00
00112$:
;main.c:157: for (x = 0; x < SCREEN_WIDTH; x++) {
	ld	hl, #_x
	ld	a, #0x00
	ld	(hl+), a
	ld	(hl), #0x00
00110$:
;main.c:160: cx = mapRange(0, SCREEN_WIDTH - 1, -2*factor, 2*factor, x);
	ld	a, (#_x)
	ldhl	sp,	#24
	ld	(hl), a
	ld	a, (#_x + 1)
	ldhl	sp,	#25
	ld	(hl), a
	rla
	sbc	a, a
	inc	hl
	ld	(hl+), a
	ld	(hl), a
	ld	hl, #_factor
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	sla	c
	adc	a, a
	ldhl	sp,	#28
	ld	(hl), c
	inc	hl
	ld	(hl), a
	rla
	sbc	a, a
	inc	hl
	ld	(hl+), a
	ld	(hl), a
	ld	hl, #_factor + 1
	dec	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	a, b
	rla
	sbc	a, a
	ld	e, a
	ld	d, a
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#34
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#34
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	de
	push	bc
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x009f
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0000
	push	hl
	call	_mapRange
	add	sp, #20
	ld	c, l
	ld	b, h
	inc	sp
	inc	sp
	push	de
	ldhl	sp,	#2
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:161: cy = mapRange(0, SCREEN_HEIGHT - 1, -2*factor, 2*factor, y);
	ld	a, (#_y)
	ldhl	sp,	#24
	ld	(hl), a
	ld	a, (#_y + 1)
	ldhl	sp,	#25
	ld	(hl), a
	rla
	sbc	a, a
	inc	hl
	ld	(hl+), a
	ld	(hl), a
	ld	hl, #_factor
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	sla	c
	adc	a, a
	ldhl	sp,	#28
	ld	(hl), c
	inc	hl
	ld	(hl), a
	rla
	sbc	a, a
	inc	hl
	ld	(hl+), a
	ld	(hl), a
	ld	hl, #_factor + 1
	dec	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	a, b
	rla
	sbc	a, a
	ld	e, a
	ld	d, a
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#34
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#34
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	de
	push	bc
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x008f
	push	hl
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0000
	push	hl
	call	_mapRange
	add	sp, #20
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:162: zy = cy;
	ldhl	sp,	#4
	ld	d, h
	ld	e, l
	ldhl	sp,	#8
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;main.c:163: zx = cx;
	ldhl	sp,	#0
	ld	d, h
	ld	e, l
	ldhl	sp,	#12
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;main.c:165: for (i = 0; i < t; i++) {
	xor	a, a
	ldhl	sp,	#16
	ld	(hl+), a
	ld	(hl), a
	xor	a, a
	ldhl	sp,	#30
	ld	(hl+), a
	ld	(hl), a
00108$:
	ldhl	sp,	#30
	ld	e, l
	ld	d, h
	ld	hl, #_t
	ld	a, (de)
	sub	a, (hl)
	inc	hl
	inc	de
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 00148$
	bit	7, d
	jr	NZ, 00149$
	cp	a, a
	jr	00149$
00148$:
	bit	7, d
	jr	Z, 00149$
	scf
00149$:
	jp	NC, 00111$
;main.c:166: long tmp = zx;
	ldhl	sp,	#12
	ld	d, h
	ld	e, l
	ldhl	sp,	#26
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;main.c:167: zx = funcX(funcNum, zx, zy, cx);
	ld	hl, #_funcNum
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ld	b, a
	rla
	sbc	a, a
	ld	e, a
	ld	d, a
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	de
	push	bc
	call	_funcX
	add	sp, #16
	ld	c, l
	ld	b, h
	ldhl	sp,	#12
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:168: zy = funcY(funcNum, zy, cy, tmp);
	ld	hl, #_funcNum
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ld	b, a
	rla
	sbc	a, a
	ld	e, a
	ld	d, a
	ldhl	sp,	#28
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#28
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	de
	push	bc
	call	_funcY
	add	sp, #16
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;main.c:170: if ((zx*zx + zy*zy) > (4*(factor*factor))) {
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#20
	ld	(hl), e
	ldhl	sp,	#21
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#22
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#21
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mullong
	add	sp, #8
	push	hl
	ldhl	sp,	#24
	ld	(hl), e
	ldhl	sp,	#25
	ld	(hl), d
	pop	hl
	push	hl
	ld	a, l
	ldhl	sp,	#26
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	ldhl	sp,	#22
	add	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	push	af
	ldhl	sp,	#29
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#26
	pop	af
	ld	a, e
	adc	a, (hl)
	ld	e, a
	ld	a, d
	inc	hl
	adc	a, (hl)
	ldhl	sp,	#29
	ld	(hl-), a
	ld	(hl), e
	ld	hl, #_factor
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	hl, #_factor
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	__mulint
	add	sp, #4
	ld	a, d
	sla	e
	adc	a, a
	sla	e
	adc	a, a
	ldhl	sp,	#22
	ld	(hl), e
	inc	hl
	ld	(hl), a
	rla
	sbc	a, a
	inc	hl
	ld	(hl+), a
	ld	(hl), a
	ldhl	sp,	#22
	ld	e, l
	ld	d, h
	ldhl	sp,	#26
	ld	a, (de)
	sub	a, (hl)
	inc	hl
	inc	de
	ld	a, (de)
	sbc	a, (hl)
	inc	hl
	inc	de
	ld	a, (de)
	sbc	a, (hl)
	inc	hl
	inc	de
	ld	a, (de)
	sbc	a, (hl)
	ld	a, (de)
	ld	d, a
	bit	7, (hl)
	jr	Z, 00151$
	bit	7, d
	jr	NZ, 00152$
	cp	a, a
	jr	00152$
00151$:
	bit	7, d
	jr	Z, 00152$
	scf
00152$:
	jr	NC, 00102$
;main.c:171: plot(x,y,smoothColor(i,x,y),SOLID);
	ld	hl, #_y
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	hl, #_x
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#20
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	_smoothColor
	add	sp, #6
	ld	a, e
	ld	hl, #_y
	ld	b, (hl)
	ld	hl, #_x
	ld	d, (hl)
	ld	h, #0x00
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	c, d
	push	bc
	call	_plot
	add	sp, #4
;main.c:172: break;
	jr	00111$
00102$:
;main.c:174: plot(x,y,BLACK,SOLID);
	ld	a, (#_y)
	ld	hl, #_x
	ld	b, (hl)
	ld	h, #0x00
	push	hl
	inc	sp
	ld	h, #0x03
	push	hl
	inc	sp
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_plot
	add	sp, #4
;main.c:165: for (i = 0; i < t; i++) {
	ldhl	sp,	#30
	inc	(hl)
	jr	NZ, 00153$
	inc	hl
	inc	(hl)
00153$:
	ldhl	sp,	#30
	ld	a, (hl+)
	ld	e, (hl)
	ldhl	sp,	#16
	ld	(hl+), a
	ld	(hl), e
	jp	00108$
00111$:
;main.c:157: for (x = 0; x < SCREEN_WIDTH; x++) {
	ld	hl, #_x
	inc	(hl)
	jr	NZ, 00154$
	inc	hl
	inc	(hl)
00154$:
	ld	hl, #_x
	ld	a, (hl)
	sub	a, #0xa0
	inc	hl
	ld	a, (hl)
	sbc	a, #0x00
	ld	d, (hl)
	ld	a, #0x00
	bit	7,a
	jr	Z, 00155$
	bit	7, d
	jr	NZ, 00156$
	cp	a, a
	jr	00156$
00155$:
	bit	7, d
	jr	Z, 00156$
	scf
00156$:
	jp	C, 00110$
;main.c:156: for (y = 0; y < SCREEN_HEIGHT; y++) {
	ld	hl, #_y
	inc	(hl)
	jr	NZ, 00157$
	inc	hl
	inc	(hl)
00157$:
	ld	hl, #_y
	ld	a, (hl)
	sub	a, #0x90
	inc	hl
	ld	a, (hl)
	sbc	a, #0x00
	ld	d, (hl)
	ld	a, #0x00
	ld	e, a
	bit	7, e
	jr	Z, 00158$
	bit	7, d
	jr	NZ, 00159$
	cp	a, a
	jr	00159$
00158$:
	bit	7, d
	jr	Z, 00159$
	scf
00159$:
	jp	C, 00112$
;main.c:179: }
	add	sp, #32
	ret
;main.c:181: long main(void) {
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main.c:182: factor = 50;
	ld	hl, #_factor
	ld	a, #0x32
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:183: res = 1;
	ld	hl, #_res
	ld	a, #0x01
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:184: x = 0;
	ld	hl, #_x
	ld	a, #0x00
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:185: y = 0;
	ld	hl, #_y
	ld	a, #0x00
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:186: juliaMode = 0;
	ld	hl, #_juliaMode
	ld	a, #0x00
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:187: funcNum = 2;
	ld	hl, #_funcNum
	ld	a, #0x02
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:188: t = 25;
	ld	hl, #_t
	ld	a, #0x19
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:189: xCoord = 0;
	ld	hl, #_xCoord
	ld	a,#0x00
	ld	(hl+),a
	ld	(hl+), a
	ld	a, #0x00
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:190: yCoord = 0;
	ld	hl, #_yCoord
	ld	a,#0x00
	ld	(hl+),a
	ld	(hl+), a
	ld	a, #0x00
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:191: Zoom = 10;
	ld	hl, #_Zoom
	ld	a, #0x0a
	ld	(hl+), a
	ld	a,#0x00
	ld	(hl+),a
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:192: drawSetInMode();
	call	_drawSetInMode
;main.c:198: return 0;
	ld	de, #0x0000
	ld	hl, #0x0000
;main.c:199: }
	ret
	.area _CODE
	.area _CABS (ABS)
