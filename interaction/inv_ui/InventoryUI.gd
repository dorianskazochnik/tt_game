extends Control

var is_open = false

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	close()

func update_slots(inv: Inventory):
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
