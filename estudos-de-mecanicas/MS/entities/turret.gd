extends Node2D

@export var fire_rate: float = 0.15
@export var bullet_scene: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var muzzle: Marker2D = $Muzzle

const TOTAL_FRAMES := 32 # só os primeiros 32
var shoot_timer := 0.0
var current_direction := Vector2.RIGHT

func _process(delta):
	handle_input_direction()
	update_rotation_and_frame()
	auto_shoot(delta)

# --------------------------------------------------
# DIREÇÃO ESTILO ARCADE (8 DIREÇÕES)
# --------------------------------------------------

func handle_input_direction():
	var dir := Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	
	if dir != Vector2.ZERO:
		current_direction = dir.normalized()

# --------------------------------------------------
# ROTACIONA E DEFINE FRAME
# --------------------------------------------------

func update_rotation_and_frame():
	var angle = current_direction.angle()
	rotation = angle
	
	# converte ângulo em frame
	var normalized = wrapf(angle, 0, TAU) / TAU
	var frame = int(normalized * TOTAL_FRAMES) % TOTAL_FRAMES
	
	sprite.frame = frame

# --------------------------------------------------
# TIRO AUTOMÁTICO
# --------------------------------------------------

func auto_shoot(delta):
	shoot_timer += delta
	
	if shoot_timer >= fire_rate:
		shoot_timer = 0
		shoot()

func shoot():
	if bullet_scene == null:
		return
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = muzzle.global_position
	bullet.rotation = global_rotation
