extends Node
## Autoload "Game": guarda el puntaje y las balas para que no se pierdan
## cuando se cambia de escena.

signal score_changed(new_score: int)
signal ammo_changed(new_ammo: int)

const START_AMMO := 12

var score: int = 0
var ammo: int = START_AMMO

# Cómo estaba todo al entrar al nivel. Si el jugador muere o aprieta R vuelve a esto,
# si no se podrían juntar puntos y balas muriendo a propósito.
var _level_score: int = 0
var _level_ammo: int = START_AMMO


func new_game() -> void:
	score = 0
	ammo = START_AMMO
	save_level_start()


func save_level_start() -> void:
	_level_score = score
	_level_ammo = ammo


func restore_level_start() -> void:
	score = _level_score
	ammo = _level_ammo


func add_score(points: int) -> void:
	score += points
	score_changed.emit(score)


func add_ammo(amount: int) -> void:
	ammo += amount
	ammo_changed.emit(ammo)


# Gasta una bala. Devuelve false si no quedaba ninguna.
func use_ammo() -> bool:
	if ammo <= 0:
		return false
	ammo -= 1
	ammo_changed.emit(ammo)
	return true
