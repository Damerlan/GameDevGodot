extends CharacterBody2D

@export var atlas: Texture2D

@export var atlas_texture: Texture2D

@onready var base: Sprite2D = $Base
@onready var turret: Sprite2D = $Turret

var frame_size := Vector2(80, 60)

func _ready():
	setup_sprite(base)
	setup_sprite(turret)

	set_base_frame(0)
	set_turret_frame(0)


func setup_sprite(sprite: Sprite2D):
	var atlas := AtlasTexture.new()
	atlas.atlas = atlas_texture
	atlas.region = Rect2(Vector2.ZERO, frame_size)
	sprite.texture = atlas


func set_base_frame(index: int):
	var atlas := base.texture as AtlasTexture
	atlas.region.position = Vector2(index * frame_size.x, 0)


func set_turret_frame(index: int):
	var atlas := turret.texture as AtlasTexture
	atlas.region.position = Vector2(index * frame_size.x, frame_size.y)
