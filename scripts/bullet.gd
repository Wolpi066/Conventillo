extends Area2D
## Bala de la pistola: le saca vida al zombie que toca y se rompe contra paredes y muebles.

@export var speed: float = 1000.0
@export var damage: int = 1

var _life: float = 0.8


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	# transform.x es el "adelante" de la bala, que ya viene rotada desde el jugador.
	position += transform.x * speed * delta
	_life -= delta
	if _life <= 0.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	# La bala nace pegada al jugador: a él lo ignora.
	if body is Player:
		return
	if body is Zombie:
		body.take_damage(damage, transform.x)
	queue_free()
