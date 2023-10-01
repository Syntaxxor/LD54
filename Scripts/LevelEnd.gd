extends StaticBody2D


@export_file var next_level
@export var delivery_name := ""


func _ready():
	$EndScreen.visible = false
	$EndScreen/Control/ItemNameLabel.text = delivery_name


func show_end_screen():
	$EndScreen.visible = true
	get_tree().paused = true
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
