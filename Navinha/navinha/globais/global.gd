extends Node

enum GameMode {
	HORIZONTAL,
	VERTICAL
}

var current_mode : GameMode = GameMode.HORIZONTAL

#--Fase
var current_stage : int = 1
var current_level : int = 1
var is_boss : bool = false
var highscore : int = 0

#--Player
var score : int = 0
var lives : int = 3


#---------------------------funçoes
func add_score(amount : int):
	score += amount
	
	if score > highscore:
		highscore = score

func reset_game():
	score = 0
	lives = 3
