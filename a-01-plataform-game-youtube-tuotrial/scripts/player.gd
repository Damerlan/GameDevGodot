extends CharacterBody2D

enum PlayerState{
	idle,
	walk,
	jump,
	duck,
	fall,
	slide
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


@export var max_speed = 150.0
@export var acceleration = 400
@export var deceleration = 400
@export var slide_deceleration = 100
const JUMP_VELOCITY = -300.0

var jump_count = 0
@export var max_jump_count = 2
var direction = 0
var status: PlayerState



func _ready() -> void:
	go_to_idle_state()#chama o idle state

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#switch dos status
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.fall:
			fall_state(delta)
		PlayerState.duck:
			duck_state(delta)
		PlayerState.slide:
			slide_state(delta)

	move_and_slide()#função do movimento

#funções de preparação
func go_to_idle_state():#status parado
	status = PlayerState.idle
	anim.play("idle")

func go_to_wakl_state():#status andando
	status = PlayerState.walk
	anim.play("walk")
	
func go_to_jump_state():#status pulando
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	
func go_to_fall_state():#status caindo
	status = PlayerState.fall
	anim.play("fall")

func go_to_slide_state():#status escorregando
	status = PlayerState.slide
	anim.play("slide")
	set_small_collider()
	
func exit_from_slide_state():#saida do status escorregando
	set_large_collider()

func go_to_duck_state():#status abaixado
	status = PlayerState.duck
	anim.play("duck")
	set_small_collider()

func exit_from_duck_state():#saida do status abaixado
	set_large_collider()

#funçoes de execução
func idle_state(delta):
	move(delta)
	if velocity.x != 0:
		go_to_wakl_state()
		return
	
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
	if Input.is_action_pressed("duck"):
		go_to_duck_state()
		return


func walk_state(delta):
	move(delta)
	if velocity.x == 0:
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
		
	if !is_on_floor():
		jump_count += 1
		go_to_fall_state()
		return
	
	if Input.is_action_just_pressed("duck"):
		go_to_slide_state()
		return

func jump_state(delta):
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	if velocity.y > 0:
		go_to_fall_state()
		return
	

func fall_state(delta):
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	
	if is_on_floor():#se esta no chão, volta pro estado idle
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_wakl_state()
		return

func duck_state(_delta):#abaixado
	update_direction()
	if Input.is_action_just_released("duck"):
		exit_from_duck_state()
		go_to_idle_state()
		return

func slide_state(delta):#escorregando
	velocity.x = move_toward(velocity.x, 0, slide_deceleration * delta)
	
	if Input.is_action_just_released("duck"):
		exit_from_slide_state()
		go_to_wakl_state()
		return
	
	if velocity.x == 0:
		exit_from_slide_state()
		go_to_duck_state()
		return


#função do movimento
func move(delta):
	update_direction()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	

func update_direction():
	direction = Input.get_axis("left", "right")
	
	#ajuste do flip
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false

func can_jump() -> bool:
	return jump_count < max_jump_count

func set_small_collider():
	collision_shape.shape.radius = 5
	collision_shape.shape.height = 10
	collision_shape.position.y = 3

func set_large_collider():
	collision_shape.shape.radius = 6
	collision_shape.shape.height = 16
	collision_shape.position.y = 0
	
