extends Node2D

var item_scene = load("res://item.tscn")

@onready var spawn_points = $SpawnPoints.get_children()

# PLAYER
@onready var player = $Player

# PROGRESS BAR
@onready var progress_bar = $Progresso/ProgressBar

# TIMER
@onready var timer_label = $Progresso/TimerLabel

var alerta = false
var tempo_pisca = 0.0

# TRANSIÇÃO
@onready var transition = $Transition/Fill
@onready var animation = $Transition/Fill/animation

@export_enum(
	"Pixels",
	"Spot Player",
	"Spot Centro",
	"Corte Vertical"
) var transition_type = 1

@export var duration: float = 1.0

var changing_scene = false


func _ready():

	# RESETA O JOGO
	QuestionManager.start_game()

	# deixa clicar nos botões
	$Transition/Fill.mouse_filter = Control.MOUSE_FILTER_IGNORE

	transition.material.set_shader_parameter(
		"type",
		transition_type
	)

	animation.speed_scale = duration

	# animação quando entra na cena
	animation.play("transition_out")

	# CONFIGURA BARRA
	progress_bar.max_value = 6
	progress_bar.value = 0

	# RESET TIMER VISUAL
	timer_label.modulate = Color.WHITE

	# CONECTA SINAIS
	if not QuestionManager.item_collected.is_connected(_on_item_collected):

		QuestionManager.item_collected.connect(
			_on_item_collected
		)

	if not QuestionManager.game_over.is_connected(_on_game_over):

		QuestionManager.game_over.connect(
			_on_game_over
		)

	spawn_items()


func _process(delta):

	if changing_scene:
		return

	# TIMER
	var tempo = QuestionManager.current_time

	var minutos = int(tempo) / 60
	var segundos = int(tempo) % 60

	timer_label.text = "%02d:%02d" % [
		minutos,
		segundos
	]

	# ALERTA NOS ÚLTIMOS 15 SEGUNDOS
	if tempo <= 15:

		tempo_pisca += delta

		if tempo_pisca >= 0.3:

			tempo_pisca = 0

			alerta = !alerta

			if alerta:

				timer_label.modulate = Color.RED

			else:

				timer_label.modulate = Color.WHITE

	else:

		timer_label.modulate = Color.WHITE


func spawn_items():

	var items = [

		{
			"img":
				load("res://Missao Corpo Humano/items/apple_digestive.png"),
			"theme":
				"Sistema Digestório"
		},

		{
			"img":
				load("res://Missao Corpo Humano/items/blood_circulatory.png"),
			"theme":
				"Sistema Circulatório"
		},

		{
			"img":
				load("res://Missao Corpo Humano/items/bolt_nervous.png"),
			"theme":
				"Sistema Nervoso"
		},

		{
			"img":
				load("res://Missao Corpo Humano/items/bone_skeletal.png"),
			"theme":
				"Sistema Esquelético"
		},

		{
			"img":
				load("res://Missao Corpo Humano/items/bubble_respiratory.png"),
			"theme":
				"Sistema Respiratório"
		},

		{
			"img":
				load("res://Missao Corpo Humano/items/dumbbell_muscular.png"),
			"theme":
				"Sistema Muscular"
		},

		{
			"img":
				load("res://Missao Corpo Humano/items/eye_sensory.png"),
			"theme":
				"Sistema Sensorial"
		},

		{
			"img":
				load("res://Missao Corpo Humano/items/shield_immune.png"),
			"theme":
				"Sistema Imunológico"
		}
	]

	for i in range(items.size()):

		var item = item_scene.instantiate()

		item.position = spawn_points[i].position

		item.set_texture(
			items[i]["img"]
		)

		item.theme = items[i]["theme"]

		add_child(item)


# AUMENTA A BARRA
func _on_item_collected(item_name):

	progress_bar.value += 1


func _on_game_over(victory, items_collected):

	if changing_scene:
		return

	changing_scene = true

	animation.play("transition_in")

	await animation.animation_finished

	if get_tree():

		if victory:

			get_tree().change_scene_to_file(
				"res://Cenas/vitoria.tscn"
			)

		else:

			get_tree().change_scene_to_file(
				"res://Cenas/game_over.tscn"
			)
