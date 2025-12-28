extends Node


var tempo_partida: float = 0.0
var contando: bool = false

#@export var emergency_platform_scene: PackedScene
@export var emergency_offset := Vector2(0, 64)

enum GameState { LOBBY, PLAYING, GAME_OVER }

var state: GameState = GameState.LOBBY
var next_scene = "sala_01"

const EMERGENCY_PLATFORM_SCENE := preload(
	"res://plataforms/safe_plataform.tscn"
)
var world: Node
var emergency_platform: Node = null


signal tempo_atualizado(tempo: float)
signal partida_finalizada(tempo_final: float)

func _ready():
	Nglobal.connect("morreu", _on_player_morreu)
	add_to_group("GameManager")
	print("GameManager ativo, estado:", state)
	
func _on_player_morreu():
	finalizar_partida()
	
func iniciar_partida():
	tempo_partida = 0.0
	contando = true

func finalizar_partida():
	contando = false
	emit_signal("partida_finalizada", tempo_partida)

func _process(delta):
	if contando:
		tempo_partida += delta
		emit_signal("tempo_atualizado", tempo_partida)

func formatar_tempo(segundos: float) -> String:
	var total := int(segundos)
	var min := total / 60
	var sec := total % 60
	return "%02d:%02d" % [min, sec]

#verificação da safe
func is_safe_valid() -> bool:
	if Nglobal.last_safe_platform == null:
		return false

	if not is_instance_valid(Nglobal.last_safe_platform):
		return false

	return true

func spawn_emergency_platform(pos: Vector2):
	if emergency_platform and is_instance_valid(emergency_platform):
		return

	emergency_platform = EMERGENCY_PLATFORM_SCENE.instantiate()
	emergency_platform.global_position = pos

	world.get_node("YSort").add_child(emergency_platform)

	Nglobal.last_safe_platform = emergency_platform
	Nglobal.last_safe_position = pos


func start_game():
	match state:
		GameState.LOBBY:
			_start_from_lobby()
		GameState.GAME_OVER:
			_restart_from_game_over()
			
			
	
func _start_from_lobby():
	Nglobal.reset_run()
	state = GameState.PLAYING
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")


func _restart_from_game_over():
	Nglobal.reset_run()
	state = GameState.PLAYING
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")
