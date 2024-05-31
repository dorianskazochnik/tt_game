extends Control
class_name Ui

@export var pause: bool = true

func _ready():
	pause = false

func _on_pause_button_pressed():
	if pause:
		$other_buttons.hide()
		pause = false
	else :
		$other_buttons.show()
		pause = true

func _on_quit_button_pressed():
	await SceneManager.fade_out()
	SceneManager.change_scene("res://menu/menu.tscn", { "skip_fade_out": true })
