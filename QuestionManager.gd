extends Node

# Sinais
signal quiz_started(pergunta_data)
signal answer_checked(is_correct, attempts_left, explicacao)
signal item_collected(item_name)
signal item_lost(item_name)
signal timer_updated(time_left)
signal game_over(victory, items_collected)

# Configurações
const TOTAL_ITEMS_IN_MAP = 8
const ITEMS_TO_WIN = 6
const GAME_TIME_LIMIT = 120.0

# Estado do jogo
var questions_db = {}

var items_collected_count = 0
var items_processed_count = 0
var wrong_answers_count = 0

var current_time = GAME_TIME_LIMIT
var is_game_active = false

# EVITA GAME OVER DUPLICADO
var game_finished = false

# Estado do quiz atual
var current_question_data = null

var current_attempts = 0
var max_attempts = 2

# Evitar repetição
var used_questions = {}

func _ready():

	randomize()

	print("QUESTION MANAGER INICIADO")

	load_questions()

	start_game()

func load_questions():

	var file_path = "res://perguntas.json"

	if FileAccess.file_exists(file_path):

		var file = FileAccess.open(
				file_path,
				FileAccess.READ
			)

		var json_text = file.get_as_text()

		var json = JSON.new()

		var error = json.parse(json_text)

		if error == OK:

			questions_db = json.data

			for tema in questions_db.keys():

				used_questions[tema] = []

			print("PERGUNTAS CARREGADAS")

			print(
				questions_db.keys()
			)

		else:

			print(
				"ERRO NO JSON:"
			)

			print(
				json.get_error_message()
			)

	else:

		print(
			"ARQUIVO perguntas.json NÃO ENCONTRADO"
		)

func start_game():

	# RESETA TUDO
	items_collected_count = 0

	items_processed_count = 0

	wrong_answers_count = 0

	current_time = GAME_TIME_LIMIT

	is_game_active = true

	game_finished = false

	current_question_data = null

	current_attempts = 0

	# RESETA PERGUNTAS USADAS
	for tema in used_questions.keys():

		used_questions[tema] = []

	set_process(true)

	print("JOGO RESETADO")

func _process(delta):

	if is_game_active:

		current_time -= delta

		emit_signal(
			"timer_updated",
			current_time
		)

		if current_time <= 0:

			end_game()

func request_quiz(tema):

	if not questions_db.has(tema):

		print(
			"TEMA NÃO ENCONTRADO:"
		)

		print(tema)

		return

	var available_questions = []

	var all_questions = questions_db[tema]

	for i in range(
		all_questions.size()
	):

		if not i in used_questions[tema]:

			available_questions.append(i)

	# resetar perguntas usadas
	if available_questions.size() == 0:

		used_questions[tema] = []

		for i in range(
			all_questions.size()
		):

			available_questions.append(i)

	var random_idx = available_questions[
			randi() %
			available_questions.size()
		]

	used_questions[tema].append(
		random_idx
	)

	current_question_data = all_questions[random_idx]

	current_attempts = 0

	print("PERGUNTA ESCOLHIDA:")

	print(
		current_question_data["pergunta"]
	)

	emit_signal(
		"quiz_started",
		current_question_data
	)

func check_answer(answer_idx):

	if game_finished:
		return

	current_attempts += 1

	var is_correct = (
			answer_idx ==
			current_question_data["correta"]
		)

	var attempts_left = max_attempts - current_attempts

	emit_signal(
		"answer_checked",
		is_correct,
		attempts_left,
		current_question_data["explicacao"]
	)

	if is_correct:

		collect_item()

	elif attempts_left <= 0:

		lose_item()

func collect_item():

	if game_finished:
		return

	items_collected_count += 1

	items_processed_count += 1

	emit_signal(
		"item_collected",
		"Item"
	)

	check_victory_condition()

func lose_item():

	if game_finished:
		return

	items_processed_count += 1
	
	wrong_answers_count += 1

	emit_signal(
		"item_lost",
		"Item"
	)

	check_victory_condition()

func check_victory_condition():

	# VITÓRIA
	if items_collected_count >= ITEMS_TO_WIN:

		end_game()

		return

	# DERROTA
	if wrong_answers_count >= 3:

		end_game()

		return

func end_game():

	# EVITA CHAMAR 2 VEZES
	if game_finished:
		return

	game_finished = true

	is_game_active = false

	set_process(false)

	var victory = items_collected_count >= ITEMS_TO_WIN

	emit_signal(
		"game_over",
		victory,
		items_collected_count
	)

	print("GAME OVER")
		   
	if victory:

		print("VITÓRIA")

	else:

		print("DERROTA")
