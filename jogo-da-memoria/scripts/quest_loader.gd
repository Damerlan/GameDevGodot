extends Node
#class_name QuestLoader

var quests: Array = []

func load_quests(path: String = "res://data/quests.json") -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Não foi possível abrir quests.json")
		return

	var content := file.get_as_text()
	file.close()

	var json := JSON.new()
	var result := json.parse(content)

	if result != OK:
		push_error("Erro ao parsear quests.json")
		return

	quests = json.data["quests"]

func get_quest(index: int) -> Dictionary:
	if index < 0 or index >= quests.size():
		return {}
	return quests[index]

func get_total_quests() -> int:
	return quests.size()
