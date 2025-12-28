extends Node

@onready var hud_record: CanvasLayer = $HudRecordName

func _ready() -> void:
	GameManager.connect("partida_finalizada", _on_partida_finalizada)


func _on_partida_finalizada(_tempo):
	if Nglobal.pending_record:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/loby_01.tscn")



func _on_confirm_pressed():
	var edit = get_node("HudRecordName/Panel/LineEdit")
	var name = edit.text.strip_edges() # line_edit.text.strip_edges()
	
	if name == "":
		name = "Jogador"
	
	Nglobal.highscore_name = name
	if Nglobal.highscore < Nglobal.score:
		Nglobal.highscore = Nglobal.score
	Nglobal.pending_record = false
	
	#salva tudo
	SaveManager.save_game()
		
	get_tree().change_scene_to_file("res://scenes/loby_01.tscn")
