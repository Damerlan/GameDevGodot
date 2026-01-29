extends Node2D

#@export var stage_number : int = 1
#@export var level_number : int = 1
#@export var boss_level : bool = false

#func _ready():
#	Global.current_stage = stage_number
#	Global.current_level = level_number
#	Global.is_boss = boss_level

@export var stage_number : int = 1

@onready var spawn_manager = $SpawnManager
@onready var parallax = $Level

var phase_timer : float = 0.0
var phase_duration : float = 20.0

func _ready():
	Global.current_stage = stage_number
	start_level(1)

func _process(delta):
	phase_timer += delta
	
	if not Global.is_boss and phase_timer >= phase_duration:
		next_phase()


func start_level(level:int):
	phase_timer = 0.0
	
	Global.current_level = level
	Global.is_boss = false
	
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.show_stage_message("STAGE %d-%d" % [Global.current_stage, Global.current_level])
	
	match level:
		1:
			spawn_manager.set_difficulty(1)
			phase_duration = 20.0
			
		2:
			spawn_manager.set_difficulty(2)
			phase_duration = 25.0
			
		3:
			spawn_manager.set_difficulty(3)
			phase_duration = 30.0


func next_phase():
	if Global.current_level < 3:
		start_level(Global.current_level + 1)
	else:
		start_boss()

func start_boss():
	Global.is_boss = true
	
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.show_stage_message("⚠ WARNING ⚠", 1.5)
		await get_tree().create_timer(1.6).timeout
		hud.show_stage_message("BOSS APPROACHING", 2.0)
	
	spawn_manager.spawning = false
	
	# Para o scroll
	parallax.base_speed = 0
	
	await get_tree().create_timer(2.0).timeout
	
	spawn_boss()


func spawn_boss():
	var boss = preload("res://scenes/entities/boss_01.tscn").instantiate()
	boss.global_position = Vector2(1200, 300)
	add_child(boss)
	print("boss na fase!")
