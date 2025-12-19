extends Node

@export var card_scene: PackedScene
@export var quests_file_path := "res://data/quests.json"
@export var cards_file_path := "res://data/cards.json"
@export var card_size := Vector2(96, 140)

@onready var label_top: Label = $Control/VBoxContainer/LabelTop
@onready var board: GridContainer = $Control/VBoxContainer/Board

var rounds: Array = []
var all_cards: Array = []
var current_round := 0

# === STATES ===
var first_card: Card
var second_card: Card
var is_checking := false
var pairs_found := 0
var sequence_index := 0
var timer: SceneTreeTimer

func _ready():
	randomize()
	load_cards()
	load_quests()
	start_round()

# ================= LOAD =================
func load_cards():
	var f := FileAccess.open(cards_file_path, FileAccess.READ)
	var j := JSON.new()
	j.parse(f.get_as_text())
	all_cards = j.data["cards"]

func load_quests():
	var f := FileAccess.open(quests_file_path, FileAccess.READ)
	var j := JSON.new()
	j.parse(f.get_as_text())
	rounds = j.data["rounds"]

# ================= ROUND =================
func start_round():
	clear_board()

	if current_round >= rounds.size():
		print("🎉 Fim do jogo")
		return

	var r: Dictionary = rounds[current_round]

	label_top.text = r["question"]

	var cards := build_cards(r)
	spawn_cards(cards)

	if r.type == "time_attack":
		start_timer(r.time_limit)

# ================= BUILD =================
func build_cards(r: Dictionary) -> Array:
	match r.type:
		"find_correct", "time_attack":
			return build_find_correct(r)
		"pairs":
			return build_pairs(r.pairs)
		"sequence":
			return build_sequence(r.sequence)
		"logic":
			return build_logic(r)
	return []

func build_find_correct(r):
	var cards := []
	var correct = get_card_by_id(r.correct_card_id)
	cards.append(correct)

	var pool = all_cards.filter(func(c): return c.id != correct.id)
	pool.shuffle()

	while cards.size() < r.total_cards:
		cards.append(pool.pop_back())

	cards.shuffle()
	return cards

func build_pairs(count: int):
	var pool = all_cards.duplicate()
	pool.shuffle()
	var cards := []

	for i in count:
		var c = pool.pop_back()
		cards.append(c)
		cards.append(c)

	cards.shuffle()
	return cards

func build_sequence(seq: Array):
	return seq.map(func(id): return get_card_by_id(id))

func build_logic(r):
	var pool = all_cards.duplicate()
	pool.shuffle()
	return pool.slice(0, r.total_cards)

# ================= SPAWN =================
func spawn_cards(cards: Array):
	board.columns = int(ceil(sqrt(cards.size())))

	for c in cards:
		var card := card_scene.instantiate()
		board.add_child(card)
		card.custom_minimum_size = card_size
		card.set_meta("data", c)
		card.set_front_image(load("res://assets/cards/" + c.image))
		card.card_clicked.connect(_on_card_clicked)

# ================= CLICK =================
func _on_card_clicked(card: Card):
	var r: Dictionary = rounds[current_round]
	match r.type:
		"find_correct", "time_attack":
			check_find_correct(card)
		"pairs":
			check_pairs(card)
		"sequence":
			check_sequence(card)
		"logic":
			check_logic(card)

# ================= MODES =================
func check_find_correct(card):
	if not is_instance_valid(card):
		return

	card.flip_up()

	var data: Dictionary = card.get_meta("data")

	if data.get("id", -1) == rounds[current_round].correct_card_id:
		next_round()
	else:
		await wait(0.6)

		if is_instance_valid(card):
			card.flip_down()
			
			
func check_pairs(card):
	if is_checking or card.state != Card.CardState.FACE_DOWN:
		return

	card.flip_up()
	if not first_card:
		first_card = card
		return

	second_card = card
	is_checking = true
	await wait(0.6)

	if first_card.get_meta("data").id == second_card.get_meta("data").id:
		first_card.lock()
		second_card.lock()
		pairs_found += 1
	else:
		first_card.flip_down()
		second_card.flip_down()

	first_card = null
	second_card = null
	is_checking = false

	if pairs_found >= rounds[current_round].pairs:
		pairs_found = 0
		next_round()

func check_sequence(card: Card):
	var round: Dictionary = rounds[current_round]
	var sequence: Array = round.get("sequence", [])

	if sequence.is_empty():
		return

	var expected: int = sequence[sequence_index]

	card.flip_up()

	var data: Dictionary = card.get_meta("data")

	if data.get("id", -1) == expected:
		sequence_index += 1
		if sequence_index >= sequence.size():
			sequence_index = 0
			next_round()
	else:
		sequence_index = 0
		start_round()

func check_logic(card: Card):
	var round: Dictionary = rounds[current_round]
	var tag: String = round.get("required_tag", "")

	card.flip_up()

	var data: Dictionary = card.get_meta("data")
	var tags: Array = data.get("tags", [])

	if not tags.has(tag):
		await wait(0.6)
		start_round()


# ================= TIMER =================
func start_timer(seconds):
	timer = get_tree().create_timer(seconds)
	timer.timeout.connect(func(): start_round())

# ================= UTILS =================
func get_card_by_id(id):
	for c in all_cards:
		if c.id == id:
			return c
	return null

func next_round():
	await wait(0.6)
	current_round += 1
	start_round()

func clear_board():
	for c in board.get_children():
		c.queue_free()

func wait(t): return get_tree().create_timer(t).timeout
