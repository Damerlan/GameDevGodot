extends Node

var save_path := "user://savegame.json"

#dados padrão caso o save ainda nao exista
var data :={
	"hight_score": 0,
	"hight_score_name": "",
	"last_score": 0
}

func _ready() -> void:
	load_game()

#-----------------------------------------------
#Salvar os dados no arquivo
#-----------------------------------------------
func save_game():
	data["hight_score"] = Global.highscore
	data["last_score"] = Global.last_score
	data["hight_score_name"] = Global.highscore_name
	
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
	#------------------------------------------
	#Carregar dados do arquivo
	#------------------------------------------
#func load_game():
#	if not FileAccess.file_exists(save_path):
#		save_game() #cria arquivo novo se não existir
#		return
	
#	var file := FileAccess.open(save_path, FileAccess.READ)
#	var content := file.get_as_text()
#	file.close()
	
#	var result = JSON.parse_string(content)
#	if result is Dictionary:
#		data = result
	

func load_game():
	if not FileAccess.file_exists(save_path):
		print("SAVE NÃO EXISTE — criando novo...")
		save_game()
		return

	var file := FileAccess.open(save_path, FileAccess.READ)
	var content := file.get_as_text()
	file.close()

	print("Conteúdo carregado:", content)

	var result = JSON.parse_string(content)

	if result is Dictionary:
		data = result
		Global.highscore = data.get("hight_score", 0)
		Global.last_score = data.get("last_score", 0)
		Global.highscore_name = data.get("", "")
		print("LOAD SUCESSO:", data)
	else:
		print("ERRO NO JSON — recriando arquivo.")
		save_game()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
