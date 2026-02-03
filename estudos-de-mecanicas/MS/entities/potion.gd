extends Area2D

@export var fall_gravity := 500.0
var velocity := Vector2.ZERO
var broken := false


func _physics_process(delta):
	if broken:
		return

	velocity.y += fall_gravity * delta
	global_position += velocity * delta

func _on_body_entered(body):
	print("colidiu com:", body.name)
	if body.is_in_group("ground"):
		break_potion()


func break_potion():
	broken = true
	velocity = Vector2.ZERO
	$breakAnim.play("break")
	$CollisionShape2D.disabled = true



func _on_break_anim_animation_finished() -> void:
	queue_free()
