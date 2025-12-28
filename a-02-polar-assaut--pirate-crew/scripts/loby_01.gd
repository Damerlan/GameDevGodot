extends Node2D

@onready var ranking_panel: Panel = $CanvasLayer/RankingPanel
@onready var vbox_ranking: VBoxContainer = $CanvasLayer/RankingPanel/VBoxContainer/VBoxRanking

@onready var ui_efect: AudioStreamPlayer = $ui_efect
enum GameState { LOBBY, PLAYING, GAME_OVER }
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ranking_panel.visible = false
	var gm = get_tree().get_first_node_in_group("GameManager")
	if gm:
		gm.state = GameManager.GameState.LOBBY
#var state: GameState = GameState.LOBBY
func update_ranking():
	for child in vbox_ranking.get_children():
		child.queue_free()

	var pos := 1
	for entry in SaveManager.ranking:
		var lbl = Label.new()
		lbl.text = "%dº  %s  -  %d" % [pos, entry.nome, entry.score]
		lbl.add_theme_font_size_override("font_size", 10)
		vbox_ranking.add_child(lbl)
		pos += 1


func _on_btn_start_pressed() -> void:
	ui_efx()
	var next_scene = "sala_01"
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")


func _on_btn_ranking_pressed() -> void:
	ui_efx()
	update_ranking()
	ranking_panel.visible = true


#func _on_button_pressed() -> void:
#	ui_efx()
#	ranking_panel.visible = false

#const SFX_FAST_UI_CLICK_METAL_05 = preload("uid://c2d4i1tvfeqvd")

func _on_btn_exit_pressed() -> void:
	ui_efx()
	get_tree().quit()

func ui_efx():
	ui_efect.play()


func _on_btn_close_ranking_pressed() -> void:
	ui_efx()
	ranking_panel.visible = false


func _on_btn_full_screen_pressed() -> void:
	#botão de tela cheia ou janela
	Nglobal.toggle_fullscreen()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_start"):
		var gm = get_tree().get_first_node_in_group("GameManager")
		if gm:
			gm.start_game()
