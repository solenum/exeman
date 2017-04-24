;-------------
; Enemy routines
;-------------
SECTION "Enemy",ROM0

EnemySpawnX    equ 126
EnemySpawnY    equ 12
EnemyFlags     equ %00000000
EnemyTileBegin equ 44
EnemyTileEnd   equ 88
EnemyTilePad   equ 9
EnemyTileWidth equ 3
EnemyOAMEnd    equ 36
EnemyWidth     equ 24
EnemyHeight    equ 24
EnemyGravity   equ 14
EnemyJumpVel   equ 4
EnemyVelCap    equ 6
EnemyHP        equ 15

EnemyFSpeed    equ 8
EnemyFShoot    equ 1
EnemyFRunStart equ 2
EnemyFRunEnd   equ 6
EnemyFJump     equ 6
EnemyFIdle     equ 7
EnemyFShootAir equ 8
EnemyFShootRun equ 9

ENEMY_DIE:
  ld  a,1
  ld  [game_won],a
  xor a
  ld  hl,enemy_sprite
  ld  c,EnemyOAMEnd
.loop
  ld  [hli],a
  dec c
  jr  nz,.loop
  ret

ENEMY_HURT:
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
  ld  a,[enemy_flags]
  or  2
  ld  [enemy_flags],a
  ld  a,EnemyJumpVel
  ld  [enemy_yvel],a
  ld  a,EnemyGravity
  dec a
  ld  [enemy_gcount],a

  ;reduce hp
  ld  a,[enemy_hp]
  dec a
  jr  z,.die
  ld  [enemy_hp],a
  jr  .end

.die
  call ENEMY_DIE

.end
  ret

ENEMY_LOAD:
  ;init a load of crap
  ld  a,EnemySpawnY
  ld  [enemy_y],a
  ld  a,EnemySpawnX
  ld  [enemy_x],a
  ld  a,EnemyFJump
  ld  [enemy_frame],a
  ld  a,EnemyFRunStart
  ld  [enemy_fstart],a
  ld  a,EnemyFRunEnd
  ld  [enemy_fend],a
  xor a
  ld  [enemy_idle],a
  ld  [enemy_flags],a
  ld  [enemy_fcount],a
  ld  [enemy_gcount],a
  ld  [enemy_ground],a
  ld  a,1
  ld  [enemy_yvel],a
  ld  a,EnemyHP
  ld  [enemy_hp],a
  ret

ENEMY_SHOOT:
  ;check if we can shoot
  ld  a,[bullets_alive]
  cp  1
  jr  c,.shoot
  jr  .end

.shoot
  ;**random** number
  ld hl,$FF04
  ld a,[hl]
  cp 240
  jr c,.check_align
  ld [hl],a

.check_align
  ;shoot if inline with player
  ld  a,[player_y]
  sub 16
  ld  b,a
  ld  a,[enemy_y]
  cp  b
  jr  c,.end
  ld  a,[player_y]
  add 16
  ld  b,a
  ld  a,[enemy_y]
  cp  b
  jr  nc,.end

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
  ld  a,[enemy_x]
  ld  [bspawn_x],a
  ld  a,[enemy_y]
  ld  [bspawn_y],a
  ld  a,[enemy_flags]
  ld  [bflags],a
  ld  a,%01000000
  ld  [bteam],a
  call SPAWN_BULLET
  ld  a,EnemyFShoot
  ld  [enemy_frame],a

  ;set air frame
  ld  a,[enemy_ground]
  cp  0
  jr  nz,.run_frame
  ld  a,EnemyFShootAir
  ld  [enemy_frame],a
  jr  .frame

.run_frame
  ld  a,[enemy_idle]
  cp  0
  jr  nz,.frame
  ld  a,EnemyFShootRun
  ld  [enemy_frame],a

.frame
  ;set shoot frame
  xor a
  ld  [enemy_fcount],a

.end
  ret


ENEMY_CHECK_TOP:
  ;de = enemy_y/8
  xor a
  ld  d,a
  ld  b,a
  ld  a,[enemy_y]
  sub 8
  ld  e,a
  ld  c,8
  call DIVIDE
  
  ;y tile index
  push de

  ;de = enemy_x/8
  xor a
  ld  d,a
  ld  b,a
  ld  a,[enemy_x]
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

ENEMY_CHECK_SIDE:
  ;de = enemy_y/8
  xor a
  ld  d,a
  ld  b,a
  ld  a,[enemy_y]
  sub 2
  ld  e,a
  ld  c,8
  push hl
  call DIVIDE
  pop hl
  
  ;y tile index
  push de

  ;de = enemy_x/8
  xor a
  ld  d,a
  ld  b,a

  ;if l 0 then right else left
  ld  a,l
  cp  0
  jr  z,.right

  ld  a,[enemy_x]
  sub 2
  jr  .con

