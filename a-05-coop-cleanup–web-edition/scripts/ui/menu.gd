extends Control

#@onready var nick_input: LineEdit = $Panel/MarginContainer/VBoxContainer/NickNameContainer/NickInput
@onready var nick_input: LineEdit = $Panel/MarginContainer/VBoxContainer/NickNameContainer/NickInput
@onready var ip_input: LineEdit = $Panel/MarginContainer/VBoxContainer/ButtonsContainer/EntrarContainer/IpInput


const SAVE_FILE := "user://coop_cleanup-we.save"

func _ready():
	load_nickname()


func load_nickname():
	if not FileAccess.file_exists(SAVE_FILE):
		nick_input.text = generate_random_nick()
		return

	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		nick_input.text = generate_random_nick()
		return

	nick_input.text = file.get_line()
	file.close()

func save_nickname():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file == null:
		print("⚠️ Não foi possível salvar nickname (provável HTML5)")
		return
	file.store_line(nick_input.text)
	file.close()

func generate_random_nick() -> String:
	return "Player" + str(randi_range(1000, 9999))


func _on_host_button_pressed() -> void:
	save_nickname()
	Network.host_game(nick_input.text)
	get_tree().change_scene_to_file("res://scenes/ui/lobby.tscn")



func _on_join_button_pressed() -> void:
	save_nickname()
	Network.join_game(ip_input.text, nick_input.text)
	get_tree().change_scene_to_file("res://scenes/ui/lobby.tscn")
	
