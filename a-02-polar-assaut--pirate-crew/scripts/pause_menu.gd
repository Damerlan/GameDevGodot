extends Control

@export var main_menu_scene := "res://scenes/loby_02.tscn"
@onready var ui_efect: AudioStreamPlayer = $ui_efect

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		resume_game()
	else:
		pause_game()

func pause_game():
	get_tree().paused = true
	show()

func resume_game():
	hide()
	get_tree().paused = false

# -----------------------------
# BOTÕES
# -----------------------------

func _on_btn_return_pressed() -> void:
	ui_efx()
	resume_game()

func _on_btn_loby_pressed() -> void:
	ui_efx()
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu_scene)

func _on_btn_return_3_pressed() -> void:
	ui_efx()
	get_tree().quit()

func ui_efx():
	ui_efect.play()
