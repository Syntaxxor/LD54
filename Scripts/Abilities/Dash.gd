extends AbilityBase


@export var dash_vel = 256.0


func _physics_process(delta):
	var button_name = get_button_name()
	if button_name != null && player.can_move:
		if player.is_on_floor() && Input.is_action_just_pressed(button_name):
			player.velocity.x = dash_vel * player.get_dir()
