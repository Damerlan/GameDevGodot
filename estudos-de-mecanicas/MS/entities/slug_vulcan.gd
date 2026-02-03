extends CharacterBody2D

@export var base_atlas: Texture2D
@export var move_speed: float = 100.0

@onready var base: Sprite2D = $Base

# =====================================================
# ESTADOS
# =====================================================

enum State { IDLE, RUN, JUMP, HIT }
var current_state: State = State.IDLE

# =====================================================
# BIBLIOTECA DE ANIMAÇÕES
# =====================================================

var animations = {
	"idle": [
		Rect2(10.0, 1438.0, 60.0, 45.0),
	Rect2(75.0, 1440.0, 60.0, 43.0),
	Rect2(140.0, 1438.0, 60.0, 45.0),
	Rect2(205.0, 1437.0, 65.0, 46.0),
	Rect2(275.0, 1444.0, 70.0, 39.0),
	],

	"run": [
		Rect2(10.0, 98.0, 60.0, 56.0),
		Rect2(75.0, 99.0, 60.0, 55.0),
		Rect2(140.0, 100.0, 61.0, 54.0),
		Rect2(206.0, 99.0, 61.0, 55.0),
		Rect2(272.0, 98.0, 59.0, 56.0),
		Rect2(336.0, 99.0, 61.0, 55.0),
		Rect2(402.0, 101.0, 62.0, 53.0),
		Rect2(469.0, 100.0, 62.0, 54.0),
		Rect2(536.0, 99.0, 61.0, 55.0),
		Rect2(602.0, 101.0, 62.0, 53.0),
		Rect2(669.0, 100.0, 60.0, 54.0),
		Rect2(734.0, 100.0, 60.0, 54.0),
		Rect2(799.0, 100.0, 61.0, 54.0),
		Rect2(865.0, 100.0, 61.0, 54.0),
		Rect2(931.0, 100.0, 59.0, 54.0),
		Rect2(995.0, 100.0, 61.0, 54.0),
		Rect2(1061.0, 99.0, 62.0, 55.0),
		Rect2(1128.0, 99.0, 62.0, 55.0),
		Rect2(1195.0, 100.0, 61.0, 54.0),
		Rect2(1261.0, 99.0, 62.0, 55.0),
	],

	"hit": [
		Rect2(10.0, 1559.0, 66.0, 57.0),
		Rect2(82.0, 1556.0, 69.0, 60.0),
		Rect2(157.0, 1554.0, 74.0, 62.0),
		Rect2(237.0, 1553.0, 61.0, 63.0),
		Rect2(301.0, 1557.0, 16.0, 16.0),
		Rect2(325.0, 1553.0, 61.0, 63.0),
		Rect2(416.0, 1552.0, 62.0, 64.0),
		Rect2(483.0, 1553.0, 62.0, 63.0),
		Rect2(550.0, 1555.0, 63.0, 61.0),
		Rect2(618.0, 1558.0, 63.0, 58.0),
		Rect2(686.0, 1561.0, 62.0, 55.0),
		Rect2(753.0, 1563.0, 61.0, 53.0),
		Rect2(819.0, 1565.0, 62.0, 51.0),
		Rect2(886.0, 1566.0, 62.0, 50.0),
	],

	"jump": [
		Rect2(10.0, 580.0, 55.0, 61.0),
		Rect2(70.0, 578.0, 55.0, 64.0),
		Rect2(130.0, 576.0, 53.0, 70.0),
		Rect2(188.0, 575.0, 53.0, 71.0),
	]
}

# =====================================================
# CONTROLE DE ANIMAÇÃO
# =====================================================

var anim_timer := 0.0
var anim_speed := 0.15
var anim_frame := 0
var current_anim_name := "idle"

# =====================================================
# READY
# =====================================================

func _ready():
	setup_sprite()
	play_animation("idle")

# =====================================================
# PHYSICS
# =====================================================

func _physics_process(delta):
	handle_movement(delta)
	update_animation(delta)

# =====================================================
# MOVIMENTO
# =====================================================

func handle_movement(delta):
	var direction := 0
	
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right"):
		direction += 1
	
	velocity.x = direction * move_speed
	move_and_slide()

	# troca estado
	if direction != 0:
		change_state(State.RUN)
	else:
		change_state(State.IDLE)

# =====================================================
# ESTADO
# =====================================================

func change_state(new_state: State):
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match current_state:
		State.IDLE:
			play_animation("idle")
		State.RUN:
			play_animation("run")
		State.JUMP:
			play_animation("jump")
		State.HIT:
			play_animation("hit")

# =====================================================
# SISTEMA DE ANIMAÇÃO
# =====================================================

func play_animation(name: String):
	if current_anim_name == name:
		return
	
	current_anim_name = name
	anim_frame = 0
	anim_timer = 0
	set_frame(animations[name][0])

func update_animation(delta):
	var frames = animations[current_anim_name]
	
	if frames.size() <= 1:
		return
	
	anim_timer += delta
	
	if anim_timer >= anim_speed:
		anim_timer = 0
		anim_frame = (anim_frame + 1) % frames.size()
		set_frame(frames[anim_frame])

func set_frame(rect: Rect2):
	var atlas := base.texture as AtlasTexture
	atlas.region = rect

# =====================================================
# SETUP
# =====================================================

func setup_sprite():
	var atlas := AtlasTexture.new()
	atlas.atlas = base_atlas
	atlas.region = Rect2(0,0,1,1)
	base.texture = atlas
