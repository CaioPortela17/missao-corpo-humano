extends CanvasLayer

# UI
@onready var question_label = $Panel/MarginContainer/VBoxContainer/QuestionLabel
@onready var option1 = $Panel/MarginContainer/VBoxContainer/Option1
@onready var option2 = $Panel/MarginContainer/VBoxContainer/Option2
@onready var option3 = $Panel/MarginContainer/VBoxContainer/Option3
@onready var feedback_label = $Panel/MarginContainer/VBoxContainer/FeedbackLabel

# Sons
@onready var son = $Som
@onready var acerto_som = $AcertoSom
@onready var erro_som = $ErroSom
@onready var derrota_som = $DerrotaSom

func _ready():

	hide()

	# Conexão com o QuestionManager
	if QuestionManager:
		QuestionManager.quiz_started.connect(_on_quiz_started)
		QuestionManager.answer_checked.connect(_on_answer_checked)

	# Botões
	option1.pressed.connect(func(): QuestionManager.check_answer(0))
	option2.pressed.connect(func(): QuestionManager.check_answer(1))
	option3.pressed.connect(func(): QuestionManager.check_answer(2))

func _on_quiz_started(data):

	show()

	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Música principal do quiz
	if son:
		son.play()

	question_label.text = data["pergunta"]

	option1.text = data["opcoes"][0]
	option2.text = data["opcoes"][1]
	option3.text = data["opcoes"][2]

	feedback_label.text = ""
	
	# RESETAR CORES
	reset_button_colors()

	set_buttons_disabled(false)

func _on_answer_checked(is_correct, attempts_left, explicacao):

# BOTÃO QUE FOI CLICADO
	var clicked_button = get_focused_button()


	if is_correct:

# botão verde
		if clicked_button:
			clicked_button.modulate = Color(0.2, 1.0, 0.2)

# animação
		pop_button(clicked_button)


		# Para música principal
		if son:
			son.stop()

		# Som de acerto
		if acerto_som:
			acerto_som.play()

		feedback_label.text = "Correto! Parabéns."

		set_buttons_disabled(true)

		await get_tree().create_timer(3).timeout

		close_quiz()

	else:

# botão vermelho
		if clicked_button:
			clicked_button.modulate = Color(1.0, 0.2, 0.2)

		# animação
		pop_button(clicked_button)

		# PRIMEIRO ERRO
		if attempts_left > 0:

			feedback_label.text = "Errado! Você tem mais uma chance."

			# pausa música principal
			if son:
				son.stop()

			# toca som de erro
			if erro_som:
				erro_som.play()

				# espera acabar
				await erro_som.finished

			# volta música principal
			if son:
				son.play()

		# SEGUNDO ERRO
		else:

			feedback_label.text = "Errou as duas!\n" + explicacao

			set_buttons_disabled(true)

			# para música principal
			if son:
				son.stop()

			# toca som de derrota
			if derrota_som:
				derrota_som.play()

			await get_tree().create_timer(10.0).timeout

			close_quiz()

func set_buttons_disabled(val: bool):

	option1.disabled = val
	option2.disabled = val
	option3.disabled = val

func close_quiz():

	hide()

	# Para todos os sons
	if son:
		son.stop()

	if erro_som:
		erro_som.stop()

	if acerto_som:
		acerto_som.stop()

	if derrota_som:
		derrota_som.stop()

	get_tree().paused = false

func reset_button_colors():

	option1.modulate = Color.WHITE
	option2.modulate = Color.WHITE
	option3.modulate = Color.WHITE

	option1.scale = Vector2.ONE
	option2.scale = Vector2.ONE
	option3.scale = Vector2.ONE

func get_focused_button():

	if option1.has_focus():
		return option1

	if option2.has_focus():
		return option2

	if option3.has_focus():
		return option3

	return null

func pop_button(button):

	if button == null:
		return

	var tween = create_tween()

	tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.08)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.08)
