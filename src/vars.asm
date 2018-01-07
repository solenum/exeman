;-------------
; Ram variables etc
;-------------
SECTION "RAM Vars",WRAM0[$C000]

;vblank stuffs
vblank_flag:    DB
vblank_count:   DB

;       high -------------------------- low
;AND -> down/up/left/right/start/select/a/b
joypad_down:    DB
joypad_pressed: DB

;player vars
bullets_alive:DB
player_ground:DB
player_idle:  DB
player_fset:  DB
player_fcount:DB
player_gcount:DB
player_fstart:DB
player_fend:  DB
player_y:     DB
player_x:     DB
player_y_temp:DB
player_x_temp:DB
player_yvel:  DB
player_frame: DB
player_tile:  DB
player_flags: DB
player_hp:    DB

;enemy vars
enemy_ground:DB
enemy_idle:  DB
enemy_fset:  DB
enemy_fcount:DB
enemy_gcount:DB
enemy_fstart:DB
enemy_fend:  DB
enemy_y:     DB
enemy_x:     DB
enemy_y_temp:DB
enemy_x_temp:DB
enemy_yvel:  DB
enemy_frame: DB
enemy_tile:  DB
enemy_flags: DB
enemy_hp:    DB

;various things
cam_x:        DB
cam_y:        DB
arb_counter:  DB
arb_counterb: DB
bspawn_x:     DB
bspawn_y:     DB
bspawnb_x:    DB
bspawnb_y:    DB
bflags:       DB
bteam:        DB
game_over:    DB
game_won:     DB

;oam/object vars
SECTION "OAM Vars",WRAM0[$C100]

;player sprites (9)
player_sprite:  DS 36

;enemy sprite
enemy_sprite:  DS 36

;bullet sprites (4)
player_bullets: DS 16
