extends Node2D

@onready var ranking_panel: Panel = $CanvasLayer/RankingPanel
@onready var vbox_ranking: VBoxContainer = $CanvasLayer/RankingPanel/VBoxContainer/VBoxRanking

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ranking_panel.visible = false


func update_ranking():
	for child in vbox_ranking.get_children():
		child.queue_free()

	var pos := 1
	for entry in SaveManager.ranking:
		var lbl = Label.new()
		lbl.text = "%dº  %s  -  %d" % [pos, entry.nome, entry.score]
		lbl.add_theme_font_size_override("font_size", 10)
		vbox_ranking.add_child(lbl)
		pos += 1


func _on_btn_start_pressed() -> void:
	var next_scene = "sala_01"
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")


func _on_btn_ranking_pressed() -> void:
	update_ranking()
	ranking_panel.visible = true


func _on_button_pressed() -> void:
	ranking_panel.visible = false


func _on_btn_exit_pressed() -> void:
	get_tree().quit()
