extends AbilityBase


@export var dash_vel = 256.0
@export var dash_particles: GPUParticles2D
@export var dash_particles_left: GPUParticles2D
@export var dash_cooldown = 0.3
@export var coyote_time = 0.05
@export var jump_buffer_time = 0.05


var cooldown = 0.0
var coyote = 0.0
var jump_buffer = 0.0


func _physics_process(delta):
	coyote -= delta
	jump_buffer -= delta
	cooldown -= delta
	var button_name = get_button_name()
	if button_name != null && player.can_move:
		if player.is_on_floor():
			coyote = coyote_time
		if Input.is_action_just_pressed(button_name):
			jump_buffer = jump_buffer_time
		if coyote > 0.0 && jump_buffer > 0.0 && cooldown < 0.0:
			cooldown = dash_cooldown
			player.velocity.x = dash_vel * player.get_dir()
			$AudioStreamPlayer.play()
			if player.get_dir() < 0.0:
				dash_particles_left.restart()
				dash_particles_left.emitting = true
			else:
				dash_particles.restart()
				dash_particles.emitting = true
