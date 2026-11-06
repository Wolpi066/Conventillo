class_name Player
extends CharacterBody2D
## Jugador: camina con WASD, apunta con el mouse y dispara con clic izquierdo.

const MENU_SCENE := "res://escenas/main_menu.tscn"

@export var speed: float = 250.0
@export var bullet_scene: PackedScene
@export var blood_scene: PackedScene

var _dead: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var muzzle: Marker2D = $Muzzle
@onready var shoot_sound: AudioStreamPlayer = $ShootSound
@onready var empty_sound: AudioStreamPlayer = $EmptySound
@onready var restart_timer: Timer = $RestartTimer
@onready var message: Label = $CanvasLayer/Message
@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready var ammo_label: Label = $CanvasLayer/AmmoLabel


func _ready() -> void:
	restart_timer.timeout.connect(_on_restart_timer_timeout)
	Game.score_changed.connect(_on_score_changed)
	Game.ammo_changed.connect(_on_ammo_changed)
	message.hide()
	# Muestro los valores que vienen del nivel anterior.
	_on_score_changed(Game.score)
	_on_ammo_changed(Game.ammo)


func _physics_process(_delta: float) -> void:
	if _dead:
		return

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

	# Los sprites de Kenney miran a la derecha, así que con look_at el arma apunta al mouse.
	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("shoot"):
		_shoot()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		_restart()
	elif Input.is_action_just_pressed("back_to_menu"):
		Fade.change_scene(MENU_SCENE)


func _shoot() -> void:
	# Sin balas no sale nada, solo suena el clic del arma vacía.
	if not Game.use_ammo():
		empty_sound.play()
		return
	var bullet := bullet_scene.instantiate() as Node2D
	bullet.global_position = muzzle.global_position
	bullet.rotation = rotation
	get_tree().current_scene.add_child(bullet)
	shoot_sound.play()


# La llama el zombie cuando toca al jugador.
func die() -> void:
	# Si ya se está yendo del nivel (fundido de la puerta) no lo dejo morir.
	if _dead or Fade.is_changing():
		return
	_dead = true
	sprite.modulate = Color(1.0, 0.35, 0.35)
	var blood := blood_scene.instantiate() as Blood
	blood.global_position = global_position
	blood.rotation = randf() * TAU
	get_tree().current_scene.get_node("Blood").add_child(blood)
	message.show()
	# Espero un segundo antes de reiniciar para que se entienda qué pasó.
	restart_timer.start()


# Vuelve el puntaje y las balas a como estaban al entrar al nivel y lo arranca de nuevo.
func _restart() -> void:
	Game.restore_level_start()
	Fade.reload_scene()


func _on_restart_timer_timeout() -> void:
	_restart()


func _on_score_changed(new_score: int) -> void:
	score_label.text = "PUNTOS: %d" % new_score


func _on_ammo_changed(new_ammo: int) -> void:
	ammo_label.text = "x %d" % new_ammo
	# En rojo cuando no quedan balas, para que se note.
	if new_ammo == 0:
		ammo_label.modulate = Color(1.0, 0.36, 0.3)
	else:
		ammo_label.modulate = Color.WHITE
