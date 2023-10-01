extends CharacterBody2D


signal trigger_jump;


enum AbilityIndices{Jump, Dash, Hover, SuperJump}


@export var move_speed := 64.0
@export var acceleration := 128.0
@export var air_control := 0.125
@export var charge_speed_scale := 0.25
@export var gravity := 256.0
@export var step_down_dist := 2.0
@export_flags("Jump", "Dash", "Hover", "SuperJump") var enabled_abilities := 15


var can_move = false

var has_full_control = true

var target_vel = 0.0

var is_charging = false

var was_on_floor = false

@onready var sprite = $AnimatedSprite2D


func get_dir():
	if sprite.flip_h:
		return -1.0
	else:
		return 1.0


func _ready():
	$PauseMenu.visible = false
	await(sprite.animation_finished)
	can_move = true


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		$PauseMenu.visible = true
		$PauseMenu/VBoxContainer/ResumeButton.grab_focus()
		get_tree().paused = true


func _physics_process(delta: float):
	velocity.y += gravity * delta
	
	if can_move:
		standard_movement(delta)
		do_animations()
	
	was_on_floor = has_full_control && velocity.y >= 0.0
	
	move_and_slide()
	
	do_particles()
	
	has_full_control = is_on_floor()


func standard_movement(delta: float):
	target_vel = Input.get_axis("left", "right") * move_speed
	
	if is_charging:
		target_vel *= charge_speed_scale
	
	var cur_acceleration = acceleration
	
	if !has_full_control:
		cur_acceleration *= air_control
	if sign(target_vel) * sign(velocity.x) >= 0.0:
		cur_acceleration *= 0.5
	
	velocity.x = move_toward(velocity.x, target_vel, cur_acceleration * delta)


func do_animations():
	if target_vel < 0.0:
		sprite.flip_h = true
	elif target_vel > 0.0:
		sprite.flip_h = false
	
	if is_charging:
		sprite.play("Jump")
	elif has_full_control:
		if velocity.x == 0.0:
			sprite.play("Idle")
		else:
			sprite.play("Run")
	else:
		sprite.play("Jump")


func do_particles():
	if is_on_floor():
		var is_sliding = sign(target_vel) * sign(velocity.x) < 0.0
		$Particles/MoveParticles.emitting = !is_sliding && velocity.x != 0.0
		$Particles/SlideParticles.emitting = is_sliding && velocity.x != 0.0
		if !was_on_floor:
			$Particles/JumpLandParticles.restart()
			$Particles/JumpLandParticles.emitting = true
	else:
		$Particles/MoveParticles.emitting = false
		$Particles/SlideParticles.emitting = false


func _on_resume_button_pressed():
	get_tree().paused = false
	$PauseMenu.visible = false


func _on_to_menu_button_pressed():
	get_tree().paused = false
	Engine.time_scale = 1.0
	LevelSwitcher.change_level("res://MainMenu.tscn")


func _on_restart_button_pressed():
	get_tree().paused = false
	Engine.time_scale = 1.0
	LevelSwitcher.change_level(get_tree().current_scene.scene_file_path)
