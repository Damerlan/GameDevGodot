extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var speed = 60
var direction = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta * direction

func set_direction(direction):#definindo a direção do projetil
	self.direction = direction #adiciona no self a direção recebida de fora
	anim.flip_h = direction < 0 #inverte a direção quando necessario
	


func _on_self_destruct_timer_timeout() -> void:
	queue_free()
