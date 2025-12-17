extends CanvasLayer

@onready var btn_left = $TouchRoot/TSButtonLeft
#@onready var btn_right = $TouchRoot/TSButtonRight
@onready var btn_jump = $TouchRoot/TSButtonJump

#var player = is_in_group("Player")

#func _ready() -> void:
#	pass
#	visible = OS.has_feature("mobile") \
#		or OS.has_feature("web_android") \
#		or OS.has_feature("web_ios")


#func _ready() -> void:
	#pass
	#visible = OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios")



func _ready():
	pass
	# Conecte os sinais ao código
#	btn_left.connect("pressed", self, "_on_ts_buto")
#	btn_left.connect("pressed", self, "_on_ts_button_left_pressed")
#	btn_left.connect("released", self, "_on_ts_button_left_released")
	
#	btn_right.connect("pressed", self, "_on_btn_right_pressed")
#	btn_right.connect("released", self, "_on_btn_right_released")
	
#	btn_jump.connect("pressed", self, "_on_btn_jump_pressed")
#	btn_jump.connect("released", self, "_on_btn_jump_released")

func _on_ts_button_left_pressed() -> void:
	Input.action_press("move_left")
	print("Botão Esquerdo Pressionado")

func _on_ts_button_left_released() -> void:
	Input.action_release("move_left")
	print("Botão Esquerdo Solto")

func _on_ts_button_right_pressed() -> void:
	Input.action_press("move_right")
	print("Botão Direito Pressionado")

func _on_ts_button_right_released() -> void:
	Input.action_release("move_right")
	print("Botão Direito Solto")

func _on_ts_button_jump_pressed() -> void:
	Input.action_press("jump")
	print("Pulo Pressionado")

func _on_ts_button_jump_released() -> void:
	Input.action_release("jump")
	print("Pulo Solto")

func _on_btn_full_screen_pressed() -> void:
	Nglobal.toggle_fullscreen()


func _on_ts_button_screen_pressed() -> void:
	Nglobal.toggle_fullscreen()
