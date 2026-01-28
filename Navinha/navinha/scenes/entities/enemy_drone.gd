extends CharacterBody2D

@export var speed : float = 150.0
@export var max_health : int = 2
@export var score_value : int = 100


@export var wave_amplitude : float = 50.0
@export var wave_frequency : float = 2.0

var time_passed : float = 0.0
var start_y : float


var health : int

func _ready():
	health = max_health
	start_y = global_position.y

func _physics_process(delta):
	time_passed += delta
	velocity.x = -speed
	velocity.y = sin(time_passed * wave_frequency) * wave_amplitude
	
	move_and_slide()

func take_damage(amount : int):
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

func _on_VisibleOnScreenNotifier2D_screen_exited():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_hit_box_area_entered(area: Area2D) -> void:
	#take_damage(1)
	pass
	
