extends Area2D

@onready var anim: AnimatedSprite2D = $Anim
@onready var gem_collect: AudioStreamPlayer = $GemCollect

var value = Nglobal.gem_value

signal collect_coin(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("collect_coin", Callable(self, "_on_collect"))


func _on_collect(v):
	ScoreManager.add_coin(v)
	queue_free()


func _on_body_entered(_body: Node2D) -> void:
	collect_efx()
	anim.play("colect")


func _on_anim_animation_finished() -> void:
	emit_signal("collect_coin", value)

func collect_efx():
	gem_collect.play()
