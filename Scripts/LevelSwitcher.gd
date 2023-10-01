extends Node


func _ready():
	$ColorRect.modulate = Color(0.0, 0.0, 0.0, 0.0)
	$ColorRect.visible = false


func change_level(level_path: String):
	$ColorRect.visible = true
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate", Color(0.0, 0.0, 0.0, 1.0), 0.2)
	await tween.finished
	
	get_tree().change_scene_to_file(level_path)
	
	tween = create_tween()
	tween.tween_property($ColorRect, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.2)
	await tween.finished
	$ColorRect.visible = false
