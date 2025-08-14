extends Node2D

var current_step: int = 0

@onready var bg_sprite: Sprite2D = $Background
@onready var char_sprite: Sprite2D = $ChatGuptie
@onready var text_sprite: Sprite2D = $DialogueBox
@onready var central_marker: Marker2D = $DialogueBox/CentralMarker
@onready var bottom_screen_marker: Marker2D = $DialogueBox/BottomScreenMarker

@onready var steps = [
	{ "text_position": central_marker.global_position, "char": null, "text": "res://intro_dialogue/01-text.png" },
	{ "text_position": central_marker.global_position, "char": null, "text": "res://intro_dialogue/02-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/03-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/04-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/05-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/06-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/07-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/08-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/09-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/10-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/11-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/12-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/13-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/14-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/15-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/16-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/17-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/18-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/19-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/20-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/21-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/22-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/23-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/24-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/25-text.png" },
	{ "text_position": central_marker.global_position, "char": null, "text": "res://intro_dialogue/26-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/27-text.png" },
	{ "text_position": bottom_screen_marker.global_position, "char": null, "text": "res://intro_dialogue/28-text.png" },
]


func _ready() -> void:
	_apply_step()

func _input(event) -> void:
	if event.is_action_pressed("ui_accept"):
		current_step += 1
		if current_step < steps.size():
			_apply_step()
		else:
			_end_intro()

func _apply_step() -> void:
	var step = steps[current_step]
	
	# update text position
	text_sprite.global_position = step["text_position"]
	
	# update character visibility
	if step["char"] == null:
		char_sprite.visible = false
	else:
		char_sprite.texture = load(step["char"])
		char_sprite.visible = true
	
	# update dialogue box
	text_sprite.texture = load(step["text"])

func _end_intro() -> void:
	# change to fishing game scene
	get_tree().change_scene_to_file("res://fishing_scene.tscn")
