extends Control

@export var main_scene: PackedScene

func _ready():
	pass


func _on_btn_iniciar_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)
