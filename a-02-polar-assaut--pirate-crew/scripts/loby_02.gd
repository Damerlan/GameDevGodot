extends Node2D

enum GameState {
	LOBBY,
	PLAYING,
	RANKING,
	GAME_OVER
	}

@onready var ui_efect: AudioStreamPlayer = $ui_efect

func _ready() -> void:
	var gm = get_tree().get_first_node_in_group("GameManager")
	if gm:
		gm.state = GameManager.GameState.LOBBY


func _on_btn_start_pressed() -> void:
	ui_efx()
	var next_scene = "loading_screen"
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")
	#get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")


func _on_btn_ranking_pressed() -> void:
	ui_efx()
	var next_scene = "ranking"
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")


func _on_btn_full_pressed() -> void:
	#botão de tela cheia ou janela
	Nglobal.toggle_fullscreen()


func _on_btn_sair_pressed() -> void:
	ui_efx()
	get_tree().quit()


func ui_efx():
	ui_efect.play()

func _unhandled_input(event):
	if event.is_action_pressed("ui_start"):
		var gm = get_tree().get_first_node_in_group("GameManager")
		if gm:
			gm.start_game()
