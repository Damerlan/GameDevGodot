extends Area2D

@onready var anim: AnimatedSprite2D = $Anim
#@onready var collect_sound: AudioStreamPlayer2D = $collect_sound
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var collect_sound: AudioStreamPlayer2D = $cllect_sound

var collected := false

func _ready():
	# 🔗 Conecta os sinais corretamente
	anim.animation_finished.connect(_on_anim_animation_finished)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if collected:
		return

	if not body.is_in_group("Player"):
		return

	collected = true

	# 🔒 Desliga colisão
	collision.set_deferred("disabled", true)

	collect_sound.play()
	anim.play("collect")

func _on_anim_animation_finished() -> void:
	# 💚 adiciona vida
	Nglobal.add_life()
	queue_free()
