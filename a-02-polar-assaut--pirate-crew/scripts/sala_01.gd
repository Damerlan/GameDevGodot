extends Node2D

@onready var player = $PlayerPeko
@onready var killzone = $KillZone
@onready var y_sort: Node = $YSort

#const CLEMENT_PANCHOUT__LIFE_IS_FULL_OF_JOY = preload("uid://fxgv6gc1b3o8")
#const CLEMENT_PANCHOUT__LIFE_IS_FULL_OF_JOY = preload("uid://fxgv6gc1b3o8")

func _ready() -> void:
	GameManager.iniciar_partida()
	var gm = get_tree().get_first_node_in_group("GameManager")
	if gm:
		gm.state = GameManager.GameState.PLAYING
#	killzone.morreu.connect(_on_player_morreu)
	
	#Nglobal.morreu.connect(_on_player_morreu)
	#player.morreu.connect()


func _on_player_morreu():
	
	GameManager.finalizar_partida()
	#para o tempo
	get_tree().paused = true
	
	#pequena espera
	await get_tree().create_timer(0.8).timeout
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://huds/game_over.tscn")
