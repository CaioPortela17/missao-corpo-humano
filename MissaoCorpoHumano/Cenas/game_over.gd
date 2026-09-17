extends Control

@onready var transition = $Transition/Fill
@onready var animation = $Transition/Fill/animation

@export_enum(
	"Pixels",
	"Spot Player",
	"Spot Centro",
	"Corte Vertical"
) var transition_type = 0

@export var duration: float = 1.0


func _ready() -> void:
	# deixa clicar nos botões
	$Transition/Fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	transition.material.set_shader_parameter("type", transition_type)
	animation.speed_scale = duration
	
	# animação quando entra na cena
	animation.play("transition_out")


func _on_button_pressed() -> void:
	# animação quando sai da cena
	animation.play("transition_in")
	
	await animation.animation_finished
	
	get_tree().change_scene_to_file("res://Cenas/menu.tscn")
