extends Area2D

@export var next_scene = "screen_manager" 	#definindo a sena que o player será jogado apos morrer



func _on_body_entered(body: Node2D) -> void:
	
	if body is CharacterBody2D and body.has_method("take_hit"):

		# Se o player ainda tem vidas → aplica hit + respawn
		if Global.lives > 1:
			body.take_hit()
			print("Player caiu na KillZone. Perdeu 1 vida e retornou à última plataforma!")
		
		# Se era a última vida → faz hit e depois troca a cena
		elif Global.lives == 1:
			body.take_hit()
			Global.last_score = Global.score
			#print("Player morreu!")
			# registra recorde e limpa contadores
			#Global.on_player_death()
			if Global.score > Global.highscore:
				print("O player bateu o recod")
				Global.pending_record = true #deve pedir nome
				Global.step_record = false
				#call_deferred("load_next_scene")
			else:
				Global.pending_record = false
				print("O não bateu o recod")
			
			call_deferred("load_next_scene")
			
	

	
	
func load_next_scene():
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")	#troca de sena
