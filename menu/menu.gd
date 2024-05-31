extends Node2D

@export var saving_path = "user://savettgame.save"

# Called when the node enters the scene tree for the first time.
func _ready():
	%music.play()
	%music_light.play()
	modulate = Color(1, 1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("quit"):
		%music_hover_press.play()
		await SceneManager.fade_out()
		get_tree().quit()

func _on_play_pressed():
	%music_hover_press.play()
	%music.stop()
	%music_light.stop()
	await SceneManager.fade_out()
	SceneManager.change_scene("res://cutscene/cutscene_alfa.tscn", { "skip_fade_out": true })

func _on_continue_pressed():
	%music_hover_press.play()
	#await get_tree().create_tween().tween_property(self, "modulate", Color(1, 1, 1, 0), 2.0).finished
	SaveSystem._load(saving_path)
	var save_dict = SaveSystem.get_var("save_dict")
	%music.stop()
	%music_light.stop()
	if save_dict["filename"] == "cutscene":
		await SceneManager.fade_out()
		SceneManager.change_scene("res://cutscene/cutscene_alfa.tscn", { "skip_fade_out": true })
	elif save_dict["filename"] == "lv":
		await SceneManager.fade_out()
		SceneManager.change_scene("res://level_1/lv.tscn", { "skip_fade_out": true })

func _on_quit_pressed():
	%music_hover_press.play()
	await SceneManager.fade_out()
	get_tree().quit()
