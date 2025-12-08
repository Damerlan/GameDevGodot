extends CharacterBody2D

enum SkeletonState { #inicio da state machine
	walk,
	hurt,#antigo dead
	atack
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D #animação do personagem
@onready var hitbox: Area2D = $Hitbox #hitbox para identificar colisões com o player
@onready var walk_detector: RayCast2D = $WalkDetector #detector de parede
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var bone_start_position: Node2D = $BoneStartPosition


const SPINNING_BONE = preload("uid://ho3a0dcdxtbp")#referencia do projetil bone


const SPEED = 10.0
const JUMP_VELOCITY = -400.0

var status: SkeletonState

var direction = 1
var can_trow = true #pode atacar

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#state Machine
	match status:
		SkeletonState.walk:
			walk_state(delta)
		SkeletonState.hurt:#quando ele morre
			dead_state(delta)
		SkeletonState.atack:
			atack_state(delta)

	move_and_slide()

#funções de entrada para o estado
func go_to_walk_state():#entrada pro estado de caminhada
	status = SkeletonState.walk#inicia o status de caminhada
	anim.play("walk")#define a animação de caminhada

func go_to_hurt_state():#entrada pro estado de morte
	status = SkeletonState.hurt#quando ele morre
	anim.play("hurt") #aplica a animação de morte
	hitbox.process_mode =Node.PROCESS_MODE_DISABLED #desabilita a colisao com o hitbox
	velocity = Vector2.ZERO #para a movimentação

func go_to_atack_state():#entrada pro estado de ataque
	status = SkeletonState.atack
	anim.play("atack")
	velocity = Vector2.ZERO
	can_trow = true #pode atacar


#Funçoes de estado
func walk_state(_delta): #estado de caminhada
	if anim.frame == 3 or anim.frame == 4:#corrigido os frames de movimento do esqueleto
		velocity.x = SPEED * direction
	else:
		velocity.x = 0
	
	if walk_detector.is_colliding():#se detectar a parede ele inverte o sentido
		scale.x *= -1
		direction *= -1
	
	if not ground_detector.is_colliding():#quando nao detectar o chao ele inverte o sentido
		scale.x *= -1
		direction *= -1
	
	if player_detector.is_colliding():
		go_to_atack_state()
		return

func atack_state(_delta): #estado de ataque
	if anim.frame == 2 && can_trow:
		drop_bone()
		can_trow = false #nao pode atacar

func dead_state(_delta): #estado de morte
	pass

func take_damage():
	go_to_hurt_state()

func drop_bone():
	var new_bone = SPINNING_BONE.instantiate() #cria a instancia do projetil
	add_sibling(new_bone) #coloca a instancia na cena
	new_bone.position = bone_start_position.global_position #definindo o spawn no marcador 
	new_bone.set_direction(self.direction)#definindo a direção do projetil com a direção do personagem
	

func _on_animated_sprite_2d_animation_finished() -> void: #quando terminar a animação
	if anim.animation == "atack":
		go_to_walk_state()
