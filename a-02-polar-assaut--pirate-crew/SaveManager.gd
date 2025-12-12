extends Node
#class_name SaveManager

const SAVE_PATH := "user://savegame.json"

var highscore := Global.highscore
var highscore_name := Global.highscore_name
var last_run_score := Global.last_score

signal new_highscore(score)
signal highscore_saved(name, score)

func _ready():
	load_game()

# =========================================================
#  ↪ CHAMADA PELO JOGO QUANDO A PARTIDA TERMINA
# =========================================================
func register_score(score: int) -> void:
	last_run_score = score

	if score > highscore:
		# 👉 Aciona o sinal para o HUD abrir o formulário
		emit_signal("new_highscore", score)
	else:
		# 👉 Não é recorde, apenas salva o último score
		save_game()

# =========================================================
#  ↪ CHAMADO PELO HUD quando o jogador digita o nome
# =========================================================
func save_highscore_with_name(player_name: String) -> void:
	if player_name.strip_edges() == "":
		player_name = "Jogador"

	highscore = last_run_score
	highscore_name = player_name

	save_game()
	emit_signal("highscore_saved", player_name, highscore)

# =========================================================
#  ↪ SALVA NO ARQUIVO
# =========================================================
func save_game() -> void:
	var data := {
			"highscore": highscore,
			"highscore_name": highscore_name
		}
		
	if Global.step_record == true:
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify(data))
			file.close()

# =========================================================
#  ↪ CARREGA O ARQUIVO
# =========================================================
func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return

	var text := file.get_as_text()
	file.close()

	var result = JSON.parse_string(text)
	if result is Dictionary:
		highscore = result.get("highscore", 0)
		highscore_name = result.get("highscore_name", "Jogador")
