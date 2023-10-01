class_name AbilityBase extends Area2D

@export var player: CharacterBody2D

@onready var ability_minigame = get_parent()

var enabled = true

var trigger_action = -1


func _ready():
	await(get_tree().process_frame)
	visible = enabled
	monitoring = enabled
	monitorable = enabled


func get_button_name():
	if trigger_action == -1 || !enabled || ability_minigame.is_active:
		return null
	else:
		return "button_" + str(trigger_action)

