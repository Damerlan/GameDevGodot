extends CharacterBody2D

@export var tremor_duration := 0.4
@export var fall_delay := 0.2
@export var gravity := 1200.0
@export var tremor_strength := 2.0

var activated := false
var falling := false
var original_position: Vector2

func _ready():
	original_position = position

func _physics_process(delta):
	if falling:
		velocity.y += gravity * delta
		move_and_slide()

func _on_area_2d_body_entered(body):
	if activated:
		return
	
	if body.is_in_group("Player"):
		activated = true
		start_tremor()

func start_tremor():
	var elapsed := 0.0
	
	while elapsed < tremor_duration:
		position.x = original_position.x + randf_range(-tremor_strength, tremor_strength)
		await get_tree().create_timer(0.03).timeout
		elapsed += 0.03
	
	position = original_position
	await get_tree().create_timer(fall_delay).timeout
	start_fall()

func start_fall():
	falling = true
