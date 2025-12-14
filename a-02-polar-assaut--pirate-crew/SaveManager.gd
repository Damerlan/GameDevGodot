# SaveManager.gd (autoload)
extends Node

const SAVE_PATH = "user://penguin_save_score.json"

const MAX_RECORDS := 5


var ranking:Array = []

func _ready():
	load_ranking()

func load_ranking():
	if not FileAccess.file_exists(SAVE_PATH):
		ranking = []
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())

	if typeof(data) == TYPE_ARRAY:
		ranking = data
	else:
		ranking = []

func save_ranking():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(ranking))

func is_new_record(score:int) -> bool:
	if ranking.size() < MAX_RECORDS:
		return true
	return score > ranking[-1].score

func add_record(nome:String, score:int):
	ranking.append({
		"nome": nome,
		"score": score
	})
	ranking.sort_custom(func(a, b): return a.score > b.score)
	ranking = ranking.slice(0, MAX_RECORDS)
	save_ranking()





#extends Node
#class_name SaveManager

#const SAVE_PATH := "user://savegame.json"


#--------Pesos-----------------
#const PESO_SUBIDA = 1.2
#const PONTOS_ITEM = 70
#const PESO_TEMPO = 1.0
#const PESO_EFICIENCIA = 45

#--Pontos-Partida-pré-caluclo---
#var altura := 0
#var itens := 0
#var tempo := 0.0

#--Pontos-Partida-pós-caluclo---
#var pontosAltura
#var pontosColeta
#var pontosEficiencia
#var pontosTempo

#--------HighScore-------------
#var highscore := Nglobal.highscore
#var highscore_name := Nglobal.highscore_name
#var last_run_score := Nglobal.last_score 

#-------Sinais-----------------




#-------funções de sistema-----
#func _ready():
	#load_game()
#	pass

#-------funçoes gerais----------
#func get_score() -> int:
#	var pontos_subida = altura * PESO_SUBIDA
#	var pontos_coleta = itens * PONTOS_ITEM
#	var bonus_ef = (altura / max(tempo, 1)) * PESO_EFICIENCIA
#	var penalidade = tempo * PESO_TEMPO
#	
#	return int(pontos_subida + pontos_coleta + bonus_ef - penalidade)


#func calcScore(alturaMaxima, itensColetados,tempoPartida):
	#Base de calculo para a função
#	var pontosSubida = alturaMaxima * pesoSubida #calculo bonus de subida
#	var pontosColeta = itensColetados * pontosPorItem #calculo bonus de coleta
#	var pontosBase = pontosSubida + pontosColeta # pontos base
#	var penalidadeTempo = tempoPartida * pesoTempo #penalida de Tempo
#	var bonusEficiencia  = (alturaMaxima / tempoPartida) * pesoEficiencia
#	var TOTAL = pontosBase + bonusEficiencia - penalidadeTempo
#	pass



	
