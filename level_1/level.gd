extends Node2D

@onready var inventory = $Inventory
@export var item: Item
@onready var inv_ui = $inventryUI
@export var save_dict = {
	"filename" : "",
	"parent" : "",
	"pos_x" : 0,
	"pos_y" : 0,
	"character_x" : 0,
	"character_y" : 0,
	"title" : "water",
}
var title = "water"

@export var saving_path = "user://savettgame.save"

# Called when the node enters the scene tree for the first time.
func _ready():
	SaveSystem.save(saving_path)
	SaveSystem._load(saving_path)
	if SaveSystem.get_var("save_dict") and save_dict != SaveSystem.get_var("save_dict"):
		save_dict = SaveSystem.get_var("save_dict")
		$characters/character_active.global_position.x = save_dict["character_x"]
		$characters/character_active.global_position.y = save_dict["character_y"]
	$ui/other_buttons.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$characters/Camera2D.position = $characters/character_active.position
	$ui.position = $characters/Camera2D.get_screen_center_position() - Vector2(960, 540)
	$inventryUI.position = $characters/Camera2D.get_screen_center_position() - Vector2(152, 500)

func _input(event):
	if event is InputEvent and event.is_action_pressed("quit"):
		await SceneManager.fade_out()
		get_tree().quit()
	elif event is InputEvent and event.is_action_pressed("save"):
		_on_save_pressed()
	elif event is InputEvent and event.is_action_pressed("load"):
		_on_load_pressed()

func add(i):
	for slot in inventory.slots:
		if slot.item == i:
			slot.amount += 1
			break
		elif !slot.item.definition:
			slot.item = i
			slot.amount += 1
			break
	inv_ui.update_slots(inventory)

func _on_quit_pressed():
	$characters.hide()

func _on_save_pressed():
	save_dict = {
		"filename" : "lv",
		"parent" : get_parent().get_path(),
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"character_x" : $characters/character_active.global_position.x,
		"character_y" : $characters/character_active.global_position.y,
		"title" : title,
	}
	SaveSystem.set_var("save_dict", save_dict)
	SaveSystem.save(saving_path)


func _on_load_pressed():
	SaveSystem._load(saving_path)
	save_dict = SaveSystem.get_var("save_dict")
	title = save_dict["title"]
	if save_dict["filename"] == "cutscene":
		await SceneManager.fade_out()
		SceneManager.change_scene("res://cutscene/cutscene_alfa.tscn", { "skip_fade_out": true })
	$characters/character_active.global_position.x = save_dict["character_x"]
	$characters/character_active.global_position.y = save_dict["character_y"]

func _on_tree_exiting():
	_on_save_pressed()
