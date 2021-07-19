;-------------
; Player routines
;-------------
SECTION "Player",ROM0

PlayerSpawnX    equ 126
PlayerSpawnY    equ 180
PlayerFlags     equ %00000000
PlayerTileBegin equ 44
PlayerTileEnd   equ 88
PlayerTilePad   equ 9
PlayerTileWidth equ 3
PlayerOAMEnd    equ 36
PlayerWidth     equ 24
PlayerHeight    equ 24
PlayerGravity   equ 7
PlayerJumpVel   equ 4
PlayerVelCap    equ 6
PlayerHP        equ 5

PlayerFSpeed    equ 8
PlayerFShoot    equ 1
PlayerFRunStart equ 2
PlayerFRunEnd   equ 6
PlayerFJump     equ 6
PlayerFIdle     equ 7
PlayerFShootAir equ 8
PlayerFShootRun equ 9

PLAYER_LOAD:
  ;init a load of crap
  ld  a,PlayerSpawnY
  ld  [player_y],a
  ld  a,PlayerSpawnX
  ld  [player_x],a
  ld  a,PlayerFJump
  ld  [player_frame],a
  ld  a,PlayerFRunStart
  ld  [player_fstart],a
  ld  a,PlayerFRunEnd
  ld  [player_fend],a
  xor a
  ld  [player_idle],a
  ld  [player_flags],a
  ld  [player_fcount],a
  ld  [player_gcount],a
  ld  [player_ground],a
  ld  [cam_x],a
  ld  [cam_y],a
  ld  [rSCX],a
  ld  [rSCY],a
  ld  a,1
  ld  [player_yvel],a
  ld  a,PlayerHP
  ld  [player_hp],a
  call INIT_BULLETS
  ret

PLAYER_DIE:
  ld  a,1
  ld  [game_over],a
  ret

PLAYER_HURT:
  ;play ssssht on ch4
  ld  a,%10000001
  ld  [rNR42],a
  ld  a,%01111011
  ld  [rNR43],a
  ld  a,%11111111
  ld  [rNR50],a
  ld  [rNR51],a
  ld  a,%10000000
  ld  [rNR44],a

  ;enable jump
  ld  a,[player_flags]
  or  2
  ld  [player_flags],a
  ld  a,PlayerJumpVel
  ld  [player_yvel],a
  ld  a,PlayerGravity
  dec a
  ld  [player_gcount],a

  ;reduce hp
  ld  a,[player_hp]
  dec a
  jr  z,.die
  ld  [player_hp],a
  jr  .end

.die
  call PLAYER_DIE

.end
  ret

PLAYER_SHOOT:
  ;check if we can shoot
  ld  a,[bullets_alive]
  cp  4
  jr  c,.shoot
  jr  .end

.shoot 
  ;check b press
  ld  a,[joypad_pressed]
  call JOY_B
  jr  nz,.end

  ;play boop on ch1
  ld  a,%10010110
  ld  [rNR10],a
  ld  a,%10000000
  ld  [rNR11],a
  ld  a,%01001001
  ld  [rNR12],a
  ld  a,%11111111
  ld  [rNR13],a
  ld  a,%10001101
  ld  [rNR14],a

  ;spawn bullet
  ld  a,[player_x]
  ld  [bspawn_x],a
  ld  a,[player_y]
  ld  [bspawn_y],a
  ld  a,[player_flags]
  ld  [bflags],a
  ld  a,%00000000
  ld  [bteam],a
  call SPAWN_BULLET
  ld  a,PlayerFShoot
  ld  [player_frame],a

  ;set air frame
  ld  a,[player_ground]
  cp  0
  jr  nz,.run_frame
  ld  a,PlayerFShootAir
  ld  [player_frame],a
  jr  .frame

.run_frame
  ld  a,[player_idle]
  cp  0
  jr  nz,.frame
  ld  a,PlayerFShootRun
  ld  [player_frame],a

.frame
  ;set shoot frame
  xor a
  ld  [player_fcount],a

.end
  ret


