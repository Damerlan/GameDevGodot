extends CharacterBody2D

@export var speed : float = 150.0
@export var max_health : int = 5
@export var score_value : int = 100

@export var bullet_scene : PackedScene
@export var shoot_interval : float = 1.8
@export var shoot_probability : float = 0.6
@export var can_shoot : bool = true

@onready var shoot_timer = $ShootTimer

@export var missile_powerup_scene: PackedScene

@export var wave_amplitude : float = 50.0
@export var wave_frequency : float = 2.0

var time_passed : float = 0.0
var start_y : float

var health : int

#func _ready():
#	health = max_health
#	start_y = global_position.y
#	if can_shoot:
#		shoot_timer.wait_time = shoot_interval
#		shoot_timer.start()

func _ready():
	add_to_group("enemy")
	health = max_health
	
	if can_shoot:
		shoot_timer.wait_time = shoot_interval

		# Delay inicial aleatório
		await get_tree().create_timer(randf_range(0.0, shoot_interval)).timeout

		shoot_timer.start()



func _physics_process(delta):
	time_passed += delta
	velocity.x = -speed
	velocity.y = sin(time_passed * wave_frequency) * wave_amplitude

	var player = get_tree().get_first_node_in_group("player")
	if player and global_position.x < player.global_position.x:
		shoot_timer.stop()
	move_and_slide()



func take_damage(amount : int):
	health -= amount
	
	if health <= 0:
		die()

func die():
	#Global.score += score_value
	Global.add_score(score_value)
	spawn_powerup()
	spawn_explosion()
	queue_free()

func spawn_powerup():
	if randi() % 5 == 0: # 20% chance
		var powerup = missile_powerup_scene.instantiate()
		powerup.global_position = global_position
		get_parent().add_child(powerup)

		
func spawn_explosion():
	var explosion = preload("res://scenes/projetles/explosion.tscn").instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)

func _on_VisibleOnScreenNotifier2D_screen_exited():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()



func shoot():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return

	# Se o drone já passou do player, não atira
	if global_position.x < player.global_position.x:
		return

	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	
	var dir = (player.global_position - global_position).normalized()
	var spread = randf_range(-0.15, 0.15)
	dir = dir.rotated(spread)
	
	bullet.direction = dir
	get_parent().add_child(bullet)


func _on_shoot_timer_timeout() -> void:
	if randf() <= shoot_probability:
		shoot()


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1)
		spawn_explosion()
		queue_free() # inimigo explode
