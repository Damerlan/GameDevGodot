extends CharacterBody2D

@export var max_health : int = 100
@export var speed : float = 120.0
@export var entry_speed : float = 250.0

var health : int
var active : bool = false
var entering : bool = true

var direction : int = 1

func _ready():
	add_to_group("enemy")
	health = max_health
	global_position.x = get_viewport_rect().size.x + 200
	$TimerShoot.start()
	$TimerPattern.start()

func _physics_process(delta):

	if entering:
		velocity.x = -entry_speed
		move_and_slide()
		
		if global_position.x <= get_viewport_rect().size.x - 250:
			entering = false
			active = true
	else:
		move_pattern(delta)

func move_pattern(_delta):
	velocity = Vector2(0, speed * direction)
	move_and_slide()

	if global_position.y < 120:
		direction = 1
	elif global_position.y > get_viewport_rect().size.y - 120:
		direction = -1


func _on_timer_shoot_timeout() -> void:
	if not active:
		return

	var bullet_scene = preload("res://scenes/projetles/bullet_enemy.tscn")

	var bullet1 = bullet_scene.instantiate()
	bullet1.global_position = $GunLeft.global_position
	
	var bullet2 = bullet_scene.instantiate()
	bullet2.global_position = $GunRight.global_position
	
	get_tree().current_scene.add_child(bullet1)
	get_tree().current_scene.add_child(bullet2)


func _on_timer_pattern_timeout() -> void:
	if not active:
		return
		
	shoot_laser()

func shoot_laser():
	var laser_scene = preload("res://scenes/projetles/laser_enemy.tscn")
	var laser = laser_scene.instantiate()
	laser.global_position = global_position
	get_tree().current_scene.add_child(laser)


func take_damage(amount:int):
	health -= amount
	
	modulate = Color(1,0.5,0.5)
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if health <= 0:
		die()

func die():
	Global.add_score(1000)
	queue_free()
