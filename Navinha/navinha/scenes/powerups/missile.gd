extends Area2D

var speed : float = 300
var target : Node2D
var rotation_speed : float = 5.0

func set_target(t):
	target = t

func _physics_process(delta):
	if target == null or not is_instance_valid(target):
		target = find_new_target()
		
		if target == null:
			queue_free()
			return
	
	var direction = (target.global_position - global_position).normalized()
	
	rotation = direction.angle()
	position += direction * speed * delta


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(100)
		explode()

	elif body.is_in_group("enemy_projectile"):
		body.queue_free()
		explode()


func explode():
	spawn_explosion()
	queue_free()


func _on_VisibleOnScreenNotifier2D_screen_exited():
	queue_free()

func spawn_explosion():
	var explosion = preload("res://scenes/projetles/explosion.tscn").instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)

func find_new_target():
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	if enemies.size() == 0:
		return null
	
	var nearest = null
	var min_dist = INF
	
	for e in enemies:
		if not is_instance_valid(e):
			continue
			
		var dist = global_position.distance_to(e.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest = e
	
	return nearest
