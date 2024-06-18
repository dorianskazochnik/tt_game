extends Node2D

@export var save_dict = {
	"filename" : "",
	"parent" : "",
	"pos_x" : 0,
	"pos_y" : 0,
	"character_x" : 0,
	"character_y" : 0,
	"title" : "first_dialog",
}

var title = "first_dialog"

@onready var res = preload("res://dialogs/first.dialogue")
@onready var sea = $sea
@onready var railway = $railway
@onready var wind = $wind
@onready var water = $water

@export var saving_path = "user://savettgame.save"

signal confirm

func _ready():
	SaveSystem._load(saving_path)
	save_dict = SaveSystem.get_var("save_dict")
	title = save_dict["title"]
	if !save_dict or !title:
		title = "first_dialog"
	if title == "first_dialog":
		sea.show()
		await confirm
		sea.hide()
		railway.show()
		railway.play("default")
		await confirm
		railway.stop()
		railway.hide()
		sea.show()
		wind.show()
		wind.play("default")
	else:
		sea.hide()
		wind.stop()
		wind.hide()
		water.show()
	var dialogue_line = await DialogueManager.show_dialogue_balloon(res, title)
	$ui/other_buttons.hide()
	DialogueManager.dialogue_ended.connect(ended)

func _input(delta):
	if Input.is_action_pressed("quit"):
		await SceneManager.fade_out()
		get_tree().quit()
	if Input.is_action_pressed("save"):
		_on_save_pressed()
	if Input.is_action_pressed("load"):
		_on_load_pressed()
	if Input.is_action_pressed("ui_accept"):
		emit_signal("confirm")

func _on_quit_pressed():
	DialogueManager.emit_signal("dialogue_ended")

func _on_save_pressed():
	save_dict = {
		"filename" : "cutscene",
		"parent" : get_parent().get_path(),
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"character_x" : 0,
		"character_y" : 0,
		"title" : title,
	}
	SaveSystem.set_var("save_dict", save_dict)
	SaveSystem.save(saving_path)

func _on_load_pressed():
	SaveSystem._load(saving_path)
	save_dict = SaveSystem.get_var("save_dict")
	title = save_dict["title"]
	if save_dict["filename"] == "lv":
		await SceneManager.fade_out()
		SceneManager.change_scene("res://level_1/lv.tscn", { "skip_fade_out": true })

func ended():
	await SceneManager.fade_out()
	SceneManager.change_scene("res://level_1/lv.tscn", { "skip_fade_out": true })
