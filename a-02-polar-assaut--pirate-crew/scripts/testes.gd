extends Node2D

@export var next_scene = "a_02_prototype_plataforms" 	#definindo a sena que o player será jogado apos morrer

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		Global.reset_run()	
		call_deferred("load_next_scene")



	
func load_next_scene():
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")	#troca de sena
