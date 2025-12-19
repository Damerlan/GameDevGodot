extends Control
class_name Card

enum CardState { FACE_DOWN, FACE_UP, LOCKED }
signal card_clicked(card: Card)

var state := CardState.FACE_DOWN

#@onready var sprite_front: Sprite2D = $SpriteFront
#@onready var sprite_back: Sprite2D = $SpriteBack
@onready var sprite_front: TextureRect = $SpriteFront
@onready var sprite_back: TextureRect = $SpriteBack

func _ready():
	$Button.pressed.connect(_on_button_pressed)
	_update_visual()

func _on_button_pressed():
	if state != CardState.FACE_DOWN:
		return
	card_clicked.emit(self)

func flip_up():
	state = CardState.FACE_UP
	_update_visual()

func flip_down():
	state = CardState.FACE_DOWN
	_update_visual()

func lock():
	state = CardState.LOCKED
	_update_visual()

func _update_visual():
	sprite_front.visible = state != CardState.FACE_DOWN
	sprite_back.visible = state == CardState.FACE_DOWN

func set_front_image(tex: Texture2D):
	sprite_front.texture = tex