PLAYER_CHECK_TOP:
  ;de = player_y/8
  xor a
  ld  d,a
  ld  b,a
  ld  a,[player_y]
  sub 8
  ld  e,a
  ld  c,8
  call DIVIDE
  
  ;y tile index
  push de

  ;de = player_x/8
  xor a
  ld  d,a
  ld  b,a
  ld  a,[player_x]
  ;sub 8
  ld  e,a
  ld  c,8
  call DIVIDE

  ;d = x, e = y tile index
  ld  d,e
  pop bc
  ld  e,c

  ;get tile value at index
  ld  c,0
  call GET_TILE
  ret

PLAYER_CHECK_SIDE:
  ;de = player_y/8
  xor a
  ld  d,a
  ld  b,a
  ld  a,[player_y]
  sub 2
  ld  e,a
  ld  c,8
  push hl
  call DIVIDE
  pop hl
  
  ;y tile index
  push de

  ;de = player_x/8
  xor a
  ld  d,a
  ld  b,a

  ;if l 0 then right else left
  ld  a,l
  cp  0
  jr  z,.right

  ld  a,[player_x]
  sub 2
  jr  .con

.right
  ld  a,[player_x]
  add 10

.con
  ld  e,a
  ld  c,8
  call DIVIDE

  ;d = x, e = y tile index
  ld  d,e
  pop bc
  ld  e,c

  ;get tile value at index
  ld  c,1
  call GET_TILE
  ret  

PLAYER_MOVE:
  call PLAYER_SHOOT

  ;check dpad left
  ld  a,[joypad_down]
  call JOY_LEFT
  jr  z,.left

  ;check dpad left
  ld  a,[joypad_down]
  call JOY_RIGHT
  jr  z,.right

  ;set idle frame
  ld  a,1
  ld  [player_idle],a
  jr  .up

.left
  ;check left
  ld  l,1
  call PLAYER_CHECK_SIDE

  ;check if tile is empty
  cp  0
  jr  nz,.set_nonidle
  ld  a,b
  cp  0
  jr  nz,.set_nonidle

  ;move left
  ld  a,[player_x]
  sub 2
  ld  [player_x],a 
  ld  a,[player_flags]
  or  1
  ld  [player_flags],a
  jr  .set_nonidle

.right
  ;check right
  ld  l,0
  call PLAYER_CHECK_SIDE

  ;check if tile is empty
  cp  0
  jr  nz,.set_nonidle
  ld  a,b
  cp  0
  jr  nz,.set_nonidle

  ;move left
  ld  a,[player_x]
  add 2
  ld  [player_x],a
  ld  a,[player_flags]
  and 2
  ld  [player_flags],a

.set_nonidle
  xor a
  ld  [player_idle],a

.up
  ;check if grounded
  ld  a,[player_ground]
  cp  0
  jr  z,.end

  ;check dpad up
  ld  a,[joypad_pressed]
  call JOY_A
  jr  nz,.end

  ;play shzzt on ch4
  ld  a,%10110001
  ld  [rNR42],a
  ld  a,%01011111
  ld  [rNR43],a
  ld  a,%11111111
  ld  [rNR50],a
  ld  [rNR51],a
  ld  a,%10000000
  ld  [rNR44],a

  ;enable jump
  ld  a,[player_flags]
  or  2
  ld  [player_flags],a
  ld  a,PlayerJumpVel
  ld  [player_yvel],a
  ld  a,PlayerGravity
  dec a
  ld  [player_gcount],a

.end
  ret

PLAYER_CAM:
.camera
  ld  a,[player_x]
  sub 80
  jr  c,.zero_x
  jr  .cx

.zero_x
  xor a

.cx
  ld  [cam_x],a
  ld  [rSCX],a
  add 160
  jr  c,.max_x
  jr  .cy_start

.max_x
  ld  a,96
  ld  [cam_x],a
  ld  [rSCX],a

.cy_start
  ld  a,[player_y]
  sub 72
  jr  c,.zero_y
  jr  .cy

.zero_y
  xor a

.cy
  ld  [cam_y],a
  ld  [rSCY],a
  add 144
  jr  c,.max_y
  ret

.max_y
  ld  a,112
  ld  [cam_y],a
  ld  [rSCY],a
  ret

