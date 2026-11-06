extends Control
## Menú principal: Jugar y Salir.

const LEVEL_1_SCENE := "res://escenas/level_1.tscn"

@onready var play_button: Button = $Buttons/PlayButton
@onready var quit_button: Button = $Buttons/QuitButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	play_button.grab_focus()


func _on_play_button_pressed() -> void:
	# Partida nueva: puntaje en 0 y balas llenas.
	Game.new_game()
	Fade.change_scene(LEVEL_1_SCENE)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
