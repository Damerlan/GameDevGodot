extends Area2D

@export var speed : float = 200.0


var direction : Vector2 = Vector2.LEFT

func _ready():
	add_to_group("enemy_bullet")


func _process(delta):
	position += direction * speed * delta



func _on_area_entered(_area: Area2D) -> void:
	#if area.has_method("take_damage"):
	#	area.take_damage(1)
	#	queue_free()
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
		queue_free()
	
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
