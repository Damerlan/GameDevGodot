extends Node

@onready var hud_record: CanvasLayer = $HudRecordName


func _ready() -> void:
	if Global.pending_record == true:
		hud_record.visible = true
		#hud_record.show_panel()
	else:
		#volta pro loby normal
		get_tree().change_scene_to_file("res://scenes/loby.tscn")
