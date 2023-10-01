extends AbilityBase


@export var dash_vel = 256.0
@export var dash_particles: GPUParticles2D
@export var dash_particles_left: GPUParticles2D


func _physics_process(delta):
	var button_name = get_button_name()
	if button_name != null && player.can_move:
		if player.is_on_floor() && Input.is_action_just_pressed(button_name):
			player.velocity.x = dash_vel * player.get_dir()
			if player.get_dir() < 0.0:
				dash_particles_left.restart()
				dash_particles_left.emitting = true
			else:
				dash_particles.restart()
				dash_particles.emitting = true
