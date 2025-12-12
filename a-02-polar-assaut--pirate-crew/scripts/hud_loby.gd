extends CanvasLayer

@onready var record_label: Label = $Control/RecordLabel
@onready var last_score_label: Label = $Control/LastScoreLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exibe_score()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	exibe_score()
	
func old_exibe_score():
	var high = Global.highscore
	var last = Global.last_score
	var champion = Global.highscore_name
	
	record_label.text = "Recorde: %s (%s)" % [high, champion]
	last_score_label.text = "Última Partida: " + str(last)
	#record_label.text = "Recorde: " + str(Global.highscore)
	#last_score_label.text = "Última partida: " + str(Global.last_score)
	
func exibe_score():
	SaveManager.load_game()
	
	var high = Global.highscore
	var last = Global.last_score
	var champion = Global.highscore_name
	
	record_label.text = "Recorde: %s (%s)" % [high, champion]
	last_score_label.text = "Última Partida: " + str(last)
