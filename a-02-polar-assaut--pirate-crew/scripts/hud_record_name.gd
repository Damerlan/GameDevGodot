extends CanvasLayer

@onready var line_edit: LineEdit = $Panel/LineEdit
@onready var button: Button = $Panel/Button
var saved: bool = false

func show_panel():
	visible = true
	line_edit.grab_focus()

func _ready() -> void:
	if visible == false:
		return
	else:
		_on_confirm_pressed()
	#visible = false
	#button.pressed.connect(_on_confirm_pressed)
	
func _input(_event):
	#teclado - ENTER
	if Input.is_action_pressed("salvar"):
		_on_confirm_pressed()
	
	#if event is InputEventKey and event.is_pressed():
	#	if event.keycode == KEY_ENTER or event.keycide == KEY_KP_ENTER:
	#		_on_confirm_pressed()
		
	#if event is InputEventJoypadButton and event.pressed:
	#	if event.button_index == JOY_BUTTON_A:
	#		_on_confirm_pressed()

func _on_confirm_pressed():
	if saved:
		return
	
	var name = line_edit.text.strip_edges()
	
	if name == "":
		name = "Jogador"
	
	Global.highscore_name = name
	if Global.highscore < Global.score:
		Global.highscore = Global.score
	Global.pending_record = false
	
	#salva tudo
	SaveManager.save_game()
	
	saved = true
	
	get_tree().change_scene_to_file("res://scenes/loby.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