.right
  ld  a,[enemy_x]
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

ENEMY_MOVE:
  call ENEMY_SHOOT

  ld  a,[enemy_flags]
  and 1
  jr  z,.right

.left
  ;check left
  ld  l,1
  call ENEMY_CHECK_SIDE

  ;check if tile is empty
  cp  0
  jr  nz,.set_dir
  ld  a,b
  cp  0
  jr  nz,.set_dir

  ;move left
  ld  a,[enemy_x]
  sub 1
  ld  [enemy_x],a 
  ld  a,[enemy_flags]
  or  1
  ld  [enemy_flags],a
  jr  .up

.right
  ;check right
  ld  l,0
  call ENEMY_CHECK_SIDE

  ;check if tile is empty
  cp  0
  jr  nz,.set_dir
  ld  a,b
  cp  0
  jr  nz,.set_dir

  ;move right
  ld  a,[enemy_x]
  add 1
  ld  [enemy_x],a
  ld  a,[enemy_flags]
  and 2
  ld  [enemy_flags],a
  jr  .up

.set_dir
  ld  a,[enemy_flags]
  xor 1
  ld  [enemy_flags],a

.up
  ;check if grounded
  ld  a,[enemy_ground]
  cp  0
  jr  z,.end

  ;random** number
  ld hl,$FF04
  ld a,[hl]
  cp 238
  jr c,.end

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
  ld  a,[enemy_flags]
  or  2
  ld  [enemy_flags],a
  ld  a,EnemyJumpVel
  ld  [enemy_yvel],a
  ld  a,EnemyGravity
  dec a
  ld  [enemy_gcount],a

.end
  ret

.max_y
  ld  a,112
  ld  [cam_y],a
  ld  [rSCY],a
  ret

ENEMY_UPDATE:
  ld  a,[game_won]
  cp  0
  jr  z,.update
  ret

.update
  call ENEMY_MOVE
  call ENEMY_ANIMATE

.physics
  ;de = enemy_y/8
  xor a
  ld  d,a
  ld  b,a
  ld  a,[enemy_y]
  add 16
  ld  e,a
  ld  c,8
  call DIVIDE
  
  ;y tile index
  push de

  ;de = enemy_x/8
  xor a
  ld  d,a
  ld  b,a
  ld  a,[enemy_x]
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
  ld  a,[enemy_flags]
  and 2
  jr  z,.fall_begin

  call ENEMY_CHECK_TOP
  cp  0
  jr  nz,.top_hit
  ld  a,b
  cp  0
  jr  nz,.top_hit
  jr  .fall_begin

.top_hit
  ;set falling
  ld  a,[enemy_flags]
  and 1
  ld  [enemy_flags],a
  ld  a,0
  ld  [enemy_yvel],a
  ld  a,EnemyGravity
  ld  [enemy_gcount],a

  jr  .fall_begin

.fall_stop_check
  ;only stop when falling down
  ld  a,[enemy_flags]
  and 2
  jp  z,.stop_fall


.fall_begin
  ;check if grounded
  ld  a,[enemy_ground]
  cp  0
  jr  z,.fall_start

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
  ld  a,[enemy_flags]
  or  2
  ld  [enemy_flags],a
  ld  a,EnemyJumpVel
  ld  [enemy_yvel],a
  ld  a,EnemyGravity
  dec a
  ld  [enemy_gcount],a

.fall_start
  ;set not grounded
  xor a
  ld  [enemy_ground],a
  
  ;cap velocity
  ld  a,[enemy_yvel]
  cp  EnemyVelCap
  jr  nc,.cap_yvel
  jr  .dont_cap

.cap_yvel
  ld  a,EnemyVelCap
  ld  [enemy_yvel],a

.dont_cap
  ;check if we can inc yvel
  ld  a,[enemy_gcount]
  cp  EnemyGravity
  jr  nz,.fall

  ;check if falling up?
  ld  a,[enemy_flags]
  and 2
  jr  z,.down_vel

  ;decrease up velocity?
  ld  a,[enemy_yvel]
  dec a
  ld  [enemy_yvel],a

  ;flip gravity?wat
  jr  nz,.done_vel
  ld  a,[enemy_flags]
  and 1
  ld  [enemy_flags],a
  jr  .done_vel

.down_vel
  ;increase velocity
  ld  a,[enemy_yvel]
  inc a
  ld  [enemy_yvel],a

.done_vel
  ;reset counter
  xor a
  ld  [enemy_gcount],a

