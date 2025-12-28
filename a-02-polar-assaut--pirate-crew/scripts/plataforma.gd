extends StaticBody2D

@export var visibility = 400
var player = null

# -------- COINS --------
@export var max_coins: int = 5
@export var coin_spawn_chance: float = 0.5
@export var coin_spacing: int = 16
@export var coin_scene: PackedScene

# -------- GEM --------
@export var gem_spawn_chance: float = 0.08  # 8%
@export var gem_scene: PackedScene
@export var special_height_offset: int = -32

# -------- LIFE --------
@export var life_spawn_chance: float = 0.08 # 8%
@export var life_scene: PackedScene
@export var life_height_offset: int = -32

# ----------------------

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

	gem_spawn_chance = ScoreManager.get_gem_chance_by_height(global_position.y)

	spawn_coins()
	spawn_gem()
	spawn_life()


# 🪙 COINS
func spawn_coins():
	var coins_container = $Coins
	
	for c in coins_container.get_children():
		c.queue_free()

	for i in max_coins:
		if randf() <= coin_spawn_chance:
			var coin = coin_scene.instantiate()
			coin.position = Vector2(
				(i - max_coins / 2.0) * coin_spacing,
				-16
			)
			coins_container.add_child(coin)


# 💎 GEM
func spawn_gem():
	if randf() > gem_spawn_chance:
		return

	var gem = gem_scene.instantiate()
	gem.position = Vector2(0, special_height_offset)
	$Specials.add_child(gem)


# ❤️ LIFE
func spawn_life():
	if randf() > life_spawn_chance:
		return

	# Evita life + gem juntas (boa prática)
	if $Specials.get_child_count() > 0:
		return

	var life = life_scene.instantiate()
	life.position = Vector2(0, life_height_offset)
	$Lifes.add_child(life)


func _process(_delta: float) -> void:
	if player == null:
		return
	
	if position.y > player.position.y + visibility:
		queue_free()


# 🚀 Posição segura DEFINITIVA
func register_as_safe():
	Nglobal.last_safe_position = global_position
	Nglobal.last_safe_platform = self
