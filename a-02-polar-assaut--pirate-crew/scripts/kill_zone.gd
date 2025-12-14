extends Area2D

@export var next_scene = "screen_manager" 	#definindo a sena que o player será jogado apos morrer

signal morreu

func _on_body_entered(body: Node2D) -> void:
	
	if body is CharacterBody2D and body.has_method("take_hit"):

		# Se o player ainda tem vidas → aplica hit + respawn
		if Nglobal.lives > 1:
			body.take_hit()
			print("Player caiu na KillZone. Perdeu 1 vida e retornou à última plataforma!")
		elif Nglobal.lives >= 1:
			body.take_hit()
			emit_signal("morreu")
			print("Player Morreu")
		

	
func load_next_scene(): #avançã para a sena gerenciador >quetal fazer uma tela de loading aqui< -
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")	#troca de sena
