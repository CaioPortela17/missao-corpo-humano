extends Area2D

@onready var sprite = $Sprite2D

@export var theme : String

var pending_texture = null

var activated = false

var answered_correctly = false


func set_texture(tex):

	pending_texture = tex


func _ready():

	if pending_texture != null:

		sprite.texture = pending_texture

	connect(
		"body_entered",
		Callable(self, "_on_body_entered")
	)

	QuestionManager.answer_checked.connect(
		_on_answer_checked
	)


func _on_body_entered(body):

	if activated:
		return

	if body.is_in_group("player"):

		activated = true

		QuestionManager.request_quiz(theme)

func _on_answer_checked(is_correct, attempts_left, explicacao):

	if activated and is_correct:

		queue_free()
