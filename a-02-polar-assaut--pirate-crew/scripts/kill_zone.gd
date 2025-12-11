extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var cam = get_parent().get_node("CameraGamePlay")

@export var offset_y := 150  # quão abaixo da câmera fica o killzone

func _process(_delta):
	# Acompanha a câmera
	global_position.y = cam.global_position.y + offset_y


func _on_body_entered(body: Node2D) -> void:
	if body == player:
		player.go_to_death_state()
		push_error("O Player Passou aqui!")
		return
