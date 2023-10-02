extends Control


var click_sound := preload("res://SFX/click.ogg")
var move_sound := preload("res://SFX/ui_move.ogg")

var value_changed_flag = false


func _ready():
	if has_signal("pressed"):
		connect("pressed", click)
	focus_entered.connect(move)
	if has_signal("value_changed"):
		connect("value_changed", val_change)
	await get_tree().process_frame
	value_changed_flag = true


func click():
	var sound = AudioStreamPlayer.new()
	sound.bus = "SFX"
	sound.finished.connect(sound.queue_free)
	sound.stream = click_sound
	add_child(sound)
	sound.play()


func val_change(_val):
	if value_changed_flag:
		move()
	else:
		value_changed_flag = true


func move():
	var sound = AudioStreamPlayer.new()
	sound.bus = "SFX"
	sound.finished.connect(sound.queue_free)
	sound.stream = move_sound
	add_child(sound)
	sound.play()
