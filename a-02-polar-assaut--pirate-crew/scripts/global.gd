extends Node

var score: int = 0
var lives: int = 3


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

#update o score com base na altura
func update_score(player_y):
	if player_y < max_height_reached:
		var diff = max_height_reached - player_y
		score += int(diff / 5)
		max_height_reached = player_y