PLAYER_UPDATE:
  ;check game won
  ld  a,[game_won]
  cp  0
  jr  z,.update

  ld  a,[joypad_pressed]
  call JOY_START
  jr  nz,.update

  jp START

.update
  call PLAYER_MOVE
  call PLAYER_ANIMATE
  call UPDATE_BULLETS

.physics
  ;de = player_y/8
  xor a
  ld  d,a
  ld  b,a
  ld  a,[player_y]
  add 16
  ld  e,a
  ld  c,8
  call DIVIDE
  
  ;y tile index
  push de

  ;de = player_x/8
  xor a
  ld  d,a
  ld  b,a
  ld  a,[player_x]
  ;sub 6
  ld  e,a
  ld  c,8
  call DIVIDE

  ;d = x, e = y tile index
  ld  d,e
  pop bc
  ld  e,c

  ;get tile value at index
  ld  c,0
  call GET_TILE

  ;check if tile is empty
  cp  0
  jr  nz,.fall_stop_check
  ld  a,b
  cp  0
  jr  nz,.fall_stop_check
  ;jr  .fall_begin

.coll_top
  ;skip if falling
  ld  a,[player_flags]
  and 2
  jr  z,.fall_begin

  call PLAYER_CHECK_TOP
  cp  0
  jr  nz,.top_hit
  ld  a,b
  cp  0
  jr  nz,.top_hit
  jr  .fall_begin

.top_hit
  ;set falling
  ld  a,[player_flags]
  and 1
  ld  [player_flags],a
  ld  a,0
  ld  [player_yvel],a
  ld  a,PlayerGravity
  ld  [player_gcount],a

  jr  .fall_begin

.fall_stop_check
  ;only stop when falling down
  ld  a,[player_flags]
  and 2
  jr  z,.stop_fall


.fall_begin
  ;set not grounded
  xor a
  ld  [player_ground],a
  
  ;cap velocity
  ld  a,[player_yvel]
  cp  PlayerVelCap
  jr  nc,.cap_yvel
  jr  .dont_cap

.cap_yvel
  ld  a,PlayerVelCap
  ld  [player_yvel],a

.dont_cap
  ;check if we can inc yvel
  ld  a,[player_gcount]
  cp  PlayerGravity
  jr  nz,.fall

  ;check if falling up?
  ld  a,[player_flags]
  and 2
  jr  z,.down_vel

  ;decrease up velocity?
  ld  a,[player_yvel]
  dec a
  ld  [player_yvel],a

  ;flip gravity?wat
  jr  nz,.done_vel
  ld  a,[player_flags]
  and 1
  ld  [player_flags],a
  jr  .done_vel

.down_vel
  ;increase velocity
  ld  a,[player_yvel]
  inc a
  ld  [player_yvel],a

.done_vel
  ;reset counter
  xor a
  ld  [player_gcount],a

.fall
  ld  a,[player_yvel]
  ld  b,a

  ;check if falling up?
  ld  a,[player_flags]
  and 2
  jr  z,.down

  ;fall up
  ld  a,[player_y]
  sub b
  jr  .add

.down
  ;fall down
  ld  a,[player_y]
  add b

.add
  ld  [player_y],a
  jr .end

.stop_fall
  ;stop falling down
  xor a
  ld  [player_yvel],a
  ld  a,PlayerGravity
  dec a
  ld  [player_gcount],a
  ld  a,[player_flags]
  and 1
  ld  [player_flags],a

  ;dont set ground if already grounded
  ld  a,[player_ground]
  cp  0
  jr  nz,.snap_start

  ld  a,1
  ld  [player_ground],a

.snap_start
  ;snap to surface
  xor a
  ld  d,a
  ld  b,a
  ld  c,8
  xor a
  ld  a,[player_y]
  ld  e,a
  call DIVIDE
  ld  c,e
  xor a
.snap_loop
  add a,8
  dec c
  jr  nz,.snap_loop
  ld  [player_y],a

.end
  ret

