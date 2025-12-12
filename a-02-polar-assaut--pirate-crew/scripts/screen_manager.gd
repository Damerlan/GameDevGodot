extends Node

@onready var hud_record: CanvasLayer = $HudRecordName

func _ready() -> void:
	
	if Global.pending_record == true:
		hud_record.visible = true
		#hud_record.show_panel()
		if Input.is_action_just_pressed("salvar"):
			_on_confirm_pressed()
	else:
		#volta pro loby normal
		get_tree().change_scene_to_file("res://scenes/loby.tscn")





func _on_confirm_pressed():
	var edit = get_node("HudRecordName/Panel/LineEdit")
	var name = edit.text.strip_edges() # line_edit.text.strip_edges()
	
	if name == "":
		name = "Jogador"
	
	Global.highscore_name = name
	if Global.highscore < Global.score:
		Global.highscore = Global.score
	Global.pending_record = false
	
	#salva tudo
	SaveManager.save_game()
		
	get_tree().change_scene_to_file("res://scenes/loby.tscn")
