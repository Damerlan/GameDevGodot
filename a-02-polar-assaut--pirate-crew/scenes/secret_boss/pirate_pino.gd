extends CharacterBody2D

enum State {
	IDLE,
	CHASE,
	STUN,
	DEAD
}

@export var damage_popup_scene: PackedScene

@export var speed: float = 140.0
@export var push_force: float = 260.0
@export var gravity: float = 900.0

@export var stun_time: float = 0.8

@onready var ray_left: RayCast2D = $LeftEdge
@onready var ray_right: RayCast2D = $RightEdge
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var state := State.CHASE
var stun_timer: float = 0.0
var player: CharacterBody2D

@export var max_life := 1000
@export var life := 1000
@export var head_hit_damage := 50

#avisando a plataforma do empacto
var was_airborne := false
var heavy_landing := false


#empurrando o player
@export var body_hit_cooldown := 0.2

var can_body_hit := true

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	anim.play("idle")


func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		move_and_slide()
		return
		
	_apply_gravity(delta)

	match state:
		State.CHASE:
			_chase_player(delta)
			_update_animation()
		State.STUN:
			_update_stun(delta)

	# ⚠️ MOVE PRIMEIRO
	move_and_slide()

	# 🛬 AGORA SIM detecta pouso
	if not is_on_floor():
		was_airborne = true

	if is_on_floor() and was_airborne:
		was_airborne = false

		if heavy_landing:
			heavy_landing = false

			var collision := get_last_slide_collision()
			if collision:
				var platform = collision.get_collider()
				if platform and platform.has_method("shake"):
					print("💥 CHAMANDO SHAKE")
					platform.shake()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func _update_animation() -> void:
	if abs(velocity.x) > 10:
		anim.play("run")
	else:
		anim.play("idle")

	# 🔥 SPRITE SEGUE O MOVIMENTO REAL
	anim.flip_h = velocity.x > 0



func _chase_player(_delta):
	if player == null:
		velocity.x = 0
		return

	var dx: float = player.global_position.x - global_position.x

	# zona morta → não vira, não anda
	if abs(dx) < 6.0:
		velocity.x = 0
		return

	var dir: int = sign(dx)

	# proteção contra buracos
	if dir < 0 and not ray_left.is_colliding():
		velocity.x = 0
		return
	elif dir > 0 and not ray_right.is_colliding():
		velocity.x = 0
		return

	velocity.x = dir * speed



func _update_stun(delta):
	if state == State.DEAD:
		return

	stun_timer -= delta
	velocity.x = lerp(velocity.x, 0.0, delta * 6)

	if stun_timer <= 0:
		state = State.CHASE

#quando o player pula na cabeça do boss
func on_player_jump_on_head(player: CharacterBody2D):
	if state == State.DEAD:
		return
	if state == State.STUN:
		return
	
	# 🔴 CAUSA DANO
	life -= head_hit_damage
	_show_damage(head_hit_damage)
	print("💀 Boss life:", life)
		
	anim.play("hit")
	
	#entrando em stun
	state = State.STUN
	stun_timer = stun_time
	
	#direção contraria ao player
	var dir = sign(global_position.x - player.global_position.x)
	if dir == 0:
		dir = -1 if randf() < 0.5 else 1
	
	#kinockback no bos
	velocity.x = dir * push_force
	velocity.y = -120
	
	heavy_landing = true   # 💥 ISSO É ESSENCIAL
	
	# 💥 knockback no player
	if player.has_method("apply_knockback"):
		player.apply_knockback(-dir)
	else:
		player.velocity.x = -dir * 180
		player.velocity.y = -420
	
	# ☠️ MORTE DO BOSS
	if life <= 0:
		die()


func _show_damage(amount: int):
	if damage_popup_scene == null:
		return

	var popup := damage_popup_scene.instantiate()
	get_parent().add_child(popup)

	popup.global_position = global_position + Vector2(0, -24)
	popup.setup(-amount)
	

func die():
	state = State.DEAD
	velocity = Vector2.ZERO

	anim.play("death")

	# impacto final
	heavy_landing = true
	velocity.y = -20

	print("☠️ Boss morreu de verdade")

	await anim.animation_finished
	queue_free()


func _on_heady_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		on_player_jump_on_head(body)


func _on_body_hit_area_body_entered(body: Node2D) -> void:
	if state == State.DEAD:
		return
	if state == State.STUN:
		return
	if not can_body_hit:
		return
	if not body.is_in_group("Player"):
		return

	_apply_body_knockback(body)
	

func _apply_body_knockback(player: CharacterBody2D):
	can_body_hit = false

	# direção PARA LONGE do boss
	var dir: int = sign(player.global_position.x - global_position.x)
	if dir == 0:
		dir = -1 if randf() < 0.5 else 1

	# 💥 knockback no player
	player.velocity.x = dir * 520
	player.velocity.y = -180

	# animação de impacto
	# if anim:
	#	anim.play("push")

	# cooldown
	await get_tree().create_timer(body_hit_cooldown).timeout
	can_body_hit = true


func apply_knockback():
	velocity.y = -500
	heavy_landing = true
