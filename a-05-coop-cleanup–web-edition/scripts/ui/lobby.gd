extends Control

@onready var room_code_label: Label = $Panel/MarginContainer/VBoxContainer/RoomInfo/RoomCodeLabel
@onready var ip_label: Label = $Panel/MarginContainer/VBoxContainer/RoomInfo/IpLabel
@onready var start_button: Button = $Panel/MarginContainer/VBoxContainer/PlayersList/StartButton

@onready var player_slots := []

func _ready():
	Network.lobby_updated.connect(update_players)
	Network.room_code_updated.connect(set_room_code)

	for child in $Panel/MarginContainer/VBoxContainer/PlayersList.get_children():
		if child.name.begins_with("PlayerSlot"):
			player_slots.append(child)

	clear_slots()

	if multiplayer.is_server():
		ip_label.text = "IP da sala: " + Network.get_local_ip()
	else:
		ip_label.text = "Conectando à sala..."

	# Atualiza estado inicial
	set_room_code(Network.get_room_code())
	update_players(Network.get_players(), Network.get_host_id())

func update_players(players: Array, host_id: int):
	clear_slots()

	var local_id := multiplayer.get_unique_id()
	start_button.disabled = local_id != host_id

	for i in range(players.size()):
		if i >= player_slots.size():
			break

		var slot = player_slots[i]
		slot.get_node("NameLabel").text = players[i].name
		slot.get_node("HostIcon").visible = players[i].id == host_id

func set_room_code(code: String):
	if code != "":
		room_code_label.text = "Sala: " + code

func clear_slots():
	for slot in player_slots:
		slot.get_node("NameLabel").text = "Aguardando..."
		slot.get_node("HostIcon").visible = false

func _on_start_button_pressed():
	Network.start_game()

func _on_back_button_pressed():
	Network.leave_room()
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
