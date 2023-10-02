class_name MusicStarter extends Node

@export var stream: AudioStream


func _ready():
	if MusicPlayer.stream != stream:
		MusicPlayer.start_song(stream)
