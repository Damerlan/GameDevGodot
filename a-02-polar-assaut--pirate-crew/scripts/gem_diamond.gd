extends Area2D

@onready var anim: AnimatedSprite2D = $Anim
@onready var gem_collect: AudioStreamPlayer = $GemCollect
@onready var collision: CollisionShape2D = $CollisionShape2D

var value = Nglobal.gem_value
var collected := false

signal collect_coin(value)

func _ready() -> void:
	connect("collect_coin", Callable(self, "_on_collect"))

func _on_body_entered(_body: Node2D) -> void:
	if collected:
		return

	collected = true
	
	# 🔒 Desliga a colisão imediatamente
	collision.set_deferred("disabled", true)

	collect_efx()
	anim.play("colect")

func _on_anim_animation_finished() -> void:
	emit_signal("collect_coin", value)

func _on_collect(v):
	ScoreManager.add_coin(v)
	queue_free()

func collect_efx():
	gem_collect.play()
