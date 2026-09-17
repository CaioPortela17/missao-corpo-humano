extends Area2D

@export var speed: float = 100.0
@onready var anim = $Animacao

var last_dir = "baixo"

func _ready():
	add_to_group("player")
	anim.play("idle_b")

func _process(delta):
	var velocity = Vector2.ZERO

	# INPUT
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1

	velocity = velocity.normalized()
	position += velocity * speed * delta

	# DIREÇÃO (corrigido)
	if velocity.y < 0:
		last_dir = "cima"
	elif velocity.y > 0:
		last_dir = "baixo"
	elif velocity.x > 0:
		last_dir = "direita"
	elif velocity.x < 0:
		last_dir = "esquerda"

	# ANIMAÇÃO
	if velocity != Vector2.ZERO:
		anim.play(last_dir)
	else:
		match last_dir:
			"cima":
				anim.play("idle_c")
			"baixo":
				anim.play("idle_b")
			"direita":
				anim.play("idle_d")
			"esquerda":
				anim.play("idle_e")
