extends Area2D

@export var fall_speed: float = 100.0

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", position.y - 10, 0.6).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", position.y + 10, 0.6).set_trans(Tween.TRANS_SINE)


func _physics_process(delta):
	position.x -= fall_speed * delta  # anda para esquerda


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.activate_missile()
		queue_free()
