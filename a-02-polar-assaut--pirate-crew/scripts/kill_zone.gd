extends Area2D

@export var next_scene = "" 	#definindo a sena que o player será jogado apos morrer



func _on_body_entered(_body: Node2D) -> void:
	
	if Global.lives >= 1:
		Global.remove_life()
		print("Player Perdeu uma vida!")
	elif Global.lives < 1:
		print("Player Morreu!")
		call_deferred("load_next_scene")
	
	
func load_next_scene():
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")	#troca de sena
