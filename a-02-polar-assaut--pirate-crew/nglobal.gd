extends Node

var lives = 3

var coin_value = 1
var gem_value = 100

var last_safe_position
var last_safe_platform: Node = null

signal autura_changed(value)
signal lives_changed
signal morreu

signal pause_requested

signal show_teclado
#signal collect_life

#@export var pause_menu = Control: get_tree()
@onready var pause_menu: Control = $PauseLayer/PauseMenu

func request_pause():#função para ativar o menu no mobile
	emit_signal("pause_requested")

func teclado_show() -> void:
	emit_signal("show_teclado")

func add_life(): #add +1 vida
	lives += 1
	emit_signal("lives_changed")

# dentro do Nglobal.gd
func remove_life():
	lives -= 1
	emit_signal("lives_changed")

	if lives <= 0:
		lives = 0
		emit_signal("morreu")
#	lives -= amount

#reseta a partida
			# vai para o lobby
func reset_run():
	lives = 3
	ScoreManager.altura = 0
	ScoreManager.tempo = 0.0
	ScoreManager.itens = 0
	last_safe_position = Vector2.ZERO


func update_autura(player_y):
	ScoreManager.altura = max(ScoreManager.altura, -player_y)
	emit_signal("autura_changed", ScoreManager.altura)
	return

func update_coleta(item):
	ScoreManager.itens = ScoreManager.itens + item
	return


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("TogleFullscreen"):
		toggle_fullscreen()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func toggle_fullscreen():
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#implementar para o menu
func toggle_menu() -> void:
	pass
