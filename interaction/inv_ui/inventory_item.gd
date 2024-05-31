extends Panel

@onready var item_visuals: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label

func update(slot: Slot):
	if !slot.item.definition:
		item_visuals.visible = false
		amount_text.visible = false
	else:
		item_visuals.visible = true
		amount_text.visible = true
		item_visuals.texture = slot.item.definition.icon
		amount_text.text = str(slot.amount)
