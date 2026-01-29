extends Node2D

@export var drone_scene : PackedScene
@export var assault_scene : PackedScene
@export var spawn_interval : float = 1.5
@export var wave_size : int = 5
@export var vertical_margin : float = 80.0

var screen_size : Vector2
var spawning : bool = true

func _ready():
	screen_size = get_viewport_rect().size
	start_wave()

func start_wave():
	spawn_wave()

#func spawn_wave():
#	if not spawning:
#		return
#	
#	for i in wave_size:
#		spawn_drone()
#		await get_tree().create_timer(spawn_interval).timeout
#	
#	# Pequena pausa antes da próxima onda
#	await get_tree().create_timer(2.0).timeout
#	spawn_wave()

func spawn_wave():
	if not spawning:
		return
	var pattern = randi() % 4
	match pattern:
		0:
			await spawn_line_wave()
		1:
			await spawn_diagonal_wave()
		2:
			await spawn_fast_wave()
		3:
			await spawn_assault_wave()
			
	await get_tree().create_timer(2.0).timeout
	spawn_wave()
	
func spawn_line_wave():
	var y = randf_range(vertical_margin, screen_size.y - vertical_margin)
	
	for i in wave_size:
		var drone = drone_scene.instantiate()
		drone.global_position = Vector2(screen_size.x + (i * 80), y)
		get_parent().add_child(drone)
	await get_tree().create_timer(0.2).timeout

func spawn_diagonal_wave():
	var start_y = randf_range(vertical_margin, screen_size.y - vertical_margin)
	
	for i in wave_size:
		var drone = drone_scene.instantiate()
		drone.global_position = Vector2(
			 screen_size.x + (i * 80),
			start_y + (i * 40)
		)
		get_parent().add_child(drone)
		await get_tree().create_timer(0.2).timeout
		
func spawn_fast_wave():
	for i in wave_size:
		var drone = drone_scene.instantiate()
		drone.speed = 400
		drone.global_position = Vector2(
			screen_size.x + 50,
			randf_range(vertical_margin, screen_size.y - vertical_margin)
		)
		get_parent().add_child(drone)
		await get_tree().create_timer(0.1).timeout

	
func spawn_drone():
	var drone = drone_scene.instantiate()
	
	drone.global_position = Vector2(
		screen_size.x + 50,
		randf_range(vertical_margin, screen_size.y - vertical_margin)
	)
	
	get_parent().add_child(drone)

func spawn_assault_wave():
	for i in 3:
		var drone = assault_scene.instantiate()
		drone.global_position = Vector2(
			screen_size.x + 100,
			randf_range(100, screen_size.y - 100)
		)
		get_parent().add_child(drone)
		
		await get_tree().create_timer(0.8).timeout
