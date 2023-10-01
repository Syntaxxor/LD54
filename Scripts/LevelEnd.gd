extends StaticBody2D


@export_file var next_level
@export var delivery_name := ""
@export var is_final := false


func _ready():
	$EndScreen.visible = false
	$EndScreen/Control/ItemNameLabel.text = delivery_name
	SpeedrunTimer.start_level()


func show_end_screen():
	SpeedrunTimer.end_level(is_final)
	$EndScreen/Control/VBoxContainer/Next.visible = !is_final
	if SpeedrunTimer.speedrun_mode == SpeedrunTimer.SpeedrunMode.FullGame && !is_final:
		LevelSwitcher.change_level(next_level)
	else:
		$EndScreen.visible = true
		get_tree().paused = true
		if is_final:
			$EndScreen/Control/VBoxContainer/Menu.grab_focus()
		else:
			$EndScreen/Control/VBoxContainer/Next.grab_focus()


func _on_next_pressed():
	get_tree().paused = false
	LevelSwitcher.change_level(next_level)


func _on_restart_pressed():
	get_tree().paused = false
	LevelSwitcher.change_level(get_tree().current_scene.scene_file_path)


func _on_menu_pressed():
	get_tree().paused = false
	LevelSwitcher.change_level("res://MainMenu.tscn")


func _on_end_trigger_body_entered(body):
	show_end_screen()
