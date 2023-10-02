extends AbilityBase


@export var coyote_time = 0.05
@export var jump_buffer_time = 0.05
@export var jump_vel = 128.0
@export var jump_land_particles: GPUParticles2D

var coyote = 0.0
var jump_buffer = 0.0

func _physics_process(delta):
	coyote -= delta
	jump_buffer -= delta
	var button_name = get_button_name()
	if button_name != null && player.can_move:
		if player.is_on_floor():
			coyote = coyote_time
		
		if Input.is_action_just_pressed(button_name):
			jump_buffer = jump_buffer_time
		if Input.is_action_just_released(button_name):
			jump_buffer = 0.0
		
		if jump_buffer > 0.0 && coyote > 0.0:
			jump_buffer = 0.0
			coyote = 0.0
			player.velocity.y = -jump_vel
			player.has_full_control = false
			jump_land_particles.restart()
			jump_land_particles.emitting = true
			$AudioStreamPlayer.play()
