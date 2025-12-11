extends StaticBody2D


@export var amplitude := 32.0
@export var speed := 2.0

var base_y := 0.0

func _ready():
	base_y = global_position.y

func _process(_delta):
	global_position.y = base_y + sin(Time.get_ticks_msec() * 0.002 * speed) * amplitude
