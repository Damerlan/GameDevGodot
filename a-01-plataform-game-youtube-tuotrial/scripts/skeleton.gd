extends CharacterBody2D

enum SkeletonState { #inicio da state machine
	walk,
	hurt#antigo dead
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D #animação do personagem
@onready var hitbox: Area2D = $Hitbox #hitbox para identificar colisões com o player
@onready var walk_detector: RayCast2D = $WalkDetector #detector de parede
@onready var ground_detector: RayCast2D = $GroundDetector



const SPEED = 20.0
const JUMP_VELOCITY = -400.0

var status: SkeletonState

var direction = 1

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

	move_and_slide()

#funções de entrada para o estado
func go_to_walk_state():
	status = SkeletonState.walk#inicia o status de caminhada
	anim.play("walk")#define a animação de caminhada

func go_to_hurt_state():
	status = SkeletonState.hurt#quando ele morre
	anim.play("hurt") #aplica a animação de morte
	hitbox.process_mode =Node.PROCESS_MODE_DISABLED #desabilita a colisao com o hitbox
	velocity = Vector2.ZERO #para a movimentação

#Funçoes de estado
func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if walk_detector.is_colliding():#se detectar a parede ele inverte o sentido
		scale.x *= -1
		direction *= -1
	
	if not ground_detector.is_colliding():#quando nao detectar o chao ele inverte o sentido
		scale.x *= -1
		direction *= -1

func dead_state(_delta):
	pass

func take_damage():
	go_to_hurt_state()
