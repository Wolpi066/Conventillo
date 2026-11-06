class_name Blood
extends Node2D
## Sangre: un chorro de gotas que sale para el lado del golpe y, si se pide,
## una mancha que queda en el piso.

## Con false solo salen las gotas (los tiros que no matan no dejan mancha).
@export var leave_splat: bool = true

@onready var splat: Sprite2D = $Splat
@onready var particles: CPUParticles2D = $Particles


func _ready() -> void:
	if leave_splat:
		# Giro la mancha al azar para que no queden todas iguales.
		splat.rotation = randf() * TAU
	else:
		splat.hide()
		# Sin mancha no tiene sentido que siga existiendo cuando caen las gotas.
		particles.finished.connect(queue_free)
