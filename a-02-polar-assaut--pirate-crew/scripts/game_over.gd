extends Control

@onready var lbl_final_score: Label = $Panel/VBoxContainer/LabelFinalScore

@onready var lbl_altura: Label = $Panel/VBoxContainer/VBoxStats/LabelAltura
@onready var lbl_itens: Label = $Panel/VBoxContainer/VBoxStats/LabelItens
@onready var lbl_tempo: Label = $Panel/VBoxContainer/VBoxStats/LabelTempo

@onready var lbl_calc_altura: Label = $Panel/VBoxContainer/VBoxCalculo/LabelCalcAutura
@onready var lbl_calc_coleta: Label = $Panel/VBoxContainer/VBoxCalculo/LabelCalcColeta
@onready var lbl_calc_ef: Label = $Panel/VBoxContainer/VBoxCalculo/LabelCalcEficiencia
@onready var lbl_calc_tempo: Label = $Panel/VBoxContainer/VBoxCalculo/LabelCakcTempo

@onready var lbl_feedback: Label = $Panel/LabelFeedback

@onready var lbl_novo: Label = $Panel/LabelNovoRecorde
@onready var input_nome: LineEdit = $Panel/LineEditNome
@onready var btn_salvar: Button = $Panel/ButtonSalvar
@onready var game_over: AudioStreamPlayer = $"../GameOver2"

var final_score := 0



func _ready():
	game_over_play()
	var altura = ScoreManager.altura
	var itens = ScoreManager.itens
	ScoreManager.tempo = GameManager.tempo_partida
	var tempo = ScoreManager.tempo
	
	

	# --- Cálculos ---
	var pontos_altura = altura * 1.2
	var pontos_coleta = itens * 70
	var bonus_ef = (altura / max(tempo, 1)) * 45
	var penalidade = tempo * 1.0

	var total = int(pontos_altura + pontos_coleta + bonus_ef - penalidade)

	# --- Estatísticas brutas ---
	lbl_altura.text = "Altura Máx: %d m" % altura
	lbl_itens.text = "Itens Coletados: %d" % itens
	lbl_tempo.text = "Tempo: %02d:%02d" % [int(tempo) / 60, int(tempo) % 60]

	# --- Quebra do cálculo ---
	lbl_calc_altura.text = "Altura: +%d" % pontos_altura
	lbl_calc_coleta.text = "Coleta: +%d" % pontos_coleta
	lbl_calc_ef.text = "Eficiência: +%d" % bonus_ef
	lbl_calc_tempo.text = "Tempo: -%d" % penalidade

	# --- Score final ---
	lbl_final_score.text = str(total)

	# --- Feedback ---
	lbl_feedback.text = get_feedback(altura, tempo, itens)

	final_score = total #score calculado antes
	
	if SaveManager.is_new_record(final_score):
		lbl_novo.visible = true
		input_nome.visible = true
		btn_salvar.visible = true
	else:
		lbl_novo.visible = false
		input_nome.visible = false
		btn_salvar.visible = false

func get_feedback(altura:int, tempo:float, itens:int) -> String:
	if altura > 1800 and tempo < 70:
		return "🔥 Ritmo excelente!"
	if itens > 20 and tempo > 200:
		return "⚠ Boa coleta, mas demorou demais"
	if tempo < 60:
		return "💥 Speedrunner nato!"
	return "👏 Boa tentativa!"

func game_over_play():
	game_over.play()

func _on_button_salvar_pressed() -> void:
	var nome = input_nome.text.strip_edges()
	if nome == "":
		nome = "???"

	SaveManager.add_record(nome, final_score)

	input_nome.visible = false
	btn_salvar.visible = false
	lbl_novo.text = "RECORDE SALVO!"

	#show_ranking()


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_button_sair_pressed() -> void:
	var next_scene = "loby_01"
	clear_instance()
	get_tree().change_scene_to_file("res://scenes/" + next_scene +".tscn")

func clear_instance():
	ScoreManager.altura = 0
	ScoreManager.itens = 0
	ScoreManager.tempo = 0.0
	Nglobal.lives = 3
