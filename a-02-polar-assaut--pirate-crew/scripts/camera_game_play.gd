extends Camera2D

var target: Node2D #declarando o alvo

#função quando o no é criado
func _ready() -> void:
	get_target()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = target.position


#função para pegar o no player
func get_target():
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() == 0:
		push_error("Player não Encontrado!")
		return
		
	target = nodes[0]#pega o primeiro da lista caso aja mais do que 1
	
