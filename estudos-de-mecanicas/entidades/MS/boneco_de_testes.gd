extends CharacterBody2D

# ===============================
# ESTADOS
# ===============================

enum State { IDLE, RUN, JUMP, FALL, HIT, DEAD }
var state: State = State.IDLE

# ===============================
# CONFIGURAÇÃO
# ===============================

@export var move_speed := 120.0
@export var jump_force := -320.0
@export var gravity_force := 900.0
@export var max_life := 3

var life := max_life
var facing := 1

@onready var cam = $Camera2D

# ===============================
# LOOP PRINCIPAL
# ===============================

func _physics_process(delta):
	if state == State.DEAD:
		return

	apply_gravity(delta)
	handle_movement()
	update_state()
	
	move_and_slide()
	
	#cam.offset.x = facing * 80 #ajuste de camera


func _process(delta):
	$Node2D/AnimatedSprite2D.play(state_name())


# ===============================
# UTIL
# ===============================

func state_name():
	return State.keys()[state].to_lower()


# ===============================
# FÍSICA
# ===============================

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_force * delta
	else:
		if velocity.y > 0:
			velocity.y = 0


func handle_movement():
	var input_dir = Input.get_axis("ui_left", "ui_right")
	
	if input_dir != 0:
		velocity.x = input_dir * move_speed
		facing = sign(input_dir)
		
		# 👇 FLIP CORRETO (somente sprite)
		$Node2D/AnimatedSprite2D.flip_h = -facing < 0
		
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed * 0.2)
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force


# ===============================
# ESTADOS
# ===============================

func update_state():
	if state == State.HIT:
		return

	if not is_on_floor():
		if velocity.y < 0:
			state = State.JUMP
		else:
			state = State.FALL
	else:
		if abs(velocity.x) > 5:
			state = State.RUN
		else:
			state = State.IDLE


# ===============================
# VIDA
# ===============================

func take_damage(amount):
	if state == State.DEAD:
		return
		
	life -= amount
	state = State.HIT
	
	if life <= 0:
		die()
	else:
		await get_tree().create_timer(0.2).timeout
		state = State.IDLE


func die():
	state = State.DEAD
	velocity = Vector2.ZERO
	print("Boneco morreu")


# ===============================
# DETECÇÃO DE DANO
# ===============================

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_attack"):
		take_damage(1)
