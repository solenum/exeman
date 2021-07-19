;-------------
; Splash screen tiles and map
;-------------

SPLASH_TILE_COUNT EQU 880
SPLASH_MAP_SIZE_A EQU 3*32
SPLASH_MAP_SIZE_B EQU 7*32

SECTION "Splash Data",ROM0
SPLASH_TILE_DATA:
DB $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
DB $fc,$fc,$fb,$f8,$fb,$f8,$f7,$f0,$f7,$f0,$f7,$f0,$f7,$f0,$ef,$e0
DB $07,$07,$fb,$03,$fb,$03,$f7,$07,$f7,$07,$f7,$07,$ef,$0f,$ef,$0f
DB $fc,$fc,$fb,$f8,$fb,$f8,$f7,$f0,$f7,$f0,$f7,$f0,$f7,$f0,$ef,$e0
DB $00,$00,$ff,$00,$ff,$00,$ff,$00,$83,$00,$01,$7c,$00,$7e,$78,$7e
DB $ff,$ff,$3f,$3f,$df,$1f,$ef,$0f,$ef,$0f,$f7,$07,$f7,$07,$f7,$07
DB $ff,$ff,$c0,$c0,$3f,$00,$60,$00,$40,$1f,$07,$3f,$1f,$7f,$ff,$ff
DB $ff,$ff,$1f,$1f,$e7,$07,$7b,$03,$3d,$81,$bd,$81,$bd,$81,$bd,$81
DB $ff,$ff,$f8,$f8,$c7,$c0,$be,$80,$bc,$81,$78,$03,$7a,$03,$7b,$03
DB $ff,$ff,$1f,$1f,$e3,$03,$7d,$01,$3d,$81,$1e,$c0,$1e,$c0,$de,$c0
DB $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
DB $ef,$e0,$ef,$e0,$ef,$e0,$ef,$e0,$df,$c0,$df,$c0,$df,$c0,$df,$c0
DB $ef,$0f,$ef,$0f,$ef,$0f,$ef,$0f,$df,$1f,$df,$1f,$c0,$00,$ff,$00
DB $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$07,$07,$fb,$03
DB $ee,$e0,$ee,$e0,$ee,$e0,$ee,$e0,$de,$c0,$df,$c0,$df,$c0,$df,$c0
DB $fe,$fe,$fe,$fe,$fd,$fc,$fd,$fc,$fd,$fc,$3b,$38,$c7,$00,$ff,$00
DB $f7,$07,$e7,$0f,$e7,$0f,$e7,$0f,$e7,$0f,$e7,$0f,$c7,$1f,$c7,$1f
DB $ff,$ff,$ff,$ff,$f8,$f8,$f8,$f8,$f8,$ff,$fc,$ff,$ff,$ff,$ff,$ff
DB $bd,$81,$71,$03,$e1,$0f,$63,$0f,$33,$83,$3d,$81,$1d,$c1,$dd,$c1
DB $bd,$81,$9d,$c1,$ce,$e0,$ef,$e0,$9e,$80,$7c,$01,$78,$03,$7a,$03
DB $bc,$81,$b8,$83,$71,$07,$f7,$07,$79,$01,$3e,$80,$1e,$c0,$1e,$c0
DB $ff,$ff,$ff,$ff,$99,$99,$99,$99,$99,$99,$89,$89,$89,$89,$81,$91
DB $df,$c0,$bf,$80,$bf,$80,$bf,$80,$80,$80,$80,$ff,$c0,$ff,$e0,$ff
DB $ff,$00,$ff,$00,$ff,$00,$ff,$00,$00,$00,$00,$ff,$00,$ff,$00,$ff
DB $f3,$07,$f3,$07,$f3,$07,$e3,$0f,$01,$0f,$01,$ff,$01,$ff,$01,$ff
DB $df,$c0,$bf,$80,$bf,$80,$87,$80,$80,$f8,$80,$ff,$c0,$ff,$c0,$ff
DB $ff,$00,$ff,$00,$ff,$00,$ff,$00,$00,$00,$00,$ff,$00,$ff,$00,$ff
DB $c7,$1f,$87,$3f,$8f,$3f,$0f,$7f,$1f,$ff,$1f,$ff,$3f,$ff,$7f,$ff
DB $ff,$ff,$ff,$ff,$3f,$3f,$3f,$3f,$40,$00,$3f,$00,$00,$c0,$80,$ff
DB $dc,$c0,$dd,$c1,$bd,$81,$bd,$81,$79,$03,$e1,$07,$03,$1f,$03,$ff
DB $7b,$03,$7b,$03,$7b,$03,$7d,$01,$be,$00,$87,$c0,$80,$f8,$c0,$ff
DB $de,$c0,$de,$c0,$de,$c0,$be,$80,$7c,$01,$e0,$03,$01,$1f,$01,$ff
DB $91,$91,$91,$99,$99,$99,$99,$99,$99,$99,$99,$ff,$ff,$ff,$ff,$ff
DB $ff,$ff,$ff,$ff,$e1,$e1,$dd,$c1,$dd,$c1,$dd,$c1,$c1,$c1,$c1,$df
DB $ff,$ff,$ff,$ff,$c3,$c3,$bd,$81,$bd,$81,$bd,$81,$bd,$81,$a1,$83
DB $ff,$ff,$ff,$ff,$c1,$c1,$bd,$81,$a1,$81,$a1,$8f,$a3,$83,$bb,$83
DB $ff,$ff,$ff,$ff,$c1,$c1,$bd,$81,$a1,$81,$a1,$8f,$a1,$81,$bd,$81
DB $ff,$ff,$ff,$ff,$e7,$e7,$d7,$c7,$91,$81,$bd,$81,$91,$81,$91,$c7
DB $ff,$ff,$ff,$ff,$e1,$e1,$dd,$c1,$c5,$c1,$f5,$f1,$f5,$f1,$c5,$c1
DB $ff,$ff,$ff,$ff,$c3,$c3,$bd,$81,$a5,$99,$bd,$99,$bd,$81,$81,$83
DB $ff,$ff,$ff,$ff,$bd,$bd,$5a,$18,$24,$81,$99,$c3,$c3,$e7,$e7,$e7
DB $ff,$ff,$ff,$ff,$bd,$bd,$bd,$bd,$99,$99,$99,$db,$c3,$c3,$c3,$e7
DB $ff,$ff,$ff,$ff,$81,$81,$81,$81,$81,$f3,$e3,$e7,$e7,$e7,$c7,$cf
DB $ff,$ff,$ff,$ff,$e3,$e3,$db,$c3,$c3,$c3,$c3,$ff,$c1,$c1,$bd,$81
DB $cf,$df,$cf,$df,$cf,$df,$cf,$df,$cf,$df,$cf,$ff,$ff,$ff,$ff,$ff
DB $83,$8f,$87,$af,$93,$b7,$93,$b7,$99,$bb,$99,$ff,$ff,$ff,$ff,$ff
DB $a3,$83,$a3,$8f,$a1,$81,$bd,$81,$81,$81,$81,$ff,$ff,$ff,$ff,$ff
DB $85,$81,$f5,$f1,$85,$81,$bd,$81,$81,$81,$81,$ff,$ff,$ff,$ff,$ff
DB $d7,$c7,$d7,$c7,$d1,$c1,$dd,$c1,$c1,$c1,$c1,$ff,$ff,$ff,$ff,$ff
DB $bd,$81,$a5,$99,$bd,$99,$bd,$81,$81,$c1,$c1,$ff,$ff,$ff,$ff,$ff
DB $bd,$81,$bd,$99,$bd,$99,$bd,$81,$81,$83,$81,$ff,$ff,$ff,$ff,$ff
DB $e7,$e7,$e7,$e7,$e7,$e7,$e7,$e7,$e7,$e7,$e7,$ff,$ff,$ff,$ff,$ff
DB $c3,$c3,$c3,$db,$99,$99,$99,$bd,$bd,$bd,$bd,$ff,$ff,$ff,$ff,$ff
DB $cf,$cf,$8f,$9f,$9f,$9f,$81,$81,$81,$81,$81,$ff,$ff,$ff,$ff,$ff
DB $bd,$81,$bd,$81,$bd,$81,$bd,$81,$81,$81,$81,$ff,$ff,$ff,$ff,$ff

SPLASH_MAP_DATA_B:
DB $00,$27,$28,$00,$23,$29,$23,$2a,$2b,$15,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$32,$33,$00,$2e,$34,$2e,$35,$36,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
SPLASH_MAP_DATA_A:
DB $01,$02,$00,$01,$04,$05,$00,$06,$07,$08,$09,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $0b,$0c,$0d,$0e,$0f,$10,$00,$11,$12,$13,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $16,$17,$18,$19,$17,$1b,$00,$1c,$1d,$1e,$1f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $21,$22,$23,$24,$24,$00,$24,$25,$26,$22,$25,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $2c,$2d,$2e,$2f,$2f,$00,$2f,$30,$31,$2d,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00