PLAYER_ANIMATE:
  ;only animate every x frames
  ld  a,PlayerFSpeed
  ld  b,a
  ld  a,[player_fcount]
  cp  b
  jr  nz,.end

  ;check if not grounded
  ld  a,[player_ground]
  cp  0
  jr  z,.set_jump
  
  ;check if idle
  ld  a,[player_idle]
  cp  0
  jr  nz,.set_idle

  ld  a,PlayerFRunStart
  ld  [player_fstart],a

.do_it
  ;reset timer
  xor a
  ld  [player_fcount],a
  
  ;do the animate thing
  ld  a,[player_frame]
  inc a
  ld  [player_frame],a
  ld  a,[player_fend]
  ld  b,a
  ld  a,[player_frame]
  cp  b
  jr  z,.reset
  ld  a,[player_frame]
  cp  b
  jr  nc,.reset
  jr  .end

.reset
  ld  a,[player_fstart]
  ld  [player_frame],a
  jr  .end

.set_jump
  ld  a,PlayerFJump
  ld  [player_frame],a
  ld  a,PlayerFSpeed-1
  ld  [player_fcount],a
  jr  .end

.set_idle
  ld  a,PlayerFIdle
  ld  [player_frame],a
  xor a
  ld  [player_fcount],a

.end
  call PLAYER_OAM

  ret

PLAYER_OAM:
  ;load the first tile addr
  ld  a,PlayerTileBegin
  ld  [player_tile],a

  ;frame number
  ld  a,[player_frame]
  ld  b,a

.loop
  ;for each frame value
  ld  a,b
  dec a
  ld  b,a
  jr  nz,.next_frame
  jr  .check_flip

.next_frame
  ;add padding for each tile index
  ld  a,[player_tile]
  add a,PlayerTilePad
  ld  [player_tile],a
  jr  .loop

.check_flip
  ;check flags
  ld  a,[player_flags]
  and 1
  jr  z,.set_tiles

  ;offset tile value
  ld  a,[player_tile]
  add a,2
  ld  [player_tile],a

.set_tiles
  ;begin setting oam data
  ld  a,[player_tile]
  ld  b,a
  add PlayerTilePad
  ld  e,a

  ld  hl,player_sprite

  ;c is y counter
  ;d is x counter
  ld  c,0
  ld  d,0
  xor a
  ld [arb_counter],a

  ;set temp vars
  ld  a,[player_y]
  ld  [player_y_temp],a
  ld  a,[player_x]
  ld  [player_x_temp],a

.loop_set
  ;check if we are on a new row
  ld  a,c
  cp  PlayerTileWidth
  jr  nz,.set_y

  ;offset y
  ld  a,[player_y_temp]
  add a,8
  ld  [player_y_temp],a
  
  ;reset c
  xor a
  ld  c,a

.set_y
  ;y position
  ld  a,[player_y_temp]
  ld  [hli],a

  ;inc y counter
  ld  a,c
  inc a
  ld  c,a

  ld  a,d
  cp  PlayerTileWidth
  jr  nz,.set_x

  ld  d,0
  ld  a,[player_x]
  ld  [player_x_temp],a

.set_x
  ;x position
  ld  a,[player_x_temp]
  ld  [hli],a

  ;offset x
  ld  a,d
  inc a
  ld  d,a
  ld  a,[player_x_temp]
  add a,8
  ld  [player_x_temp],a

  ;check flags
  ld  a,[player_flags]
  and 1
  jr  z,.dont_flip

.flip
  ;tile
  ld  a,b
  ld  [hli],a
  dec a
  ld  b,a

  ;check if we need to reset
  ld  a,[arb_counter]
  inc a
  ld  [arb_counter],a
  cp  3
  jr  nz,.flip_flags

  ;reset?
  xor a
  ld  [arb_counter],a
  ld  a,b
  add 6
  ld  b,a

.flip_flags
  ;flags
  ld  a,%00100000
  ld  [hli],a
  jr  .end

.dont_flip
  ;tile
  ld  a,b
  ld  [hli],a
  inc a
  ld  b,a

  ;flags
  xor a
  ld  [hli],a

.end
  ;are we done yet?
  ld  a,b
  cp  e
  jr  nz,.loop_set

  ret