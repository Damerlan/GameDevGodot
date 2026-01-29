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

func _ready():
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

func die():
	print("Game Over")
	queue_free()
