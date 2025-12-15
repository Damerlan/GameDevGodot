extends Node


var tempo_partida: float = 0.0
var contando: bool = false

signal tempo_atualizado(tempo: float)
signal partida_finalizada(tempo_final: float)

func iniciar_partida():
	tempo_partida = 0.0
	contando = true

func finalizar_partida():
	contando = false
	emit_signal("partida_finalizada", tempo_partida)

func _process(delta):
	if contando:
		tempo_partida += delta
		emit_signal("tempo_atualizado", tempo_partida)

func formatar_tempo(segundos: float) -> String:
	var total := int(segundos)
	var min := total / 60
	var sec := total % 60
	return "%02d:%02d" % [min, sec]
