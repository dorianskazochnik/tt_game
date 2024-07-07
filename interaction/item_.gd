extends Node2D
class_name WorldItem

@onready var interaction_area = $InteractonArea
@onready var sprite = $Sprite2D
@onready var lv = $"../../"
var player = null

var can_interact = true

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	sprite.hide()
	lv.add(lv.item)
	can_interact = false

func _on_interacton_area_body_entered(body):
	if can_interact:
		InteractionManager.register_area(interaction_area)

func _on_interacton_area_body_exited(body):
	InteractionManager.unregister_area(interaction_area)

