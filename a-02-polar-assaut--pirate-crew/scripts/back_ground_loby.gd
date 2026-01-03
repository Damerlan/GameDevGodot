extends Node2D

@export var intensidade_fundo := 10.0/3
@export var intensidade_meio := 20.0/3
@export var intensidade_frente := 30.0/3

@export var suavizacao := 5.0

@onready var camada_fundo: Parallax2D = $ParallaxFundo
@onready var camada_meio: Parallax2D = $ParallaxMeio
@onready var camada_frente: Parallax2D = $ParallaxFrente

var alvo_fundo := Vector2.ZERO
var alvo_meio := Vector2.ZERO
var alvo_frente := Vector2.ZERO


func _process(delta):
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()

	# Normaliza mouse (-1 a 1)
	var offset = (mouse_pos / viewport_size) * 2.0 - Vector2.ONE

	alvo_fundo = offset * intensidade_fundo
	alvo_meio = offset * intensidade_meio
	alvo_frente = offset * intensidade_frente

	camada_fundo.position = camada_fundo.position.lerp(alvo_fundo, suavizacao * delta)
	camada_meio.position = camada_meio.position.lerp(alvo_meio, suavizacao * delta)
	camada_frente.position = camada_frente.position.lerp(alvo_frente, suavizacao * delta)
