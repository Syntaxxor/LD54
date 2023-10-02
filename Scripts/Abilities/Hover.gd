extends AbilityBase


@export var hover_bar: ProgressBar
@export var max_hover_time = 3.0
@export var hover_vel = -8.0
@export var hover_particles: GPUParticles2D

var hover_time = max_hover_time


func _ready():
	super._ready()
	hover_bar.max_value = max_hover_time


func _physics_process(delta):
	var button_name = get_button_name()
	if button_name != null && player.can_move:
		if player.is_on_floor():
			hover_time = max_hover_time
			hover_bar.visible = false
			hover_particles.emitting = false
		else:
			hover_bar.visible = true
			hover_bar.value = hover_time
			if Input.is_action_pressed(button_name) && hover_time > 0.0:
				hover_time -= delta
				player.velocity.y = min(player.velocity.y, hover_vel)
				player.has_full_control = true
				hover_particles.emitting = true
			else:
				hover_particles.emitting = false
	else:
		hover_bar.visible = false
		hover_particles.emitting = false
	if $AudioStreamPlayer.playing != hover_particles.emitting:
		$AudioStreamPlayer.playing = hover_particles.emitting
