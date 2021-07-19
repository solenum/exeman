;-------------
; ludumdare38 - bank0.asm
;-------------
; Includes
;-------------
	
	INCLUDE "hardware.asm"
  INCLUDE "header.asm"
	INCLUDE "tiles.asm"
  INCLUDE "map.asm"
  INCLUDE "vars.asm"
  INCLUDE "splash.asm"
  INCLUDE "game.asm"
  INCLUDE "player.asm"
  INCLUDE "enemy.asm"
  INCLUDE "math.asm"
  INCLUDE "projectile.asm"

;-------------
; Start
;-------------

SECTION "Program Start",ROM0[$150]
START:
  ;enable interrupts
  ei

  ;enable vblank interrupt
  ld  sp,$FFFE
  ld  a,IEF_VBLANK
	ld  [rIE],a

  ;LCD off
  ld  a,$0
  ldh [rLCDC],a
	ldh [rSTAT],a

  ;game on
  ld  [game_over],a
  ld  [game_won],a

  ;shade palettes
  ld  a,%11100100
  ldh [rBGP],a
  ldh [rOCPD],a
  ldh [rOBP0],a
  ldh [rOBP1],a

  ;clear everything
	call CLEAR_MAP
  call CLEAR_OAM
  call CLEAR_RAM

  ;load splash screen data
  ld  hl,SPLASH_TILE_DATA
  ld  bc,SPLASH_TILE_COUNT
  call LOAD_TILES
  ld  hl,SPLASH_MAP_DATA_A
  ld  bc,SPLASH_MAP_SIZE_A
  call LOAD_MAP

  ;init music
  call INIT_MUSIC
  ld  b,1
  call LOAD_SONG

  ;move DMA routine to HRAM
  call DMA_COPY

  ;turn on LCD, BG0, OBJ0, etc
  ld  a,%11010011
  ldh [rLCDC],a

  ;center splash logo
  ld  a,220
  ld  [rSCX],a

  ;put screen just below splash
  ld  a,25
  ld  [rSCY],a

INTRO_LOOP:
  call WAIT_VBLANK
  call PLAY_MUSIC
  call READ_JOYPAD
  jp SPLASH_INTRO

GAME_START:
  ;wait for start press
  call WAIT_VBLANK
  call READ_JOYPAD
  call PLAY_MUSIC
  ld  a,[joypad_down]
  call JOY_START
  jr  nz,GAME_START

  ;load the game stuffs
  call WAIT_VBLANK
  call GAME_LOAD

GAME_LOOP:
  call WAIT_VBLANK
  call PLAYER_CAM
  call READ_JOYPAD
  call PLAY_MUSIC
  call CAM_OFFSET_START
  call _HRAM
  call CAM_OFFSET_END
  call ENEMY_UPDATE
  call PLAYER_UPDATE

  ;check gameover
  ld  a,[game_over]
  cp  0
  jp  z,GAME_LOOP

  jp  START

;-------------
; Subroutines
;-------------
  INCLUDE "util.asm"

SPLASH_INTRO:
  ;y199 is our goal
  ld  a,[rSCY]
  ld  b,a
  ld  a,199
  cp  b
  jr  z,.done

  ;scroll logo down
  ld  a,[rSCY]
  sub a,3
  ld  [rSCY],a

  jp INTRO_LOOP

.done
  ;load rest of menu bg
  ld  hl,SPLASH_MAP_DATA_B
  ld  bc,SPLASH_MAP_SIZE_B

  ;adjust scroll y
  ld  a,[rSCY]
  add 16
  ld  [rSCY],a
  
  call LOAD_MAP

  ;start the game
  jp  GAME_START

GAME_LOAD:
  ;set pallets
  ld  a,%00100111
  ldh [rBGP],a
  ldh [rOCPD],a
  ldh [rOBP0],a
  ldh [rOBP1],a

  ;load game tiles
  call CLEAR_MAP
  ld  hl,GAME_TILE_DATA
  ld  bc,GAME_TILE_COUNT
  call LOAD_TILES

  ;load game map
  ld  hl,GAME_MAP_DATA
  ld  bc,GAME_MAP_SIZE
  call LOAD_MAP

  ;reset scroll
  xor a
  ld  [rSCX],a
  ld  a,150
  ld  [rSCY],a

  ;init the player
  call PLAYER_LOAD

  ;init the enemies
  call ENEMY_LOAD

  ret


;-------------
; Music shiz
;-------------
SECTION "Music",ROMX[$4000],BANK[MusicBank]

INCBIN "music.bin"

;$c7c0 - $c7ef player variables
SECTION "Reserved",WRAM0[$c7c0]
ds      $30
