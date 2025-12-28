extends CanvasLayer

@onready var btn_left = $TouchRoot/LeftControl/TSButtonLeft

#@onready var btn_right = $TouchRoot/TSButtonRight
@onready var btn_jump = $TouchRoot/RightControl/TSButtonJump



func _ready():
	pass

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

#jum
func _on_ts_button_jump_pressed() -> void:
	Input.action_press("jump")
	#print("Pulo Pressionado")

func _on_ts_button_jump_released() -> void:
	Input.action_release("jump")
	#print("Pulo Solto")

#togle Fullscreen
func _on_btn_full_screen_pressed() -> void:
	Nglobal.toggle_fullscreen()


func _on_ts_button_screen_pressed() -> void:
	Nglobal.toggle_fullscreen()

#soft jum
func _on_ts_button_soft_jump_pressed() -> void:
	Input.action_press("jump_soft")


func _on_ts_button_soft_jump_released() -> void:
	Input.action_release("jump_soft")
