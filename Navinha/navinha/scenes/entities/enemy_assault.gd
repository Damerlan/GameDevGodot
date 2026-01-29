extends CharacterBody2D

enum State { ENTER, ATTACK, EXIT }

@export var score_value : int = 200
@export var enter_speed : float = 400.0
@export var exit_speed : float = 500.0
@export var stop_x_position : float = 900.0
@export var shots_to_fire : int = 3
@export var shoot_interval : float = 0.6
@export var bullet_scene : PackedScene

@onready var shoot_timer = $ShootTimer

@export var max_health : int = 5
var health : int

var state : State = State.ENTER
var shots_fired : int = 0

func _ready():
	health = max_health
	shoot_timer.wait_time = shoot_interval

func _physics_process(delta):
	match state:
		State.ENTER:
			velocity.x = -enter_speed
			move_and_slide()
			
			if global_position.x <= stop_x_position:
				state = State.ATTACK
				velocity = Vector2.ZERO
				shoot_timer.start()
				
		State.ATTACK:
			# parado enquanto atira
			pass

		State.EXIT:
			velocity.x = -exit_speed
			move_and_slide()

func _on_shoot_timer_timeout():
	shoot()
	shots_fired += 1

	if shots_fired >= shots_to_fire:
		shoot_timer.stop()
		state = State.EXIT

func shoot():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return

	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position

	var dir = (player.global_position - global_position).normalized()
	var spread = randf_range(-0.2, 0.2)
	bullet.direction = dir.rotated(spread)
	
	get_parent().add_child(bullet)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func take_damage(amount: int):
	health -= amount
	
	if health <= 0:
		die()

func die():
	Global.score += score_value
	spawn_explosion()
	queue_free()

func spawn_explosion():
	var explosion = preload("res://scenes/projetles/explosion.tscn").instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
