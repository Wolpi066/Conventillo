class_name Zombie
extends CharacterBody2D
## Clase base de los zombies: acá está todo lo que comparten los dos tipos.
## Cada hijo sobrescribe get_move_direction() con su forma de perseguir.

## Probabilidad de que suelte una caja de balas al morir (0.25 = 25%).
const AMMO_DROP_CHANCE := 0.25

@export var speed: float = 150.0
@export var max_health: int = 2
## Si el jugador entra a esta distancia, el zombie lo empieza a perseguir.
@export var wake_distance: float = 400.0
## Puntos que suma el jugador cuando lo mata.
@export var points: int = 100
@export var blood_scene: PackedScene
@export var ammo_scene: PackedScene

var health: int = 0
var is_chasing: bool = false
var player: Player

@onready var hitbox: Area2D = $Hitbox


func _ready() -> void:
	health = max_health
	player = get_tree().get_first_node_in_group("player") as Player
	hitbox.body_entered.connect(_on_hitbox_body_entered)


func _physics_process(_delta: float) -> void:
	if player == null:
		return

	# Una vez que se activa ya no lo suelta, aunque el jugador se aleje.
	if not is_chasing:
		if global_position.distance_to(player.global_position) < wake_distance:
			is_chasing = true
		return

	var direction := get_move_direction()
	velocity = direction * speed
	move_and_slide()
	# Mira hacia donde quiere ir, aunque esté trabado contra una pared.
	if direction != Vector2.ZERO:
		rotation = direction.angle()


# La base no sabe perseguir: esto lo sobrescribe cada hijo.
func get_move_direction() -> Vector2:
	return Vector2.ZERO


# hit_direction es para donde iba la bala, la sangre sale para ese lado.
func take_damage(amount: int, hit_direction: Vector2) -> void:
	# Si dos balas lo tocan en el mismo frame la segunda llega cuando ya está muerto.
	if health <= 0:
		return
	health -= amount
	if health <= 0:
		die(hit_direction)
	else:
		_spawn_blood(hit_direction, false)


func die(hit_direction: Vector2) -> void:
	_spawn_blood(hit_direction, true)
	Game.add_score(points)
	if randf() < AMMO_DROP_CHANCE:
		var ammo := ammo_scene.instantiate() as Node2D
		ammo.global_position = global_position
		# Deferred porque esto pasa en medio del paso de física (lo llama la bala).
		get_tree().current_scene.add_child.call_deferred(ammo)
	queue_free()


func _spawn_blood(direction: Vector2, leave_splat: bool) -> void:
	var blood := blood_scene.instantiate() as Blood
	blood.leave_splat = leave_splat
	blood.global_position = global_position
	blood.rotation = direction.angle()
	# Va en el nodo Blood del nivel, que está abajo de los personajes,
	# así las manchas quedan en el piso y no tapan a nadie.
	get_tree().current_scene.get_node("Blood").add_child(blood)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
