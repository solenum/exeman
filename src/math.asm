;-------------
; division code
; turn back now
; here be dragons
;-------------
PUSHS

SECTION "Math Div 16 Ram",WRAM0

_MD16temp    ds 2
_MD16count   db

POPS

SECTION "Math Div 16 Code",ROM0

; 16 bit division
; DE = DE / BC, BC = remainder

DIVIDE:
  ld      hl,_MD16temp
  ld      [hl],c
  inc     hl
  ld      [hl],b
  inc     hl
  ld      [hl],17
  ld      bc,0
.nxtbit:
  ld      hl,_MD16count
  ld      a,e
  rla
  ld      e,a
  ld      a,d
  rla
  ld      d,a
  dec     [hl]
  ret     z
  ld      a,c
  rla
  ld      c,a
  ld      a,b
  rla
  ld      b,a
  dec     hl
  dec     hl
  ld      a,c
  sub     [hl]
  ld      c,a
  inc     hl
  ld      a,b
  sbc     a,[hl]
  ld      b,a
  jr      nc,.noadd

  dec     hl
  ld      a,c
  add     a,[hl]
  ld      c,a
  inc     hl
  ld      a,b
  adc     a,[hl]
  ld      b,a
.noadd:
  ccf
  jr      .nxtbit
