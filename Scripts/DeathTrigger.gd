class_name DeathTrigger extends Area2D


func _ready():
	collision_mask = 2
	body_entered.connect(collision)


func collision(body: Node2D):
	if body.has_method("restart_level"):
		$AudioStreamPlayer.play()
		body.restart_level()
