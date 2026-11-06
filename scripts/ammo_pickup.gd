extends Area2D
## Caja de balas que a veces suelta un zombie al morir. Si el jugador la pisa, suma balas.

@export var amount: int = 6

var _time: float = 0.0

@onready var bullet_icon: Sprite2D = $BulletIcon
@onready var pickup_sound: AudioStreamPlayer = $PickupSound


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	# La bala de arriba sube y baja para que se note que se puede agarrar.
	_time += delta
	bullet_icon.position.y = -26.0 + sin(_time * 5.0) * 3.0


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Game.add_ammo(amount)
		# Escondo la caja y espero a que termine el sonido antes de borrarla,
		# si la borro antes el sonido se corta.
		hide()
		set_deferred("monitoring", false)
		pickup_sound.play()
		await pickup_sound.finished
		queue_free()
