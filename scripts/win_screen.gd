extends Control
## Pantalla final: aparece al salir del galpón, muestra el puntaje y vuelve al menú.

const MENU_SCENE := "res://escenas/main_menu.tscn"

@onready var back_button: Button = $BackButton
@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	back_button.grab_focus()
	score_label.text = "Puntaje final: %d" % Game.score


func _on_back_button_pressed() -> void:
	Fade.change_scene(MENU_SCENE)
