extends Node2D

@export var float_distance := 20.0
@export var duration := 0.5
@export var start_scale := Vector2(0.6, 0.6)
@export var end_scale := Vector2(1.2, 1.2)

@onready var label: Label = $Label

func setup(value: int):
	label.text = str(value)
	label.modulate = Color(1, 1, 0) # amarelo
	scale = start_scale

func _ready():
	# 🔥 ISSO RESOLVE O PROBLEMA DO "CANTO DA TELA"
	top_level = true

	var start_pos := global_position
	var end_pos := start_pos + Vector2(0, -float_distance)

	var tween := create_tween()
	tween.set_parallel(true)

	# 🔼 sobe
	tween.tween_property(
		self,
		"global_position",
		end_pos,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# 🔍 cresce
	tween.tween_property(
		self,
		"scale",
		end_scale,
		duration
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# 🎨 amarelo → vermelho
	tween.tween_property(
		label,
		"modulate",
		Color(1, 0.2, 0.2),
		duration
	)

	# 🌫️ fade
	tween.tween_property(
		label,
		"modulate:a",
		0.0,
		duration
	)

	tween.finished.connect(queue_free)
