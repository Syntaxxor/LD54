extends CharacterBody2D


signal trigger_jump;


@export var move_speed = 64.0
@export var acceleration = 128.0
@export var air_control = 0.125
@export var coyote_time = 0.1
@export var jump_buffer_time = 0.1
@export var gravity = 256.0
@export var step_down_dist = 2.0

var coyote = 0.0
var jump_buffer = 0.0

var can_move = false

var has_full_control = true

var target_vel = 0.0

@onready var sprite = $AnimatedSprite2D


func _ready():
	await(sprite.animation_finished)
	can_move = true


func _physics_process(delta: float):
	velocity.y += gravity * delta
	
	if can_move:
		standard_movement(delta)
		do_animations()
	
	var was_on_floor = has_full_control && velocity.y >= 0.0
	
	move_and_slide()
	
	has_full_control = is_on_floor()
	
	if was_on_floor && !has_full_control:
		var motion = Vector2.DOWN * step_down_dist
		if test_move(transform, motion):
			move_and_collide(motion)
			has_full_control = true


func standard_movement(delta: float):
	target_vel = Input.get_axis("left", "right") * move_speed
	
	var cur_acceleration = acceleration
	
	if !has_full_control:
		cur_acceleration *= air_control
	
	velocity.x = move_toward(velocity.x, target_vel, cur_acceleration * delta)
	


func do_animations():
	if target_vel < 0.0:
		sprite.flip_h = true
	elif target_vel > 0.0:
		sprite.flip_h = false
	
	if has_full_control:
		if velocity.x == 0.0:
			sprite.play("Idle")
		else:
			sprite.play("Run")
	else:
		sprite.play("Jump")
