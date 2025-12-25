extends Node2D

@export var platform_scene: PackedScene
@export var moving_platform_scene: PackedScene

# Altura mínima/máxima entre plataformas (alcançável pelo pulo)
@export var distance_between := Vector2(10, 750)

# Margem para não colar na borda da câmera
@export var screen_margin := 45

# ----- CONFIGURAÇÃO DE CHANCE E PROGRESSÃO -----
@export var base_moving_chance := 0.05 # 5% no início
@export var max_moving_chance := 0.4   # 40% no máximo
@export var height_for_max_chance := 6000.0 # altura para atingir chance máxima
# ----------------------------------------------

var last_platform_y := 0.0
var player = null


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player:
		last_platform_y = player.global_position.y + 60
	_spawn_initial_platforms()


func _process(_delta: float) -> void:
	_spawn_platform_if_needed()


func _spawn_initial_platforms():
	for i in range(6):
		_spawn_platform()


func _spawn_platform_if_needed():
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return

	var screen_h = get_viewport_rect().size.y

	# Quando a câmera está chegando no topo das plataformas
	if cam.global_position.y - last_platform_y < screen_h * 0.6:
		_spawn_platform()


# 🔢 Calcula a chance baseada na altura do player
func _get_moving_platform_chance() -> float:
	if player == null:
		return base_moving_chance

	# Quanto mais negativo o Y, mais alto o player subiu
	var height_climbed = abs(player.global_position.y)
	var t = clamp(height_climbed / height_for_max_chance, 0.0, 1.0)

	return lerp(base_moving_chance, max_moving_chance, t)


func _spawn_platform():
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return

	var half_w = get_viewport_rect().size.x * 0.5

	var y_offset = randf_range(distance_between.x, distance_between.y)
	last_platform_y -= y_offset

	# X baseado na câmera
	var min_x = cam.global_position.x - half_w + screen_margin
	var max_x = cam.global_position.x + half_w - screen_margin
	var pos_x = randf_range(min_x, max_x)

	# 🎲 Decide qual plataforma spawnar
	var chance = _get_moving_platform_chance()

	var p
	if randf() < chance and moving_platform_scene:
		p = moving_platform_scene.instantiate()
	else:
		p = platform_scene.instantiate()

	p.global_position = Vector2(pos_x, last_platform_y)
	get_parent().get_node("YSort").add_child(p)
