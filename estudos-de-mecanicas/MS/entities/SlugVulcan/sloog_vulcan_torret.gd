extends CharacterBody2D

enum MovementState {
	IDLE,
	ACCEL_FORWARD,
	STOP_FORWARD,
	DRIVE_BACKWARD,
	DRIVE_FORWARD,
	ACCEL_BACKWARD,
	STOP_BACKWARD
}

enum AirState {
	GROUND,
	JUMP,
	LAND
}

enum PostureState {
	NORMAL,
	CROUCH
}

var anims = {
	"idle": [
		Rect2(10.0, 24.0, 60.0, 56.0),
		Rect2(75.0, 24.0, 60.0, 56.0),
		Rect2(140.0, 24.0, 60.0, 56.0),
		],
	"drive_forward": [
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
	"accel_forward": [
		Rect2(10.0, 172.0, 60.0, 55.0),
	Rect2(75.0, 172.0, 59.0, 55.0),
	Rect2(139.0, 172.0, 59.0, 55.0),
	Rect2(203.0, 172.0, 60.0, 55.0),
	],
	"stop_backward": [
		Rect2(10.0, 232.0, 59.0, 55.0),
	Rect2(74.0, 232.0, 59.0, 55.0),
	Rect2(138.0, 232.0, 61.0, 55.0),
	Rect2(204.0, 232.0, 62.0, 55.0),
	],
	"accel_backward": [
		Rect2(10.0, 305.0, 60.0, 56.0),
	Rect2(75.0, 305.0, 60.0, 56.0),
	Rect2(140.0, 305.0, 60.0, 56.0),
	Rect2(205.0, 305.0, 60.0, 56.0),
	],
	"stop_forward": [
		Rect2(10.0, 366.0, 61.0, 56.0),
	Rect2(76.0, 366.0, 61.0, 56.0),
	Rect2(142.0, 366.0, 61.0, 56.0),
	Rect2(208.0, 366.0, 62.0, 56.0),
	],
	"shoot_1": [
		Rect2(10.0, 440.0, 60.0, 56.0),
	Rect2(75.0, 440.0, 60.0, 56.0),
	Rect2(140.0, 440.0, 59.0, 56.0),
	Rect2(204.0, 440.0, 59.0, 56.0),
	Rect2(268.0, 441.0, 58.0, 55.0),
	Rect2(331.0, 442.0, 58.0, 54.0),
	Rect2(394.0, 443.0, 58.0, 53.0),
	Rect2(457.0, 444.0, 59.0, 52.0),
	Rect2(521.0, 443.0, 58.0, 53.0),
	Rect2(584.0, 441.0, 58.0, 55.0),
	],
	"shoot_2": [
		 Rect2(10.0, 501.0, 60.0, 56.0),
	Rect2(75.0, 501.0, 60.0, 56.0),
	Rect2(140.0, 501.0, 60.0, 56.0),
	Rect2(205.0, 501.0, 59.0, 56.0),
	Rect2(269.0, 502.0, 59.0, 55.0),
	Rect2(333.0, 503.0, 58.0, 54.0),
	Rect2(396.0, 504.0, 59.0, 53.0),
	Rect2(460.0, 505.0, 59.0, 52.0),
	Rect2(524.0, 504.0, 59.0, 53.0),
	Rect2(588.0, 502.0, 59.0, 55.0),
	],
	"jump_1": [
		Rect2(10.0, 580.0, 55.0, 61.0),
	Rect2(70.0, 578.0, 55.0, 64.0),
	Rect2(130.0, 576.0, 53.0, 70.0),
	Rect2(188.0, 575.0, 53.0, 71.0),
	],
	"jump_2": [
		Rect2(10.0, 656.0, 55.0, 61.0),
	Rect2(70.0, 654.0, 55.0, 64.0),
	Rect2(130.0, 652.0, 53.0, 70.0),
	Rect2(188.0, 651.0, 53.0, 71.0),
	],
	"land_1": [
		Rect2(10.0, 740.0, 60.0, 56.0),
	Rect2(75.0, 742.0, 59.0, 54.0),
	Rect2(139.0, 744.0, 59.0, 52.0),
	Rect2(203.0, 746.0, 60.0, 50.0),
	],
	"land_2": [
		Rect2(10.0, 801.0, 60.0, 56.0),
	Rect2(75.0, 803.0, 59.0, 54.0),
	Rect2(139.0, 805.0, 59.0, 52.0),
	Rect2(203.0, 807.0, 60.0, 50.0),
	],
	"crouch": [
		Rect2(10.0, 876.0, 60.0, 57.0),
	Rect2(75.0, 876.0, 60.0, 57.0),
	Rect2(140.0, 875.0, 59.0, 58.0),
	Rect2(204.0, 876.0, 59.0, 57.0),
	Rect2(268.0, 880.0, 60.0, 53.0),
	Rect2(333.0, 883.0, 59.0, 50.0),
	Rect2(397.0, 889.0, 65.0, 44.0),
	Rect2(467.0, 892.0, 69.0, 41.0),
	Rect2(541.0, 893.0, 70.0, 40.0),
	],
	"crouch_2": [
		Rect2(75.0, 939.0, 60.0, 57.0),
	Rect2(140.0, 938.0, 59.0, 58.0),
	Rect2(268.0, 943.0, 60.0, 53.0),
	Rect2(397.0, 952.0, 65.0, 44.0),
	Rect2(467.0, 955.0, 69.0, 41.0),
	Rect2(541.0, 956.0, 70.0, 40.0),
	],
	"idle_crouch": [
		Rect2(10.0, 1014.0, 70.0, 40.0),
	Rect2(85.0, 1014.0, 70.0, 40.0),
	Rect2(160.0, 1014.0, 70.0, 40.0),
	],
	"drive_crouch": [
		Rect2(10.0, 1072.0, 70.0, 40.0),
	Rect2(85.0, 1073.0, 70.0, 39.0),
	Rect2(160.0, 1074.0, 70.0, 38.0),
	Rect2(235.0, 1073.0, 70.0, 39.0),
	Rect2(310.0, 1072.0, 69.0, 40.0),
	Rect2(384.0, 1073.0, 70.0, 39.0),
	Rect2(459.0, 1075.0, 71.0, 37.0),
	Rect2(535.0, 1074.0, 71.0, 38.0),
	Rect2(611.0, 1073.0, 70.0, 39.0),
	Rect2(686.0, 1075.0, 71.0, 37.0),
	Rect2(762.0, 1074.0, 70.0, 38.0),
	Rect2(837.0, 1074.0, 70.0, 38.0),
	Rect2(912.0, 1074.0, 70.0, 38.0),
	Rect2(987.0, 1074.0, 70.0, 38.0),
	Rect2(1062.0, 1074.0, 69.0, 38.0),
	Rect2(1136.0, 1074.0, 70.0, 38.0),
	Rect2(1211.0, 1073.0, 71.0, 39.0),
	Rect2(1287.0, 1073.0, 71.0, 39.0),
	Rect2(1363.0, 1074.0, 70.0, 38.0),
	Rect2(1438.0, 1073.0, 72.0, 39.0),
	],
	"accel_back_crouch": [
		Rect2(10.0, 1130.0, 69.0, 39.0),
	Rect2(84.0, 1130.0, 68.0, 39.0),
	Rect2(157.0, 1130.0, 68.0, 39.0),
	Rect2(230.0, 1130.0, 69.0, 39.0),
	],
	"stop_back_crouch": [
		Rect2(10.0, 1174.0, 69.0, 39.0),
	Rect2(84.0, 1174.0, 68.0, 39.0),
	Rect2(157.0, 1174.0, 69.0, 39.0),
	Rect2(231.0, 1174.0, 70.0, 39.0),
	],
}



#-------------------nucleo da maquina de estado-----
@export var base_atlas: Texture2D
@export var move_speed: float = 100.0

@onready var base: Sprite2D = $Base


var movement_state : MovementState = MovementState.IDLE
var air_state : AirState = AirState.GROUND
var posture_state : PostureState = PostureState.NORMAL

var is_shooting := false
var angle_variant := 1 # 1 ou 2 (downhill)

var current_anim := ""
var frame_index := 0
var frame_timer := 0.0
var frame_speed := 0.08



func _ready():
	setup_base_sprite()



func _physics_process(delta):
	update_states() # sua lógica de input
	
	# gravidade
	if not is_on_floor():
		velocity.y += 900 * delta
	
	velocity.x = Input.get_axis("ui_left", "ui_right") * 100
	move_and_slide()

	
	resolve_animation()# decide qual tocar.
	update_anim(delta)     # executa frames



func setup_base_sprite():
	var atlas := AtlasTexture.new()
	atlas.atlas = base_atlas
	atlas.region = Rect2(0, 0, 10, 10) # qualquer valor inicial
	base.texture = atlas


func resolve_animation():

	# ===== PRIORIDADE AR =====
	if air_state == AirState.JUMP:
		play_anim("jump_1" if angle_variant == 1 else "jump_2")
		return
	
	if air_state == AirState.LAND:
		play_anim("land_1" if angle_variant == 1 else "land_2")
		return

	# ===== SHOOT =====
	if is_shooting:
		play_anim("shoot_1" if angle_variant == 1 else "shoot_2")
		return

	# ===== CROUCH =====
	if posture_state == PostureState.CROUCH:
		match movement_state:
			MovementState.IDLE:
				play_anim("idle_crouch")
			MovementState.DRIVE_FORWARD:
				play_anim("drive_crouch")
			MovementState.ACCEL_BACKWARD:
				play_anim("accel_back_crouch")
			MovementState.STOP_BACKWARD:
				play_anim("stop_back_crouch")
		return

	# ===== NORMAL =====
	match movement_state:
		MovementState.IDLE:
			play_anim("idle")
		MovementState.DRIVE_FORWARD:
			play_anim("drive_forward")
		MovementState.ACCEL_FORWARD:
			play_anim("accel_forward")
		MovementState.STOP_FORWARD:
			play_anim("stop_forward")
		MovementState.DRIVE_BACKWARD:
			play_anim("drive_forward") # pode inverter se quiser
		MovementState.ACCEL_BACKWARD:
			play_anim("accel_backward")
		MovementState.STOP_BACKWARD:
			play_anim("stop_backward")




#--------------- funçoes de play animations

func play_anim(name: String):
	if current_anim == name:
		return
	
	current_anim = name
	frame_index = 0
	frame_timer = 0
	set_frame(anims[name][0])

func update_anim(delta):
	if current_anim == "":
		return
	
	var frames = anims[current_anim]
	if frames.size() <= 1:
		return
	
	frame_timer += delta
	if frame_timer >= frame_speed:
		frame_timer = 0
		frame_index = (frame_index + 1) % frames.size()
		set_frame(frames[frame_index])

#-----set frame
func set_frame(rect: Rect2):
	if base.texture == null:
		return
	
	var atlas := base.texture as AtlasTexture
	atlas.region = rect



func update_states():
	
	# =========================
	# INPUT
	# =========================
	var input_dir := Input.get_axis("ui_left", "ui_right")
	var jump_pressed := Input.is_action_just_pressed("jump")
	var crouch_pressed := Input.is_action_pressed("ui_down")
	is_shooting = Input.is_action_pressed("shoot")

	# MOVIMENTO REAL
	velocity.x = input_dir * move_speed

	if jump_pressed and is_on_floor():
		velocity.y = -350  # ajuste depois
		
	# =========================
	# POSTURA
	# =========================
	if crouch_pressed and is_on_floor():
		posture_state = PostureState.CROUCH
	else:
		posture_state = PostureState.NORMAL

	# =========================
	# AR / CHÃO
	# =========================
	if not is_on_floor():
		if velocity.y < 0:
			air_state = AirState.JUMP
		else:
			air_state = AirState.LAND
	else:
		air_state = AirState.GROUND

	# =========================
	# MOVIMENTO HORIZONTAL
	# =========================
	
	if air_state != AirState.GROUND:
		return  # no ar não troca estado de corrida

	if input_dir == 0:
		# sem input → desaceleração
		if abs(velocity.x) > 10:
			if velocity.x > 0:
				movement_state = MovementState.STOP_FORWARD
			else:
				movement_state = MovementState.STOP_BACKWARD
		else:
			movement_state = MovementState.IDLE
	
	else:
		# com input
		
		if input_dir > 0:
			if velocity.x < 0:
				movement_state = MovementState.ACCEL_FORWARD
			else:
				movement_state = MovementState.DRIVE_FORWARD
		
		elif input_dir < 0:
			if velocity.x > 0:
				movement_state = MovementState.ACCEL_BACKWARD
			else:
				movement_state = MovementState.DRIVE_BACKWARD





#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0


#func _physics_process(delta: float) -> void:
#	# Add the gravity.
#	if not is_on_floor():
#		velocity += get_gravity() * delta

#	# Handle jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction := Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)

#	move_and_slide()
