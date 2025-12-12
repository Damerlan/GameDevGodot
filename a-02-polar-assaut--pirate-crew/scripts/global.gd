extends Node

var score: int = 0
var lives: int = 3
var last_score: int = 0
var highscore: int = 0
var highscore_name:String = "" #<-novo

var pending_record:bool = false #indica que o jogador deve digitar o nome


var last_safe_position: Vector2 = Vector2.ZERO


var max_height_reached := 0.0

signal score_changed(value)
signal lives_changed(value)


func add_score(value):	#add ponto extra ao score
	score += value
	emit_signal("score_changed", score)

func add_life(): #add +1 vida
	lives += 1
	emit_signal("lives_changed", lives)

func remove_life(): 	#remove Vidas
	lives -= 1
#func remove_life(amount := 1):
#	lives -= amount

#reseta a partida
func reset_run():
	lives = 3
	score = 0
	last_safe_position = Vector2.ZERO

func update_score(player_y):
	# Exemplo: quanto mais sobe menor Y → score aumenta
	score = max(score, -player_y)

func on_player_death():
	# salva pontuação da última partida
	last_score = score

	# atualiza recorde SE for maior que o atual
	if score > highscore:
		highscore = score
	end_game()#faz o save
	# zera para próxima rodada
	reset_run()

func end_game():
	SaveManager.data["last_score"] = score
	
	if score > SaveManager.data["hight_score"]:
		SaveManager.data["hight_score"] = score
		#SaveManager.data["hight_score_name"] = jogador_nome #futuramente
	
	SaveManager.save_game() #salva tudo
	
#update o score com base na altura
#func update_score(player_y):
#	if player_y < max_height_reached:
#		var diff = max_height_reached - player_y
#		score += int(diff / 5)
#		max_height_reached = player_y
