extends CharacterBody2D

enum WeaponType { NORMAL, LASER, MISSILE }

var current_weapon: WeaponType = WeaponType.NORMAL

@export var normal_bullet_scene: PackedScene
@export var missile_scene: PackedScene

var missile_active : bool = false
var missile_duration : float = 10.0
var missile_cooldown : float = 0.6
var can_fire_missile : bool = true



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
	if missile_active:
		try_fire_missile()
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

func _process(_delta):
	if Input.is_action_pressed("shoot"):
		shoot()

#func shoot():
#	if not can_shoot:
#		return
	
#	can_shoot = false
	
#	var bullet = preload("res://scenes/projetles/bullet_player.tscn").instantiate()
#	bullet.global_position = $GunPoint.global_position
#	get_tree().current_scene.add_child(bullet)
	
#	$ShootTimer.start()

func shoot():
	if not can_shoot:
		return
	
	can_shoot = false
	
	var projectile
	
	match current_weapon:
		WeaponType.NORMAL:
			projectile = normal_bullet_scene.instantiate()
		WeaponType.MISSILE:
			projectile = missile_scene.instantiate()
	
	projectile.global_position = $GunPoint.global_position
	
	get_tree().current_scene.add_child(projectile)
	
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
	
	reset_powerups()   # ← AQUI
	
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

#func activate_missile():
#	current_weapon = WeaponType.MISSILE

func activate_missile():
	missile_active = true
	
	var timer = get_tree().create_timer(missile_duration)
	await timer.timeout
	
	if is_dead:
		return
		
	missile_active = false

	
func try_fire_missile():
	if not can_fire_missile:
		return
	
	var target = get_nearest_enemy()
	if target == null:
		return
	
	can_fire_missile = false
	
	var missile = missile_scene.instantiate()
	missile.global_position = $GunPoint.global_position
	missile.set_target(target)
	
	get_tree().current_scene.add_child(missile)
	
	await get_tree().create_timer(missile_cooldown).timeout
	can_fire_missile = true

func get_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	if enemies.size() == 0:
		return null
	
	var nearest = null
	var min_dist = INF
	
	for e in enemies:
		var dist = global_position.distance_to(e.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest = e
	
	return nearest


func reset_powerups():
	current_weapon = WeaponType.NORMAL
	
	missile_active = false
	can_fire_missile = true
