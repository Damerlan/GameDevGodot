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

@onready var fx_jump: AudioStreamPlayer = $Souds/fx_jump
@onready var fx_damage: AudioStreamPlayer = $Souds/fx_damage
@onready var fx_teleport: AudioStreamPlayer = $Souds/fx_teleport

#---------------------------------------------
# Nodes
#---------------------------------------------
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_ui: Node2D = $JumpPowerUi
@onready var jump_fill: ColorRect = $JumpPowerUi/Fill
@onready var dust_particles: GPUParticles2D = $DustParticles

@export var jump_ui_height := 12.0
@export var jump_ui_fade_speed := 20.0
#---------------------------------------------
# Variáveis exportáveis
#---------------------------------------------
@export var max_speed = 250
@export var move_speed := 160.0
@export var acceleration := 600.0
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
@export var input_dir := 0.0

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
	jump_ui.position = Vector2(9, -7)
   

func _physics_process(delta: float) -> void:	#processo de fisica
	read_input()
	#gravidade
	if not is_on_floor():	#se o player nao está no chão
		velocity += get_gravity() * delta	#aplica o efeito de gravidade
	
	var is_moving = abs(velocity.x) > 10
	var on_ground = is_on_floor()
	
	dust_particles.emitting = is_moving and on_ground
	
	
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
	update_jump_ui()#jump UI
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
	fx_jump.play()
	anim.play("jump")
	#velocity.y = JUMP_VELOCITY	#aplica a ação do pulo

func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall")

func go_to_hit_state():
	status = PlayerState.hit
	anim.play("hit")
	fx_damage.play()

func go_to_death_state():
	status = PlayerState.death
	anim.play("death")
	

#------#funções de estado#------------------#

func idle_state(delta):
	apply_movement(delta)
	Nglobal.update_autura(global_position.y) 	#calcula a pontuação
	#decai o momentum
	run_momentum = max(run_momentum - momentum_decay * delta, 0)
	if Input.is_action_just_pressed("jump"):
		jump()
		
	if input_dir != 0:
		go_to_run_state()
		return



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

#func read_input():
#	input_dir = Input.get_axis("left", "right")

func read_input():
	input_dir = Input.get_axis("move_left", "move_right")

func jump():
	#velocity.y = jump_force
	var extra_force = run_momentum * 0.4    # 40% do momentum vira força no pulo
	velocity.y = jump_force - extra_force
	go_to_jump_state()
	#change_state(PlayerState.jump)
#-----------------------------------------#

func update_jump_ui():
	var ratio := run_momentum / max_momentum
	ratio = clamp(ratio, 0.0, 1.0)

	# Atualiza tamanho da barra
	jump_fill.size.y = jump_ui_height * ratio
	jump_fill.position.y = jump_ui_height - jump_fill.size.y

	# Condição de exibição
	var should_show := is_on_floor() and ratio >= 0.5

	# Fade suave (GDScript correto)
	var target_alpha := 1.0 if should_show else 0.0

	jump_ui.modulate.a = lerp(
		jump_ui.modulate.a,
		target_alpha,
		jump_ui_fade_speed * get_physics_process_delta_time()
	)
	

#---------------------------------------------
# SISTEMA DE DANO + RESPAWN
#---------------------------------------------
func take_hit():
	# evita reentrar
	if status == PlayerState.hit or status == PlayerState.death:
		return

	# remove vida
	Nglobal.remove_life()

	# sempre mostra feedback
	go_to_hit_state()
	velocity = Vector2.ZERO

	# MORTE
	if Nglobal.lives <= 0:
		call_deferred("_die")
		return

	# AINDA VIVO
	call_deferred("_do_respawn")
	
	#elif Nglobal.lives == 0:
	#	morrer()
func _die():
	go_to_death_state()
	emit_signal("morreu")
	game_over()

func game_over():
	print("GAME OVER")
	get_tree().change_scene_to_file("res://huds/game_over.tscn")
#

func _do_respawn():
	# posição segura existe?
	if Nglobal.last_safe_position != Vector2.ZERO:
		fx_teleport.play()#som de teleporte
		# respawn 40px acima da plataforma
		global_position = Nglobal.last_safe_position + Vector2(0, -40)
		velocity = Vector2.ZERO

	# invulnerável por 0.2s
	status = PlayerState.hit
	await get_tree().create_timer(0.2).timeout
	
	go_to_idle_state()
