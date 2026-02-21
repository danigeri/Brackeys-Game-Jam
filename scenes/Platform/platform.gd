extends Node2D

@export var dir: String
@export var distance: int
@export var duration: int
@export_enum("Right/Down", "Left/Up") var start_direction: String = "Right/Down"

var is_moving = false
var is_hovering = false
var tween: Tween
var start_x: float
var start_y: float

# A collision_shape_2d = azzal amin így tényleg mozog
@onready var collision_shape_2d: CollisionShape2D = $Node2D/CharacterBody2D/CollisionShape2D

# ez nem tudom mi
@onready var collision_shape_2d_mouse: CollisionShape2D = %CollisionShape2D
@onready var node_2d: Node2D = $Node2D
@onready var line_2d: Line2D = $Line2D

# grabbing hands on sides
@onready var grab_left: AnimatedSprite2D = $Node2D/Icon/Left
@onready var grab_right: AnimatedSprite2D = $Node2D/Icon/Right

@onready var icon: Sprite2D = $Node2D/Icon

var platform_texture_act_1 = preload("uid://d1e1qheab4ty0")
var platform_texture_act_2 = preload("uid://bd1lxcriffsb6")
var platform_texture_act_3 = preload("uid://bnaalokfffe01")
var platform_ghost_moveable = preload("uid://bdrja35xfgxdd")

var platform_textures_by_act = [
	platform_texture_act_1,
	platform_texture_act_2,
	platform_texture_act_3
]

func _ready() -> void:
	GameEvents.ghost_mode_on.connect(ghost_mode_on)
	start_x = node_2d.position.x
	start_y = node_2d.position.y

	grab_left.modulate.a = 0.0
	grab_right.modulate.a = 0.0
	#grab_right.scale.x = -abs(grab_right.scale.x)
	
	icon.texture = platform_textures_by_act[GameEvents.current_act - 1]
	
	GameEvents.act_changed_to.connect(func(act_num: int):
		icon.texture = platform_textures_by_act[GameEvents.current_act - 1]
	)
	
	# todo ghost
	GameEvents.ghost_mode_on.connect(func(ghost_mode: bool):
		if ghost_mode:
			icon.texture = platform_ghost_moveable
	)

	_create_tween()

	if dir == "x":
		# jobb alsó
		line_2d.add_point(
			Vector2(
				start_x + distance + collision_shape_2d.shape.get_rect().size.x / 2,
				start_y + collision_shape_2d.shape.get_rect().size.y / 2
			)
		)

		# jobb felső
		line_2d.add_point(
			Vector2(
				start_x + distance + collision_shape_2d.shape.get_rect().size.x / 2,
				start_y - collision_shape_2d.shape.get_rect().size.y / 2
			)
		)

		# bal felső
		line_2d.add_point(
			Vector2(
				start_x - distance - collision_shape_2d.shape.get_rect().size.x / 2,
				start_y - collision_shape_2d.shape.get_rect().size.y / 2
			)
		)

		# bal alsó
		line_2d.add_point(
			Vector2(
				start_x - distance - collision_shape_2d.shape.get_rect().size.x / 2,
				start_y + collision_shape_2d.shape.get_rect().size.y / 2
			)
		)
	elif dir == "y":
		# jobb alsó
		line_2d.add_point(
			Vector2(
				start_x + collision_shape_2d.shape.get_rect().size.x / 2,
				start_y + distance + collision_shape_2d.shape.get_rect().size.y / 2
			)
		)

		# jobb felső
		line_2d.add_point(
			Vector2(
				start_x + collision_shape_2d.shape.get_rect().size.x / 2,
				start_y - distance - collision_shape_2d.shape.get_rect().size.y / 2
			)
		)

		# bal felső
		line_2d.add_point(
			Vector2(
				start_x - collision_shape_2d.shape.get_rect().size.x / 2,
				start_y - distance - collision_shape_2d.shape.get_rect().size.y / 2
			)
		)

		# bal alsó
		line_2d.add_point(
			Vector2(
				start_x - collision_shape_2d.shape.get_rect().size.x / 2,
				start_y + distance + collision_shape_2d.shape.get_rect().size.y / 2
			)
		)


func _physics_process(delta: float):
	handle_platform_moving(delta)
	handle_platform_release_and_hovering()


func _create_tween():
	tween = create_tween()
	tween.set_loops()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

	var first_target
	var second_target

	if dir == "x":
		if start_direction == "Right/Down":
			first_target = start_x + distance
			second_target = start_x - distance
		else:
			first_target = start_x - distance
			second_target = start_x + distance

		(
			tween
			. tween_property(node_2d, "position:x", first_target, duration)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)

		(
			tween
			. tween_property(node_2d, "position:x", second_target, duration)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)

	elif dir == "y":
		if start_direction == "Right/Down":
			first_target = start_y + distance
			second_target = start_y - distance
		else:
			first_target = start_y - distance
			second_target = start_y + distance

		(
			tween
			. tween_property(node_2d, "position:y", first_target, duration)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)

		(
			tween
			. tween_property(node_2d, "position:y", second_target, duration)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)


func ghost_mode_on(value) -> void:
	node_2d.position = Vector2(start_x, start_y)
	line_2d.visible = value

	if tween:
		tween.kill()
		tween = null

	if not value:
		_fade_grab(false)

	if not value:
		if not tween:
			_create_tween()


func handle_platform_moving(delta) -> void:
	var mouse_pos = to_local(get_global_mouse_position())
	if is_moving:
		if dir == "x":
			var target_x = clamp(mouse_pos.x, start_x - distance, start_x + distance)
			node_2d.position.x = move_toward(node_2d.position.x, target_x, 1000 * delta)
		if dir == "y":
			var target_y = clamp(mouse_pos.y, start_y - distance, start_y + distance)
			node_2d.position.y = move_toward(node_2d.position.y, target_y, 1000 * delta)


func handle_platform_release_and_hovering() -> void:
	if not GameEvents.ghost_mode:
		return

	if Input.is_action_pressed("click") and is_hovering:
		if not is_moving:
			SoundManager.play_sound_by_id(SoundManager.Sound.PLATFORM_MOVE)
			_fade_grab(true)

		is_moving = true
	else:
		if is_moving:
			_fade_grab(false)

		is_moving = false

	if Input.is_action_just_released("click"):
		var mouse_pos = get_global_mouse_position()
		is_hovering = collision_shape_2d_mouse.shape.get_rect().has_point(
			collision_shape_2d_mouse.to_local(mouse_pos)
		)
		is_moving = false


func _on_area_2d_mouse_entered() -> void:
	if !Input.is_action_pressed("click"):
		is_hovering = true


func _on_area_2d_mouse_exited() -> void:
	if !is_moving:
		is_hovering = false


func _fade_grab(show: bool):
	if not GameEvents.ghost_mode:
		show = false

	var target_alpha = 1.0 if show else 0.0

	var t = create_tween()
	t.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

	t.tween_property(grab_left, "modulate:a", target_alpha, 0.15)
	t.parallel().tween_property(grab_right, "modulate:a", target_alpha, 0.15)
