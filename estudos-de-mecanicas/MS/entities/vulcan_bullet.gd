extends Node2D

@export var speed: float = 800.0
@export var life_time: float = 2.0

var timer := 0.0

func _process(delta):
	position += transform.x * speed * delta
	
	timer += delta
	if timer > life_time:
		queue_free()
