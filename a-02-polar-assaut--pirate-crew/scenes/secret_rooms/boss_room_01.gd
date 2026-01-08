extends Node2D



#@onready var boss: CharacterBody2D = $PiratePino

@export var dialogue_sequence := [
	{"speaker": "boss", "text": "Eu vou te fazer andar na prancha, intruso!"},
	{"speaker": "player", "text": "Devolva meu tesouro, Pirata!"},
	{"speaker": "boss", "text": "Hahaha! Venha pegar, projeto de marujo!"}
]

#@onready var player: CharacterBody2D = $PlayerPeko

#@onready var boss: CharacterBody2D = $PiratePino
@onready var player := get_tree().get_first_node_in_group("Player")
@onready var boss := get_tree().get_first_node_in_group("Boss")

#parametros de ajustes do player
@export var boss_jump_force := -420.0
@export var boss_soft_jump_multiplier := 0.8
@export var boss_momentum_jump_multiplier := 0.25


var dialogue_index := 0
var fight_started := false
var can_advance := false
var in_dialogue := false
var waiting_clear := false

func _ready():
	start_intro()
	#show_next_dialogue()



func on_boss_defeated():
	player.restore_default_jump()
	#GameManager.finalizar_partida()
	abrir_portas()


func abrir_portas() -> void:
	pass


func start_intro():
	player.can_control = false

	# 🔽 APLICA MECÂNICA DA SALA
	player.apply_boss_room_jump(
		boss_jump_force,
		boss_soft_jump_multiplier,
		boss_momentum_jump_multiplier
	)

	boss.state = boss.State.INTRO
	dialogue_index = 0
	in_dialogue = true
	waiting_clear = false
	show_next_dialogue()


func show_next_dialogue():
	if dialogue_index >= dialogue_sequence.size():
		end_intro()
		return

	var line = dialogue_sequence[dialogue_index]
	var balloon

	if line.speaker == "boss":
		balloon = boss.show_dialogue(line.text)
	else:
		balloon = player.show_dialogue(line.text)

	can_advance = false
	in_dialogue = true

	balloon.finished_typing.connect(_on_typing_finished, CONNECT_ONE_SHOT)

	dialogue_index += 1

func _on_typing_finished():
	can_advance = true
	
func end_intro():
	player.clear_dialogue()
	boss.clear_dialogue()

	in_dialogue = false
	waiting_clear = false

	player.can_control = true
	boss.state = boss.State.CHASE

	GameManager.iniciar_partida()

func _unhandled_input(event):
	if not in_dialogue or not can_advance:
		return

	if event.is_action_pressed("ui_accept"):
		player.clear_dialogue()
		boss.clear_dialogue()
		show_next_dialogue()
