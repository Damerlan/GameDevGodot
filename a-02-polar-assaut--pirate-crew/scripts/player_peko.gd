extends CharacterBody2D

#---------------------------------------------
# ENUM – Estados
#---------------------------------------------
enum PlayerState{
	idle,
	run,
	jump,
	hit,
	fall,
	death
}

#---------------------------------------------
# Nodes
#---------------------------------------------
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

#---------------------------------------------
# Variáveis exportáveis
#---------------------------------------------
@export var max_speed = 250
@export var move_speed := 160.0
@export var acceleration := 900.0
@export var deceleration := 1200.0
@export var jump_force := -600.0

#---------------------------------------------
# Internas
#---------------------------------------------
var status: PlayerState	#variável de status
var input_dir := 0.0

var JUMP_VELOCITY = -600.0
var SPEED = 80.0

#-----------funçoes do sistema e fisica------------------#
func _ready() -> void:
	go_to_idle_state()	#coloca o player em idle state

func _physics_process(delta: float) -> void:	#processo de fisica
	read_input()
	#gravidade
	if not is_on_floor():	#se o player nao está no chão
		velocity += get_gravity() * delta	#aplica o efeito de gravidade
	
	# --- State Machine ---
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.run:
			run_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.hit:
			hit_state(delta)
		PlayerState.fall:
			fall_state(delta)
		PlayerState.death:
			death_state(delta)
	#fim do Switch
	
	move_and_slide()#calcula a posição do player com base no movimento
	
	# Detectar queda depois do pulo
	if status != PlayerState.jump and not is_on_floor() and velocity.y > 0:
		go_to_fall_state()
	
		

#---#funçoes de preparação para o status do player-------#

func go_to_idle_state():#entrada idle state
	status = PlayerState.idle	 #define o estado
	anim.play("idle")	#define a animação

func go_to_run_state():#entrada run state (Caminhada)
	status = PlayerState.run
	anim.play("run")

func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY	#aplica a ação do pulo

func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall")

func go_to_hit_state():
	status = PlayerState.hit
	anim.play("hit")

func go_to_death_state():
	status = PlayerState.death
	anim.play("death")
	

#------#funções de estado#------------------#

func idle_state(delta):
	apply_movement(delta)

	if input_dir != 0:
		go_to_run_state()
		return

	if Input.is_action_just_pressed("jump"):
		jump()
	
	
		
	


func run_state(delta):
	apply_movement(delta)
	#if velocity.x == 0:	#Se o player parou
	#	go_to_idle_state()	#define o estado como idle
	#	return
	if input_dir == 0:
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump"):	#se o player apertou jump
		jump()	#coloca o player no estado de jump
		return

func jump_state(delta):
	apply_movement(delta)
	# ao tocar no chão
	if is_on_floor():
		if input_dir == 0:
			go_to_idle_state()
		else:
			go_to_run_state()
			
	#if is_on_floor():	#se o player esta no chão
	#	if velocity.x == 0:	#se o player está parado
	#		go_to_idle_state()	#retorna pro estado idle
	#	else:	#se não
	#		go_to_run_state()	#vai pro estado ran
	#	return



func fall_state(delta):
	apply_movement(delta)

	if is_on_floor():
		if input_dir == 0:
			go_to_idle_state()
		else:
			go_to_run_state()
	

func hit_state(_delta):
	pass

func death_state(_delta):
	pass

#----------#Funçoes auxiliares do sistema#-----------------#

func aply_gravity(_delta):
	pass

func move(_delta):
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false

func aplyca_gravity(_delta):
	pass


func update_direction():
	pass

func apply_movement(delta):
	# aplica movimento horizontal
	if input_dir != 0:
		velocity.x = move_toward(velocity.x, input_dir * move_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

	# vira sprite
	if input_dir < 0:
		anim.flip_h = true
	elif input_dir > 0:
		anim.flip_h = false

func read_input():
	input_dir = Input.get_axis("left", "right")

func jump():
	velocity.y = jump_force
	go_to_jump_state()
	#change_state(PlayerState.jump)
#-----------------------------------------#
