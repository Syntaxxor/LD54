extends AudioStreamPlayer


func _ready():
	bus = "Music"
	set_volume_linear(1.0)
	process_mode = PROCESS_MODE_ALWAYS


func start_song(new_stream: AudioStream):
	await create_tween().tween_method(set_volume_linear, 1.0, 0.0, 0.1).finished
	stop()
	stream = new_stream
	set_volume_linear(1.0)
	play()


func set_volume_linear(volume: float):
	volume_db = linear_to_db(volume)


func set_low_pass_strength(cutoff: float):
	AudioServer.get_bus_effect(2, 0).cutoff_hz = lerp(20500, 2000,cutoff)
