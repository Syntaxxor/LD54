extends CanvasLayer


@export var slow_time = 0.125

@onready var animation_player := $AnimationPlayer
@onready var cursor := $Cursor
@onready var abilities: Array[AbilityBase] = [$JumpAbility, $DashAbility, $HoverAbility, $SuperJumpAbility]
@onready var player = get_parent()

var button_positions = [
	Vector2(0, 32),
	Vector2(32, 0),
	Vector2(-32, 0),
	Vector2(0, -32),
]

var is_active = false

var selected: Area2D = null


func _ready():
	for i in range(0, abilities.size()):
		var bit_flag = 1 << i
		abilities[i].enabled = bit_flag & player.enabled_abilities != 0
		abilities[i].z_index = 1


func _process(delta):
	delta /= Engine.time_scale
	animation_player.advance(delta)
	if Input.is_action_just_pressed("open_abilities"):
		if !is_active && player.is_on_floor():
			is_active = true
			animation_player.play_backwards("Slide")
			create_tween().tween_property(Engine, "time_scale", slow_time, 0.1)
		elif is_active:
			is_active = false
			animation_player.play("Slide")
			create_tween().tween_property(Engine, "time_scale", 1.0, 0.1)
	
	if is_active:
		cursor_movement()


func _physics_process(delta):
	if is_active:
		cursor_selection()


func cursor_movement():
	if Input.is_action_just_pressed("up") && cursor.position.y > -64:
		cursor.position.y -= 32
		if selected != null:
			selected.position.y -= 32
	if Input.is_action_just_pressed("down") && cursor.position.y < 64:
		cursor.position.y += 32
		if selected != null:
			selected.position.y += 32
	if Input.is_action_just_pressed("left") && cursor.position.x > -128:
		cursor.position.x -= 32
		if selected != null:
			selected.position.x -= 32
	if Input.is_action_just_pressed("right") && cursor.position.x < 128:
		cursor.position.x += 32
		if selected != null:
			selected.position.x += 32


func cursor_selection():
	if Input.is_action_just_pressed("button_0"):
		if selected == null:
			if cursor.has_overlapping_areas():
				selected = cursor.get_overlapping_areas()[0]
				selected.modulate.a = 0.5
				selected.z_index = 1
		else:
			if !selected.has_overlapping_areas():
				selected.modulate.a = 1.0
				selected.z_index = 0
				selected = null
				check_abilities()


func check_abilities():
	for a in abilities:
		a.trigger_action = -1
		var ind = 0
		for p in button_positions:
			if a.position.is_equal_approx(p):
				a.trigger_action = ind
			ind += 1