.fall
  ld  a,[enemy_yvel]
  ld  b,a

  ;check if falling up?
  ld  a,[enemy_flags]
  and 2
  jr  z,.down

  ;fall up
  ld  a,[enemy_y]
  sub b
  jr  .add

.down
  ;fall down
  ld  a,[enemy_y]
  add b

.add
  ld  [enemy_y],a
  jr .end

.stop_fall
  ;stop falling down
  xor a
  ld  [enemy_yvel],a
  ld  a,EnemyGravity
  dec a
  ld  [enemy_gcount],a
  ld  a,[enemy_flags]
  and 1
  ld  [enemy_flags],a

  ;dont set ground if already grounded
  ld  a,[enemy_ground]
  cp  0
  jr  nz,.snap_start

  ld  a,1
  ld  [enemy_ground],a

.snap_start
  ;snap to surface
  xor a
  ld  d,a
  ld  b,a
  ld  c,8
  xor a
  ld  a,[enemy_y]
  ld  e,a
  call DIVIDE
  ld  c,e
  xor a
.snap_loop
  add a,8
  dec c
  jr  nz,.snap_loop
  ld  [enemy_y],a

.end
  ret

ENEMY_ANIMATE:
  ;only animate every x frames
  ld  a,EnemyFSpeed
  ld  b,a
  ld  a,[enemy_fcount]
  cp  b
  jr  nz,.end

  ;check if not grounded
  ld  a,[enemy_ground]
  cp  0
  jr  z,.set_jump
  
  ;check if idle
  ld  a,[enemy_idle]
  cp  0
  jr  nz,.set_idle

  ld  a,EnemyFRunStart
  ld  [enemy_fstart],a

.do_it
  ;reset timer
  xor a
  ld  [enemy_fcount],a
  
  ;do the animate thing
  ld  a,[enemy_frame]
  inc a
  ld  [enemy_frame],a
  ld  a,[enemy_fend]
  ld  b,a
  ld  a,[enemy_frame]
  cp  b
  jr  z,.reset
  ld  a,[enemy_frame]
  cp  b
  jr  nc,.reset
  jr  .end

.reset
  ld  a,[enemy_fstart]
  ld  [enemy_frame],a
  jr  .end

.set_jump
  ld  a,EnemyFJump
  ld  [enemy_frame],a
  ld  a,EnemyFSpeed-1
  ld  [enemy_fcount],a
  jr  .end

.set_idle
  ld  a,EnemyFIdle
  ld  [enemy_frame],a
  xor a
  ld  [enemy_fcount],a

.end
  call ENEMY_OAM

  ret

ENEMY_OAM:
  ;load the first tile addr
  ld  a,EnemyTileBegin
  ld  [enemy_tile],a

  ;frame number
  ld  a,[enemy_frame]
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
  ld  a,[enemy_tile]
  add a,EnemyTilePad
  ld  [enemy_tile],a
  jr  .loop

.check_flip
  ;check flags
  ld  a,[enemy_flags]
  and 1
  jr  z,.set_tiles

  ;offset tile value
  ld  a,[enemy_tile]
  add a,2
  ld  [enemy_tile],a

.set_tiles
  ;begin setting oam data
  ld  a,[enemy_tile]
  ld  b,a
  add EnemyTilePad
  ld  e,a

  ld  hl,enemy_sprite

  ;c is y counter
  ;d is x counter
  ld  c,0
  ld  d,0
  xor a
  ld [arb_counter],a

  ;set temp vars
  ld  a,[enemy_y]
  ld  [enemy_y_temp],a
  ld  a,[enemy_x]
  ld  [enemy_x_temp],a

.loop_set
  ;check if we are on a new row
  ld  a,c
  cp  EnemyTileWidth
  jr  nz,.set_y

  ;offset y
  ld  a,[enemy_y_temp]
  add a,8
  ld  [enemy_y_temp],a
  
  ;reset c
  xor a
  ld  c,a

.set_y
  ;y position
  ld  a,[enemy_y_temp]
  ld  [hli],a

  ;inc y counter
  ld  a,c
  inc a
  ld  c,a

  ld  a,d
  cp  EnemyTileWidth
  jr  nz,.set_x

  ld  d,0
  ld  a,[enemy_x]
  ld  [enemy_x_temp],a

.set_x
  ;x position
  ld  a,[enemy_x_temp]
  ld  [hli],a

  ;offset x
  ld  a,d
  inc a
  ld  d,a
  ld  a,[enemy_x_temp]
  add a,8
  ld  [enemy_x_temp],a

  ;check flags
  ld  a,[enemy_flags]
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