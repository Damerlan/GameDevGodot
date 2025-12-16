extends StaticBody2D

@export var visibility = 400
var player = null

@export var max_coins: int = 5

# chance de cada moeda existir (0.0 a 1.0)
@export var coin_spawn_chance: float = 0.5

# distância entre moedas
@export var coin_spacing: int = 16

@export var coin_scene: PackedScene


@export var gem_spawn_chance: float = 0.08  # 8%
@export var gem_scene: PackedScene
@export var special_height_offset: int = -32

func  _ready() -> void:
	gem_spawn_chance = ScoreManager.get_gem_chance_by_height(global_position.y)
	spawn_coins()
	spawn_gem()
	player = get_tree().get_first_node_in_group("Player")
	

func spawn_coins():
	var coins_container = $Coins
	
	# limpa moedas (segurança)
	for c in coins_container.get_children():
		c.queue_free()

	for i in max_coins:
		if randf() <= coin_spawn_chance:
			var coin = coin_scene.instantiate()
			
			# posição LOCAL à plataforma
			coin.position = Vector2(
				(i - max_coins / 2.0) * coin_spacing,
				-16
			)
			
			coins_container.add_child(coin)

func spawn_gem():
	if randf() > gem_spawn_chance:
		return

	var gem = gem_scene.instantiate()
	gem.position = Vector2(0, special_height_offset)
	$Specials.add_child(gem)

func _process(_delta: float) -> void:
	if player == null:
		return
	
	if position.y > player.position.y + visibility:
		queue_free()

# 🚀 Posição segura DEFINITIVA (centro da plataforma)
func register_as_safe():
	Nglobal.last_safe_position = global_position
