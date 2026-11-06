extends CanvasLayer
## Autoload "Fade": fundido a negro entre escenas para que no cambien de golpe.
## Como es autoload no se borra al cambiar de escena, así que puede aclarar la nueva.

const FADE_TIME := 0.4
## Hasta dónde baja la música mientras está todo negro.
const MUTED_DB := -40.0

var _changing: bool = false
var _master_bus: int = 0

@onready var black: ColorRect = $Black


func _ready() -> void:
	_master_bus = AudioServer.get_bus_index("Master")
	# El juego arranca en negro y aclara, así el menú tampoco aparece de golpe.
	_changing = true
	black.modulate.a = 1.0
	_fade_in()


func change_scene(path: String) -> void:
	# Si ya está cambiando ignoro el pedido (por ejemplo, doble clic en un botón).
	if _changing:
		return
	_changing = true
	# Mientras oscurece no dejo que se pueda hacer clic en los botones de abajo.
	black.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween := create_tween()
	tween.tween_property(black, "modulate:a", 1.0, FADE_TIME)
	# Bajo la música junto con la imagen, si no se corta de golpe igual.
	tween.parallel().tween_method(_set_volume, 0.0, MUTED_DB, FADE_TIME)
	await tween.finished
	get_tree().change_scene_to_file(path)
	_fade_in()


func reload_scene() -> void:
	change_scene(get_tree().current_scene.scene_file_path)


func is_changing() -> bool:
	return _changing


func _fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(black, "modulate:a", 0.0, FADE_TIME)
	tween.parallel().tween_method(_set_volume, MUTED_DB, 0.0, FADE_TIME)
	await tween.finished
	black.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_changing = false


func _set_volume(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(_master_bus, volume_db)
