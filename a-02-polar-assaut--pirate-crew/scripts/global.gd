extends Node

var score: int = 0
var lives: int = 3

var highscore: int = 0
var highscore_name:String = "Ninguém" #<-novo
var last_score: int = 0

var newhighscore_name = "" #novo nome

var pending_record:bool = false #indica que o jogador deve digitar o nome
var step_record = false #indica que ainda nao preparou o arquivo

var last_safe_position: Vector2 = Vector2.ZERO


var max_height_reached := 0.0

signal score_changed(value)
signal lives_changed


func add_score(value):	#add ponto extra ao score
	score += value
	emit_signal("score_changed", score)

func add_life(): #add +1 vida
	lives += 1
	emit_signal("lives_changed")

func remove_life(): 	#remove Vidas
	lives -= 1
	emit_signal("lives_changed")
#func remove_life(amount := 1):
#	lives -= amount

#reseta a partida
			# vai para o lobby
func reset_run():
	lives = 3
	score = 0
	last_safe_position = Vector2.ZERO

func update_score(player_y):
	# Exemplo: quanto mais sobe menor Y → score aumenta
	score = max(score, -player_y)
	emit_signal("score_changed", score)


#investigar ----------------------
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
	#Global.last_score = Global.score
	SaveManager.data["last_score"] = score
	
	if score > SaveManager.data["hight_score"]:
		SaveManager.data["hight_score"] = score
		#SaveManager.data["hight_score_name"] = jogador_nome #futuramente
	
	SaveManager.save_game() #salva tudo
	
