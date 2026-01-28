extends Node

enum GameMode {
	HORIZONTAL,
	VERTICAL
}

var current_mode : GameMode = GameMode.HORIZONTAL


@export var score := 0
