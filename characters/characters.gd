extends CharacterBody2D
class_name Player

const MAX_SPEED = 300
var input = Vector2.ZERO
@onready var character_active: Node2D = $character_active
@onready var character_passive: Node2D = $character_passive
@onready var huan_animation = preload("res://characters/huan.tres")
@onready var asher_animation = preload("res://characters/asher.tres")
@export var current_portrait: bool = true

func _ready():
	character_active.sprite_frames = huan_animation
	character_passive.sprite_frames = asher_animation
	character_passive.play("idle_down")
	character_active.play("idle_down")

func _physics_process(delta):
	if Input.is_action_just_released("space"):
		swap_characters()
	
	if character_active.position.y <= character_passive.position.y:
		character_active.z_index = 0
		character_passive.z_index = 1
	elif character_active.position.y > character_passive.position.y :
		character_active.z_index = 1
		character_passive.z_index = 0
	
	player_movement(delta)

func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()

func player_movement(delta):
	input = get_input()
	var collide = move_and_collide(MAX_SPEED * input * delta)
	if collide:
		input = Vector2.ZERO
	character_active.position += input * MAX_SPEED * delta
	var distance = character_passive.position.distance_to(character_active.position)
	if distance > 200:
		character_passive.position += MAX_SPEED * delta * character_passive.position.direction_to(character_active.position)
	elif distance >= 200 and distance < 250:
		character_passive.position += input * MAX_SPEED * delta
	
func show_animation(character: Node2D, str: String):
	character.stop()
	character.play(str)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and (event.as_text().to_lower() == "left" or event.as_text().to_lower() == "right" or event.as_text().to_lower() == "up" or event.as_text().to_lower() == "down"):
		var str: String = "idle_" + event.as_text().to_lower()
		show_animation(character_active, str)
		show_animation(character_passive, str)

func swap_characters():
	if current_portrait:
		character_passive.sprite_frames = huan_animation
		character_active.sprite_frames = asher_animation
		current_portrait = false
	else:
		character_active.sprite_frames = huan_animation
		character_passive.sprite_frames = asher_animation
		current_portrait = true
