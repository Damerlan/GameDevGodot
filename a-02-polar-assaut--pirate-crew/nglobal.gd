extends Node

var lives = 3



var last_safe_position
signal autura_changed(value)
signal lives_changed
signal morreu

#func add_score(value):	#add ponto extra ao score
#	altura += value
#	emit_signal("score_changed", altura)

func add_life(): #add +1 vida
	lives += 1
	emit_signal("lives_changed")

func remove_life(): 	#remove Vidas
	lives -= 1
	#if lives == 0:
	#emit_signal("morreu")
	#print("morreu")
	emit_signal("lives_changed")
#func remove_life(amount := 1):
#	lives -= amount

#reseta a partida
			# vai para o lobby
func reset_run():
	lives = 3
	ScoreManager.altura = 0
	ScoreManager.tempo = 0.0
	ScoreManager.itens = 0
	last_safe_position = Vector2.ZERO

#func update_score(player_y):
	# Exemplo: quanto mais sobe menor Y → score aumenta
	#score = max(score, -player_y)
	#emit_signal("score_changed", score)
	#pass

func update_autura(player_y):
	ScoreManager.altura = max(ScoreManager.altura, -player_y)
	emit_signal("autura_changed", ScoreManager.altura)
	return

func update_coleta(item):
	ScoreManager.itens = ScoreManager.itens + item
	return
	





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
