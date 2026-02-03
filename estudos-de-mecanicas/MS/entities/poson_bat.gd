extends CharacterBody2D

enum State { PATROL, CHASE, ESCAPE, DEAD }
var state: State = State.PATROL

@export var patrol_speed := 40.0
@export var chase_speed := 90.0
@export var escape_speed := 120.0
@export var amplitude := 12.0
@export var frequency := 6.0
@export var potion_scene: PackedScene

@export var patrol_distance := 120.0
var start_x := 0.0

var carrying_potion := true

var time_passed := 0.0
var direction := -1
var player: Node2D = null

func _ready():
	$DetectionArea.body_entered.connect(_on_detection_area_body_entered)
	$DetectionArea.body_exited.connect(_on_detection_area_body_exited)
	start_x = global_position.x


func _physics_process(delta):
	if state == State.DEAD:
		return

	time_passed += delta

	match state:
		State.PATROL:
			patrol(delta)
		State.CHASE:
			chase(delta)
		State.ESCAPE:
			escape(delta)

	move_and_slide()


# -----------------------
# PATROL
# -----------------------
func patrol(delta):
	velocity.x = direction * patrol_speed
	velocity.y = sin(time_passed * frequency) * amplitude

	if abs(global_position.x - start_x) > patrol_distance:
		direction *= -1


# -----------------------
# DETECÇÃO
# -----------------------
func _on_detection_area_body_entered(body):
	if body.is_in_group("player") and carrying_potion:
		player = body
		state = State.CHASE


func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		state = State.PATROL


# -----------------------
# CHASE
# -----------------------
func chase(delta):
	if player == null or not is_instance_valid(player):
		state = State.PATROL
		return

	var dir = sign(player.global_position.x - global_position.x)
	velocity.x = dir * chase_speed
	velocity.y = sin(time_passed * frequency) * amplitude

	if abs(player.global_position.x - global_position.x) < 8:
		drop_potion()


# -----------------------
# DROP
# -----------------------
func drop_potion():
	if not carrying_potion:
		return

	carrying_potion = false

	$PotionHolder/AnimatedSprite2D.visible = false

	var potion = potion_scene.instantiate()
	potion.global_position = $PotionHolder.global_position
	get_parent().add_child(potion)

	# Desativa detecção completamente
	$DetectionArea.monitoring = false
	player = null

	# Define direção atual para fugir
	direction = sign(velocity.x)
	if direction == 0:
		direction = -1

	state = State.ESCAPE


# -----------------------
# ESCAPE
# -----------------------
func escape(delta):
	velocity.x = direction * escape_speed
	velocity.y = sin(time_passed * frequency) * amplitude

	# Se sair da tela, morre
	if not $VisibleOnScreenNotifier2D.is_on_screen():
		queue_free()


# -----------------------
# MORTE (caso leve dano)
# -----------------------
func die():
	state = State.DEAD
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("death")


func _on_AnimatedSprite2D_animation_finished():
	if state == State.DEAD:
		queue_free()
