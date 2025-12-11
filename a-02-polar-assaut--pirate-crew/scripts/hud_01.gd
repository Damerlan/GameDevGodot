extends CanvasLayer

@onready var score_label = $Control/LabelScore
@onready var lives_label = $Control/LabelLife



func _ready() -> void:
	#atuliza ao iniciar
	update_score()
	
	#conecta os sinais
	Global.score_changed.connect(_on_score_changed)
	Global.lives_changed.connect(_on_score_changed)
	
func _on_score_changed(value):
	score_label.text = str(value)
	
func _on_lives_changed(value):
	lives_label.text = str(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_score()

func update_score():
	score_label.text = str(Global.score)
	lives_label.text = str(Global.lives)
