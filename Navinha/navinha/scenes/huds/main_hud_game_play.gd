extends CanvasLayer

@onready var score_label = $MarginContainer/VBoxContainerTop/TopBar/ScoreContainer/Score
@onready var highscore_label = $MarginContainer/VBoxContainerTop/TopBar/HScoreContainer/HighScore
@onready var stage_label = $MarginContainer/VBoxContainerTop/TopBar/StageContainer/Stage

@onready var transition_label: Label = $MarginContainer/VBoxContainerCenter/StageTransitionLabel

@onready var energy_bar = $MarginContainer/VBoxContainerBottom/HBoxContainer/EnergyContainer/TextureProgressBar
@onready var lives_container = $MarginContainer/VBoxContainerBottom/HBoxContainer/VBLiveContainer/LivesContainer

var blinking := false
var blink_timer : Timer


func _ready():
	add_to_group("hud")
	blink_timer = Timer.new()
	blink_timer.wait_time = 0.15
	blink_timer.autostart = false
	blink_timer.one_shot = false
	blink_timer.timeout.connect(_on_blink_timeout)
	add_child(blink_timer)

func _process(delta):
	update_score()
	update_energy()
	update_stage()
	update_lives()


func update_score():
	score_label.text = "%07d" % Global.score
	highscore_label.text = "%07d" % Global.highscore


func update_energy():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		energy_bar.max_value = player.max_health
		energy_bar.value = player.health


func update_lives():
	for child in lives_container.get_children():
		child.queue_free()
	
	for i in Global.lives:
		var sprite = TextureRect.new()
		sprite.texture = preload("res://Assets/Sprites/barhud/life_icon.png")
		sprite.custom_minimum_size = Vector2(24,24)
		lives_container.add_child(sprite)

func update_stage():
	if Global.is_boss:
		stage_label.text = str(Global.current_stage) + "-B"
	else:
		stage_label.text = str(Global.current_stage) + "-" + str(Global.current_level)


#func show_stage_message(text:String, duration:float = 2.0):
#	transition_label.text = text
#	transition_label.visible = true
#	transition_label.modulate.a = 0
#	
#	var tween = create_tween()
#	tween.tween_property(transition_label, "modulate:a", 1.0, 0.3)
#	tween.tween_interval(duration)
#	tween.tween_property(transition_label, "modulate:a", 0.0, 0.5)
#	tween.tween_callback(func(): transition_label.visible = false)

func show_stage_message(text:String, duration:float = 2.0):
	transition_label.text = text
	transition_label.visible = true
	transition_label.modulate.a = 0
	
	var tween = create_tween()
	tween.set_parallel(false)

	# Fade In
	tween.tween_property(transition_label, "modulate:a", 1.0, 0.4)

	# Piscar durante o tempo ativo
	tween.tween_callback(func(): start_blinking())
	tween.tween_interval(duration)

	# Parar de piscar
	tween.tween_callback(func(): stop_blinking())

	# Fade Out
	tween.tween_property(transition_label, "modulate:a", 0.0, 0.5)

	tween.tween_callback(func(): transition_label.visible = false)


func start_blinking():
	blinking = true
	blink_timer.start()

func stop_blinking():
	blinking = false
	blink_timer.stop()
	transition_label.visible = true

func _on_blink_timeout():
	if not blinking:
		return
	
	transition_label.visible = not transition_label.visible
