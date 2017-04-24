;-------------
;	Header
;-------------

SECTION "Copy Data",ROM0[$28] ;copy DMA routine to HRAM
COPY_DATA:
	pop hl
	push bc
	ld  a,[hli]
	ld  b,a
	ld  a,[hli]
	ld  c,a
.copy_data_loop
	ld  a,[hli]
	ld  [de],a
	inc de
	dec bc
	ld  a,b
	or  c
	jr  nz,.copy_data_loop
	pop bc
	jp  hl
	reti

SECTION "VBlank IRQ",ROM0[$40]
	ld  a,$1
	ld  [vblank_flag],a
	reti

SECTION	"LCD IRQ Vector",ROM0[$48]
LCD_VECT:
	reti

SECTION	"Timer IRQ Vector",ROM0[$50]
TIMER_VECT:
	reti

SECTION	"Serial IRQ Vector",ROM0[$58]
SERIAL_VECT:
	reti

SECTION	"Joypad IRQ Vector",ROM0[$60]
JOYPAD_VECT:
	reti

SECTION "Start",ROM0[$100]
	nop
	jp  START

	; $0104-$0133 Nintendo logo !DONT MODIFY!
	DB  $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	DB  $00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	DB  $BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

	; $0134-$013E Game title
	DB	"gb-template"
		  ;0123456789A

	; $013F-$0142 Product code, leave blank
	DB	"    "
		;0123

	; $0143 compatibility mode
	DB	$00	; $00 - DMG 
			; $80 - DMG/GBC
			; $C0 - GBC Only cartridge

	; $0144 (High-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0145 (Low-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0146 (GameBoy/Super GameBoy indicator)
	DB	$00	; $00 - GameBoy

	; $0147 (Cartridge type - all Color GameBoy cartridges are at least $19)
	DB	$00	; $00 - ROM Only

	; $0148 (ROM size)
	DB	$00	; $00 - 256Kbit = 32Kbyte = 2 banks

	; $0149 (RAM size)
	DB	$00	; $00 - None

	; $014A (Destination code)
	DB	$01	; $01 - All others
			; $00 - Japan

	; $014B (Licensee code - this _must_ be $33)
	DB	$33	; $33 - Check $0144/$0145 for Licensee code.

	; $014C (Mask ROM version - handled by RGBFIX)
	DB	$00

	; $014D (Complement check - handled by RGBFIX)
	DB	$00

	; $014E-$014F (Cartridge checksum - handled by RGBFIX)
	DW	$00
