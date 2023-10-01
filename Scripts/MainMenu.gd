extends Node2D

@export var level_paths: Array[String]

@onready var camera = $Camera2D


var busy = false

var settings_path = OS.get_user_data_dir() + "/bbd.conf"


func _ready():
	print(settings_path)
	
	$MainMenu/StartButton.grab_focus()
	
	load_settings()
	
	for i in range(0, level_paths.size()):
		var new_button := Button.new()
		new_button.text = "Lv. " + str(i)
		new_button.pressed.connect(change_level.bind(level_paths[i]))
		$ScrollContainer/LevelSelect.add_child(new_button)
	
	SpeedrunTimer.hide_timer()


func change_level(level_path):
	LevelSwitcher.change_level(level_path)


func _on_quit_button_pressed():
	if !busy:
		var tween := move_camera($QuitTarget.position)
		await tween.finished
		get_tree().quit()


func move_camera(target: Vector2) -> Tween:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(false)
	tween.tween_property(self, "busy", true, 0.0)
	tween.tween_property(camera, "position", target, 1.0)
	tween.tween_property(self, "busy", false, 0.0)
	
	return tween


func _on_start_button_pressed():
	if !busy:
		move_camera($LevelSelectTarget.position)
		$ScrollContainer/LevelSelect/BackToMenu.grab_focus()


func _on_back_to_menu_pressed():
	if !busy:
		move_camera($MainMenuTarget.position)
		$MainMenu/StartButton.grab_focus()


func _on_options_button_pressed():
	if !busy:
		move_camera($OptionsTarget.position)
		$Settings/PanelContainer/ScrollContainer/VBoxContainer/BackToMenu.grab_focus()


func load_settings():
	var conf = ConfigFile.new()
	if FileAccess.file_exists(settings_path):
		conf.load(settings_path)
	%SpeedrunOption.selected = conf.get_value("general", "speedrun", 0)
	%FullscreenButton.button_pressed = conf.get_value("general", "fullscreen", false)
	%Global.value = conf.get_value("audio", "global", 10)
	%SFX.value = conf.get_value("audio", "sfx", 10)
	%Music.value = conf.get_value("audio", "music", 8)
	
	apply_settings()


func save_settings():
	var conf = ConfigFile.new()
	
	conf.set_value("general", "speedrun", %SpeedrunOption.selected)
	conf.set_value("general", "fullscreen", %FullscreenButton.button_pressed)
	conf.set_value("audio", "global", %Global.value)
	conf.set_value("audio", "sfx", %SFX.value)
	conf.set_value("audio", "music", %Music.value)
	
	conf.save(settings_path)
	
	apply_settings()


func apply_settings():
	SpeedrunTimer.speedrun_mode = %SpeedrunOption.selected
	if %FullscreenButton.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	AudioServer.set_bus_volume_db(0, linear_to_db(%Global.value / 10.0))
	AudioServer.set_bus_volume_db(1, linear_to_db(%SFX.value / 10.0))
	AudioServer.set_bus_volume_db(2, linear_to_db(%Music.value / 10.0))


func _on_speedrun_option_item_selected(index):
	save_settings()
