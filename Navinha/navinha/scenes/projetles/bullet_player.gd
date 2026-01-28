extends Area2D

@export var speed : float = 900.0

func _process(delta):
	position.x += speed * delta
	
	if position.x > get_viewport_rect().size.x + 100:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(1)
		spawn_hit()
		queue_free()

func spawn_hit():
	var hitdmg = preload("res://scenes/projetles/projetil_damage.tscn").instantiate()
	hitdmg.global_position = global_position
	get_tree().current_scene.add_child(hitdmg)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(2)
		spawn_hit()
		queue_free()
