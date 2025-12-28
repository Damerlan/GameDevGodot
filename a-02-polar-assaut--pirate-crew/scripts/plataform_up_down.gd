extends StaticBody2D

@export var visibility := 400

@export var amplitude := 32.0
@export var speed := 1.5

var base_y := 0.0
var player = null

@export var next_scene = "screen_manager" 	#definindo a sena que o player será jogado apos morrer

#signal morreu

func _ready() -> void:
	base_y = global_position.y
	player = get_tree().get_first_node_in_group("Player")


func _process(_delta: float) -> void:
	# Movimento vertical (sobe e desce)
	global_position.y = base_y + sin(Time.get_ticks_msec() * 0.002 * speed) * amplitude

	# Remove a plataforma quando o player já passou muito acima
	if player == null:
		return

	if position.y > player.position.y + visibility:
		queue_free()
	

func _on_spikes_bottom_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("take_hit"):
		body.take_hit()
		

	
func load_next_scene(): #avançã para a sena gerenciador >quetal fazer uma tela de loading aqui< -
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")	#troca de sena


# 🚀 Posição segura DEFINITIVA
func register_as_safe():
	Nglobal.last_safe_position = global_position
	Nglobal.last_safe_platform = self
		
