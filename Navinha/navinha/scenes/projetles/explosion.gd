extends Node2D


func _on_timer_timeout() -> void:
	#queue_free()
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
