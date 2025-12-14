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
# Sinais
#---------------------------------------------
signal morreu

#---------------------------------------------
# Internas
#---------------------------------------------
var status: PlayerState	#variável de status
var input_dir := 0.0

var JUMP_VELOCITY = -600.0
var SPEED = 80.0

#adicionando a mecanica do momentum
@export var run_momentum := 0.0     # aumenta enquanto corre
@export var max_momentum := 500.0   # limite do momentum
@export var momentum_gain := 450.0
@export var momentum_decay := 60.0

#-----------funçoes do sistema e fisica------------------#
func _ready() -> void:
	go_to_idle_state()	#coloca o player em idle state

   

func _physics_process(delta: float) -> void:	#processo de fisica
	read_input()
	#gravidade
	if not is_on_floor():	#se o player nao está no chão
		velocity += get_gravity() * delta	#aplica o efeito de gravidade
	
	
	#if is_on_floor(): #se estiver na plataforma
	#	Global.last_safe_position = global_position
	
	if is_on_floor(): #registrando a plataforma
		var normal = get_floor_normal()

		# Garante que o player pousou no topo plano da plataforma
		if normal.is_equal_approx(Vector2.UP):
			
			# Pegamos a plataforma pela última colisão do slide
			var collision = get_last_slide_collision()
			
			if collision:
				var obj = collision.get_collider()

				if obj and obj.has_method("register_as_safe"):
					obj.register_as_safe()
		else:
			# Aqui evitamos registrar plataformas onde o player
			# pousou na quina ou numa lateral
			print("Ignorado: pousou na quina / lateral.")
	
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
	#velocity.y = JUMP_VELOCITY	#aplica a ação do pulo

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
	Nglobal.update_autura(global_position.y) 	#calcula a pontuação
	#decai o momentum
	run_momentum = max(run_momentum - momentum_decay * delta, 0)

	if input_dir != 0:
		go_to_run_state()
		return

	if Input.is_action_just_pressed("jump"):
		jump()
	
	
		
	


func run_state(delta):
	apply_movement(delta)
	
	# acumula momentum enquanto corre
	if input_dir != 0:
		run_momentum += momentum_gain * delta
	else:
		run_momentum -= momentum_decay * delta
	
	run_momentum = clamp(run_momentum, 0, max_momentum)
	
	if input_dir == 0:
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump"):	#se o player apertou jump
		jump()	#coloca o player no estado de jump
		return

func jump_state(delta):
	apply_movement(delta)
	
	# se começou a cair → entra em fall
	if velocity.y > 0:
		go_to_fall_state()
		return
		
	# ao tocar no chão
	if is_on_floor():
		if input_dir == 0:
			go_to_idle_state()
		else:
			go_to_run_state()
			



func fall_state(delta):
	apply_movement(delta)
	
	# momentum perde força no ar
	run_momentum = max(run_momentum - momentum_decay * delta, 0)

	if is_on_floor():
		run_momentum = 0   # reset momentum ao pousar
		if input_dir == 0:
			go_to_idle_state()
		else:
			go_to_run_state()
	

func hit_state(delta):
	# Player não mexe horizontalmente enquanto leva dano
	velocity.x = move_toward(velocity.x, 0, 30 * delta)
	
	# mantém a física
	# move_and_slide() é chamado fora

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
		var speed_with_momentum = move_speed + (run_momentum * 0.3)
		velocity.x = move_toward(velocity.x, input_dir * speed_with_momentum, acceleration * delta)
		#velocity.x = move_toward(velocity.x, input_dir * move_speed, acceleration * delta)
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
	
	#velocity.y = jump_force
	var extra_force = run_momentum * 0.4    # 40% do momentum vira força no pulo
	velocity.y = jump_force - extra_force
	go_to_jump_state()
	#change_state(PlayerState.jump)
#-----------------------------------------#
#---------------------------------------------
# SISTEMA DE DANO + RESPAWN
#---------------------------------------------
func take_hit():
	# evita reentrar no estado
	if status == PlayerState.hit or status == PlayerState.death:
		return
	
	# perde vida no Global
	Nglobal.remove_life()

	# coloca estado de hit
	go_to_hit_state()
	velocity = Vector2.ZERO

	#if Nglobal.lives > 0:
	# respawn em deferred (evita bugs)
	call_deferred("_do_respawn")
	
	#elif Nglobal.lives == 0:
	#	morrer()

#func morrer():
#	print("o player morreu")
#	emit_signal("morreu")
	

func game_over():
	print("game over")
	pass
	#Global.last_score = Global.score
	
	#verificamos se superou o record
	#if Global.score > Global.highscore:
	#	Global.pending_record = true
	#else:
	#	Global.pending_record = false
	
	#salva score normal
	#SaveManager.save_game()
	
	#ScreenManager vai decidir se abre a HUD de nome ou volta ao loby
	#get_tree().change_scene_to_file("res://scenes/screen_manager.tscn")


func _do_respawn():
	# posição segura existe?
	if Nglobal.last_safe_position != Vector2.ZERO:
		# respawn 40px acima da plataforma
		global_position = Nglobal.last_safe_position + Vector2(0, -40)
		velocity = Vector2.ZERO

	# invulnerável por 0.2s
	status = PlayerState.hit
	await get_tree().create_timer(0.2).timeout

	go_to_idle_state()
