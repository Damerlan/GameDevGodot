extends CanvasLayer

@onready var record_label: Label = $Control/RecordLabel
@onready var last_score_label: Label = $Control/LastScoreLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exibe_score()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	exibe_score()
	
func exibe_score():
	var high = SaveManager.data["hight_score"]
	var last = SaveManager.data["last_score"]
	var champion = SaveManager.data["hight_score_name"]
	
	record_label.text = "Recorde: " + str(high) + " (" + champion + ")"
	last_score_label.text = "Última Partida: " + str(last)
	#record_label.text = "Recorde: " + str(Global.highscore)
	#last_score_label.text = "Última partida: " + str(Global.last_score)
