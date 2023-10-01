extends AbilityBase


@export var super_jump_bar: ProgressBar
@export var jump_vel := 256.0
@export var max_charge := 1.0
@export var jump_land_particles: GPUParticles2D
@export var super_jump_particles: GPUParticles2D

var charge = 0.0


func _ready():
	super._ready()
	super_jump_bar.max_value = max_charge


func _physics_process(delta):
	var button_name = get_button_name()
	if button_name != null && player.can_move:
		if player.is_on_floor() && Input.is_action_pressed(button_name):
			charge = min(charge + delta, max_charge)
			player.is_charging = true
		elif Input.is_action_just_released(button_name) && charge == max_charge:
			charge = 0.0
			player.velocity.y = -jump_vel
			jump_land_particles.restart()
			jump_land_particles.emitting = true
			super_jump_particles.emitting = true
			player.is_charging = false
		else:
			charge = 0.0
			player.is_charging = false
		super_jump_bar.value = charge
	super_jump_bar.visible = player.is_charging
