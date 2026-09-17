extends CharacterBody2D

@export var speed = 80

@onready var anim = $AnimatedSprite2D


var pontos = [

	Vector2(287, 338),
	Vector2(483, 338),
	Vector2(483, 485),
	Vector2(287, 486)

]

var alvo = 0


func _physics_process(delta):

	var destino = pontos[alvo]

	var direcao = (
		destino - global_position
	).normalized()

	velocity = direcao * speed

	move_and_slide()

	atualizar_animacao(direcao)


	# CHEGOU NO PONTO
	if global_position.distance_to(destino) < 5:

		alvo += 1


		# VOLTA PRO COMEÇO
		if alvo >= pontos.size():

			alvo = 0


func atualizar_animacao(direcao):

	if abs(direcao.x) > abs(direcao.y):

		if direcao.x > 0:

			anim.play("direita")

		else:

			anim.play("esquerda")

	else:

		if direcao.y > 0:

			anim.play("baixo")

		else:

			anim.play("cima")


func _on_area_2d_body_entered(body):

	if body.is_in_group("player"):

		body.tomar_dano()
