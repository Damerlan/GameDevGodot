extends CharacterBody2D

@export var max_speed : float = 400.0
@export var acceleration : float = 2000.0
@export var friction : float = 1500.0

@export var shoot_cooldown : float = 0.15

@export var max_health : int = 5
var health : int
var invulnerable : bool = false

var input_direction : Vector2 = Vector2.ZERO
var can_shoot : bool = true

#respawn seguro
var spawn_position : Vector2
var is_dead : bool = false


func _ready():
	spawn_position = global_position
	health = max_health
	add_to_group("player")
	$ShootTimer.wait_time = shoot_cooldown
	
func _physics_process(delta):
	handle_input()
	handle_movement(delta)
	move_and_slide()
	clamp_to_screen()
	
	$Sprite2D.rotation = velocity.x * 0.0008
	$Sprite2D2.rotation = velocity.x * 0.0008

func handle_input():
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func handle_movement(delta):
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func clamp_to_screen():
	var screen_size = get_viewport_rect().size
	global_position.x = clamp(global_position.x, 0, screen_size.x)
	global_position.y = clamp(global_position.y, 0, screen_size.y)

func _process(delta):
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot():
	if not can_shoot:
		return
	
	can_shoot = false
	
	var bullet = preload("res://scenes/projetles/bullet_player.tscn").instantiate()
	bullet.global_position = $GunPoint.global_position
	get_tree().current_scene.add_child(bullet)
	
	$ShootTimer.start()



func _on_shoot_timer_timeout() -> void:
	can_shoot = true


func take_damage(amount : int):
	if invulnerable:
		return 
	health -= amount
	
	if health <= 0:
		die()
	else:
		start_invulnerability()
		

func start_invulnerability():
	invulnerable = true
	modulate.a = 0.5
	
	await get_tree().create_timer(1.0).timeout

	modulate.a = 1.0
	invulnerable = false


#func die():
#	Global.lives -= 1
	
#	if Global.lives > 0:
#		queue_free()
#	else:
#		print("GAME OVER")
#		queue_free()

func die():
	if is_dead:
		return
		
	is_dead = true
	Global.lives -= 1
	explosion()
	
	if Global.lives > 0:
		respawn()
	else:
		game_over()
		
func respawn():
	# Esconde nave
	visible = false
	set_physics_process(false)
	
	await get_tree().create_timer(1.0).timeout
	
	# Reset atributos
	health = max_health
	global_position = spawn_position
	velocity = Vector2.ZERO
	
	visible = true
	set_physics_process(true)
	
	start_invulnerability()
	
	is_dead = false


func game_over():
	explosion()
	print("GAME OVER")
	queue_free()

func explosion():
	var explosion = preload("res://scenes/projetles/explosion.tscn").instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	
