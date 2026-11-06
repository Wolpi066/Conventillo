extends Area2D
## Salida del nivel: una puerta en la pared. Cuando el jugador la toca se abre
## y se pasa a la escena de next_scene con el fundido.

@export_file("*.tscn") var next_scene: String

var _opened: bool = false

@onready var hinge: Node2D = $Hinge
@onready var blocker_shape: CollisionShape2D = $Blocker/CollisionShape2D
@onready var open_sound: AudioStreamPlayer = $OpenSound


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not _opened:
		_opened = true
		open_sound.play()
		# La puerta gira desde la bisagra para afuera.
		var tween := create_tween()
		tween.tween_property(hinge, "rotation", -PI / 2.0, 0.25)
		# Le saco la colisión así el jugador puede salir caminando mientras se oscurece.
		# Es con set_deferred porque estamos en pleno paso de física.
		blocker_shape.set_deferred("disabled", true)
		# Guardo con cuántos puntos y balas llega al próximo nivel, por si muere ahí.
		Game.save_level_start()
		Fade.change_scene(next_scene)
