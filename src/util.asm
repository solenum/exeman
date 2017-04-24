;-------------
; Static vars
;-------------

Player_Initialize  equ $4000
Player_MusicStart  equ $4003
Player_MusicStop   equ $4006
Player_SongSelect  equ $400c
Player_MusicUpdate equ $4100
SongTick           equ $c7cc
MusicBank          equ 1
SplashSong         equ 0

;-------------
; utility subroutines etc
;-------------
WAIT_VBLANK:
  ld  hl,vblank_flag
.wait_vblank_loop
  halt
  nop        ;Hardware bug
  ld  a,$0
  cp  [hl]
  jr  z,.wait_vblank_loop
  ld  [hl],a

  ;increase timers
  ld  a,[vblank_count]
  inc a
  ld  [vblank_count],a
  ld  a,[player_fcount]
  inc a
  ld  [player_fcount],a
  ld  a,[player_gcount]
  inc a
  ld  [player_gcount],a
  ld  a,[enemy_fcount]
  inc a
  ld  [enemy_fcount],a
  ld  a,[enemy_gcount]
  inc a
  ld  [enemy_gcount],a
  ret

DMA_COPY:
  ld  de,$FF80
  rst $28
  DB  $00,$0D
  DB  $F5, $3E, $C1, $EA, $46, $FF, $3E, $28, $3D, $20, $FD, $F1, $D9
  ret

CLEAR_MAP:
  ld  hl,_SCRN0
  ld  bc,$400
  push hl

.clear_map_loop
  ;wait for hblank
  ld  hl,rSTAT
  bit 1,[hl]
  jr  nz,.clear_map_loop
  pop hl

  ld  a,$0
  ld  [hli],a
  push hl
  
  dec bc
  ld  a,b
  or  c
  jr  nz,.clear_map_loop
  pop hl
  ret

CLEAR_OAM:
  ld  hl,_OAMRAM
  ld  bc,$A0
.clear_oam_loop
  ld  a,$0
  ld  [hli],a
  dec bc
  ld  a,b
  or  c
  jr  nz,.clear_oam_loop
  ret

CLEAR_RAM:
  ld  hl,$C100
  ld  bc,$A0
.clear_ram_loop
  ld  a,$0
  ld  [hli],a
  dec bc
  ld  a,b
  or  c
  jr  nz,.clear_ram_loop
  ret

;load HL with pointer
;load BC with count
LOAD_TILES:
  ld  de,_VRAM
  push hl

.load_tiles_loop
  ;wait for hblank
  ld  hl,rSTAT
  bit 1,[hl]
  jr  nz,.load_tiles_loop
  pop hl

  ld  a,[hli]
  push hl

  ld  [de],a
  inc de
  dec bc
  ld  a,b
  or  c
  jr  nz,.load_tiles_loop
  
  pop hl

  ret

;load HL with pointer
;load BC with count
LOAD_MAP:
  ld  de,_SCRN0
  push hl

.load_map_loop
  ;wait for hblank
  ld  hl,rSTAT
  bit 1,[hl]
  jr  nz,.load_map_loop
  pop hl
  
  ;inc hl and store it
  ld  a,[hli]
  push hl
  
  ;load to vram
  ld  [de],a
  inc de
  dec bc
  ld  a,b
  or  c
  jr  nz,.load_map_loop
  
  pop hl
  ret

;gets tile value at index d = x, e = y
;b = tile, a = tile 2 right of b
GET_TILE:
  push bc
  ld  hl,GAME_MAP_DATA

  ;backup y
  ld  b,e
  
  ;move across x bytes
  ld  e,d
  ld  d,0
  add hl,de
  ld  e,b

.loop_y
  ;move down y*32 bytes
  dec e
  jr  nz,.add_y
  jp  .end

.add_y
  ld  bc,32
  add hl,bc
  jp  .loop_y

.end
  ;check for floor or wall?
  pop bc
  ld  a,c
  cp  0
  jr  z,.floor

.wall
  ld  a,[hl]
  ld  bc,64
  add hl,bc
  ld  b,a
  ld  a,[hl]
  jr  .fin

.floor
  ;get tile value
  ld  a,[hli]
  ld  b,a
  ld  a,[hl]
.fin
  ret

READ_JOYPAD:
  ;select dpad
  ld  a,%00100000

  ;takes a few cycles to get accurate reading
  ld  [rP1],a
  ld  a,[rP1]
  ld  a,[rP1]
  ld  a,[rP1]
  ld  a,[rP1]
  
  ;complement a
  cpl

  ;select dpad buttons
  and %00001111
  swap a
  ld  b,a

  ;select other buttons
  ld  a,%00010000

  ;a few cycles later..
  ld  [rP1],a  
  ld  a,[rP1]
  ld  a,[rP1]
  ld  a,[rP1]
  ld  a,[rP1]
  cpl
  and %00001111
  or  b
  
  ;you get the idea
  ld  b,a
  ld  a,[joypad_down]
  cpl
  and b
  ld  [joypad_pressed],a
  ld  a,b
  ld  [joypad_down],a
  ret

JOY_RIGHT:
  and %00010000
  cp  %00010000
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_LEFT:
  and %00100000
  cp  %00100000
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_UP:
  and %01000000
  cp  %01000000
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_DOWN:
  and %10000000
  cp  %10000000
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_A:
  and %00000001
  cp  %00000001
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_B:
  and %00000010
  cp  %00000010
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_SELECT:
  and %00000100
  cp  %00000100
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_START:
  and %00001000
  cp  %00001000
  jp  nz,JOY_FALSE
  ld  a,$1
  ret
JOY_FALSE:
  ld  a,$0
  ret

INIT_MUSIC:
  ld  a,MusicBank
  ld  [rROMB0],a
  call Player_Initialize
  ret

;load song number into b
LOAD_SONG:
  ld  a,MusicBank
  ld  [rROMB0],a
  call Player_MusicStart

  ld  a,b
  call Player_SongSelect
  
  ;play tick
  ld  a,MusicBank
  ld  [rROMB0],a
  call Player_MusicUpdate
  
  ret

PLAY_MUSIC:
  ld  a,[SongTick]
  cp  1
  jr  nz,.con
  ret
  
.con
  ;play tick
  ld  a,MusicBank
  ld  [rROMB0],a
  call Player_MusicUpdate

  ret

STOP_MUSIC:
  ld  a,MusicBank
  ld  [rROMB0],a
  call Player_MusicStop
  ret

CAM_OFFSET_START:
  ld  a,[cam_x]
  ld  d,a
  ld  a,[cam_y]
  ld  e,a

  ;40 OAM sprites at $C100
  ld  hl,$C100
  ld  c,40

.loop
  
  ;y offset
  ld  a,[hl]
  sub e
  ld  [hli],a

  ;x offset
  ld  a,[hl]
  sub d
  ld  [hli],a
  
  ;skip flags and tile
  inc hl
  inc hl

  ;decrease counter
  dec c
  jr  nz,.loop
  ret

CAM_OFFSET_END:
  ld  a,[cam_x]
  ld  d,a
  ld  a,[cam_y]
  ld  e,a

  ;40 OAM sprites at $C100
  ld  hl,$C100
  ld  c,40

.loop
  
  ;y offset
  ld  a,[hl]
  add e
  ld  [hli],a

  ;x offset
  ld  a,[hl]
  add d
  ld  [hli],a
  
  ;skip flags and tile
  inc hl
  inc hl

  ;decrease counter
  dec c
  jr  nz,.loop
  ret