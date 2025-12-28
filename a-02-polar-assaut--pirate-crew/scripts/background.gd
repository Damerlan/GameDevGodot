extends Sprite2D

@onready var cam: Camera2D = get_parent() as Camera2D
@onready var viewport := get_viewport()

func _ready():
	ajustar_fundo()
	viewport.size_changed.connect(_on_viewport_resized)

func _process(_delta):
	if cam:
		global_position = cam.global_position

func _on_viewport_resized():
	ajustar_fundo()

func ajustar_fundo():
	if texture == null:
		return

	var viewport_size: Vector2 = viewport.get_visible_rect().size
	var texture_size: Vector2 = texture.get_size()

	var scale_x: float = viewport_size.x / texture_size.x
	var scale_y: float = viewport_size.y / texture_size.y

	var final_scale: float = max(scale_x, scale_y)
	scale = Vector2(final_scale, final_scale)
