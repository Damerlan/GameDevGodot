extends Node

var altura := 0
var itens := 0
var tempo := 0.0



const PESO_SUBIDA = 1.2
const PONTOS_ITEM = 70
const PESO_TEMPO = 1.0
const PESO_EFICIENCIA = 45

func get_score() -> int:
	var pontos_subida = altura * PESO_SUBIDA
	var pontos_coleta = itens * PONTOS_ITEM
	var bonus_ef = (altura / max(tempo, 1)) * PESO_EFICIENCIA
	var penalidade = tempo * PESO_TEMPO
	
	return int(pontos_subida + pontos_coleta + bonus_ef - penalidade)
