extends CanvasLayer

#signal submitted(text) #sinal customisado pra carregar dados

@onready var line_edit: LineEdit = $Panel/LineEdit
@onready var button: Button = $Panel/Button
var saved: bool = false



func _ready() -> void:
	if Global.pending_record == false:
		self.visible = true
	else:
		self.visible = false
	#visible = false
	#button.pressed.connect(_on_confirm_pressed)
	

func _on_button_pressed() -> void:
	Global.highscore_name = line_edit.text.strip_edges()
	Global.highscore = Global.score
	Global.last_score = Global.score
	Global.step_record = true
	
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://scenes/loby.tscn")
