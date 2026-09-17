extends CharacterBody2D

@export var speed: float = 100.0
@export var vidas = 3

@onready var anim = $Animacao
@onready var hit = $hit
@onready var tema = $"../AudioStreamPlayer2D"
@onready var transition = $"../Transition/Fill/animation"

# CORAÇÕES
@onready var coracao1 = $"../Progresso/coração1"
@onready var coracao2 = $"../Progresso/coração2"
@onready var coracao3 = $"../Progresso/coração3"

# CORAÇÕES MORTOS
@onready var morte1 = $"../Progresso/morte1"
@onready var morte2 = $"../Progresso/morte2"
@onready var morte3 = $"../Progresso/morte3"

var last_dir = "baixo"
var spawn_position

var morto = false


func _ready():

	add_to_group("player")

	# PLAYER COMEÇA PARADO
	anim.play("idle_b")

	last_dir = "baixo"

	spawn_position = global_position

	atualizar_vidas()


func _physics_process(delta):

	# NÃO MOVE DURANTE MORTE
	if morto:
		return


	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	if Input.is_action_pressed("ui_left"):
		direction.x -= 1


	direction = direction.normalized()

	velocity = direction * speed

	move_and_slide()


	# DIREÇÃO
	if direction.y < 0:
		last_dir = "cima"

	elif direction.y > 0:
		last_dir = "baixo"

	elif direction.x > 0:
		last_dir = "direita"

	elif direction.x < 0:
		last_dir = "esquerda"


	# ANIMAÇÕES
	if direction != Vector2.ZERO:

		match last_dir:

			"cima":
				anim.play("cima")

			"baixo":
				anim.play("baixo")

			"direita":
				anim.play("direita")

			"esquerda":
				anim.play("esquerda")

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


func atualizar_vidas():

	# RESETA TUDO
	coracao1.visible = true
	coracao2.visible = true
	coracao3.visible = true

	morte1.visible = false
	morte2.visible = false
	morte3.visible = false


	# 2 VIDAS
	if vidas <= 2:

		coracao3.visible = false
		morte3.visible = true


	# 1 VIDA
	if vidas <= 1:

		coracao2.visible = false
		morte2.visible = true


	# 0 VIDAS
	if vidas <= 0:

		coracao1.visible = false
		morte1.visible = true


func tomar_dano():

	# EVITA TOMAR DANO MUITAS VEZES
	if morto:
		return


	morto = true

	vidas -= 1

	atualizar_vidas()

	print("vidas restantes:", vidas)


	# PARA MÚSICA
	tema.stop()


	# TOCA SOM HIT
	hit.play()


	# ANIMAÇÃO DE MORTE
	match last_dir:

		"cima":
			anim.play("morte_c")

		"baixo":
			anim.play("morte_b")

		"direita":
			anim.play("morte_d")

		"esquerda":
			anim.play("morte_e")


	# ESPERA MORTE
	await get_tree().create_timer(4).timeout


	# TRANSIÇÃO FECHANDO
	transition.play("transition_in")

	await transition.animation_finished


	# GAME OVER
	if vidas <= 0:

		get_tree().change_scene_to_file(
			"res://Cenas/game_over.tscn"
		)

		return


	# PLAYER VOLTA PRO SPAWN
	global_position = spawn_position


	# PLAYER VOLTA PARADO
	last_dir = "baixo"

	anim.play("idle_b")


	# VOLTA MÚSICA
	tema.play()


	# TRANSIÇÃO ABRINDO
	transition.play("transition_out")


	morto = false
