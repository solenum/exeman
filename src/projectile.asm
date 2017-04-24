;-------------
; handles projectile bullets
;-------------

BulletCount equ 16
BulletTile  equ $22
BulletVel   equ 4

INIT_BULLETS:
  xor a
  ld  [bullets_alive],a

  ld  c,BulletCount
  ld  hl,player_bullets
.loop
  ;clear bullet oam
  xor a
  ld  [hli],a
  dec c
  jr  nz,.loop
  ret

SPAWN_BULLET:
  ;start at tile
  ld  hl,player_bullets+2

  ;stride of 4
  ld  de,4
  ld  c,4

.loop
  ;load tile into a
  ld  a,[hl]

  ;is bullet idle?
  cp  0
  jr  z,.found

  ;nope skip to next bullet
  add hl,de

  ;try again
  dec c
  jr  nz,.loop
  jr  .end

.found
  ld  a,[bullets_alive]
  inc a
  ld  [bullets_alive],a

  dec hl
  dec hl

  ;set y
  ld  a,[bspawn_y]
  add 8
  ld  [hli],a

  ;set x
  ld  a,[bspawn_x]
  add 8
  ld  [hli],a

  ;set tile
  ld  a,[bflags]
  and 1
  add BulletTile
  ld  [hli],a

  ;set flags
  ld  a,[bteam]
  ld  [hl],a

.end
  ret

UPDATE_BULLETS:
  ;start at tile
  ld  hl,player_bullets+2

  ;stride of 4
  ld  de,4
  ld  c,4

.loop
  ;load tile into a
  ld  a,[hl]

  ;is bullet active?
  cp  0
  jr  nz,.found

  ;nope skip to next bullet
  add hl,de

  ;try again
  dec c
  jr  nz,.loop
  jp  .end

.found
  ;check team
  inc hl
  ld  a,[hl]
  dec hl
  dec hl
  dec hl

  cp  0
  jr  nz,.enemy
  ld  a,[enemy_x]
  ld  [bspawn_x],a
  ld  a,[enemy_y]
  ld  [bspawn_y],a
  xor a
  ld  [bteam],a
  ld  a,[hli]
  ld  [bspawnb_y],a
  ld  a,[hl]
  ld  [bspawnb_x],a

  jr  .coll_down

.enemy
  ld  a,[player_x]
  ld  [bspawn_x],a
  ld  a,[player_y]
  ld  [bspawn_y],a
  ld  a,1
  ld  [bteam],a
  ld  a,[hli]
  ld  [bspawnb_y],a
  ld  a,[hl]
  ld  [bspawnb_x],a
  

.coll_down
  ;check collision down
  ld  a,[bspawn_y]
  ld  b,a
  ld  a,[bspawnb_y]
  sub 24
  sub b
  jr  c,.coll_up
  jr  .con

.coll_up
  ;check collision up
  ld  a,[bspawn_y]
  ld  b,a
  ld  a,[bspawnb_y]
  sub b
  jr  nc,.coll_left
  jr  .con

.coll_left
  ;check collision down
  ld  a,[bspawn_x]
  ld  b,a
  ld  a,[bspawnb_x]
  ;sub 24
  sub b
  jr  nc,.coll_right
  jr  .con

.coll_right
  ;check collision down
  ld  a,[bspawn_x]
  ld  b,a
  ld  a,[bspawnb_x]
  sub 24
  sub b
  jr  c,.hit
  jr  .con

.hit
  ;check team
  ld  a,[bteam]
  cp  0
  jr  z,.enemy_hurt

  call PLAYER_HURT
  jr  .reset

.enemy_hurt
  call ENEMY_HURT
  jr  .reset

.con
  ;check direction
  inc hl
  ld  a,[hl]
  dec hl
  cp  BulletTile
  jr  nz,.left

  ;move right
  ld  a,[hl]
  add BulletVel

  ;check off screen
  jr  c,.reset

  ;set x
  ld  [hli],a

  jr  .done

.left
  ;move left
  ld  a,[hl]
  sub BulletVel

  ;check off screen
  jr  c,.reset

  ;set x
  ld  [hli],a

  jr  .done

.reset
  ;reset tile
  inc hl
  xor a
  ld  [hl],a

  ;decrase bullet counter
  ld  a,[bullets_alive]
  dec a
  ld  [bullets_alive],a

  add hl,de

  ;check counter
  dec c
  jp  nz,.loop
  jr  .end

.done
  ;go to next bullet
  add hl,de

  ;check counter
  dec c
  jp  nz,.loop
  jr  .end

.end
  ret