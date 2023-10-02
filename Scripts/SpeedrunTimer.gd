extends CanvasLayer


enum SpeedrunMode {Off = 0, Level = 1, FullGame = 2}


@onready var timer_label = Label.new()


var is_running = false

var time = 0.0


var speedrun_mode := SpeedrunMode.Level


func _ready():
	layer = 128
	add_child(timer_label)
	timer_label.visible = false


func _process(delta):
	if is_running:
		time += delta / Engine.time_scale
		timer_label.text = "%.2f" % time


func start_level():
	if speedrun_mode == SpeedrunMode.Level:
		is_running = true
		time = 0.0
		timer_label.visible = true
	elif speedrun_mode == SpeedrunMode.FullGame && !is_running:
		is_running = true
		time = 0.0
		timer_label.visible = true


func end_level(final: bool):
	if final || speedrun_mode == SpeedrunMode.Level:
		is_running = false


func hide_timer():
	timer_label.visible = false
	is_running = false
