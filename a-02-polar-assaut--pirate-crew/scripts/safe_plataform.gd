extends StaticBody2D


@export var visibility = 400
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

	pass # Replace with function body.


func _process(_delta: float) -> void:
	if player == null:
		return
	
	if position.y > player.position.y + visibility:
		queue_free()


# 🚀 Posição segura DEFINITIVA
func register_as_safe():
	Nglobal.last_safe_position = global_position
	Nglobal.last_safe_platform = self
