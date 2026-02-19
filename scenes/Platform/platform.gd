extends Node2D

@export var dir: String
@export var distance: int
@export var duration: int

var is_moving = false
var is_hovering = false
var tween: Tween
var start_x: float
var start_y: float
var line_2d: Line2D

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

var platform_lines = preload("uid://cbdwnan67004a")


func _ready() -> void:
	GameEvents.ghost_mode_on.connect(ghost_mode_on)
	start_x = position.x
	start_y = position.y
	_create_tween()
	_setup_line_2d()


func _process(delta: float):
	if GameEvents.ghost_mode:
		update_line_2d()


func _physics_process(delta: float):
	handle_platform_moving(delta)
	handle_platform_release_and_hovering()


func _create_tween():
	if dir == "x":
		tween = create_tween()
		tween.set_loops()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

		(
			tween
			. tween_property(self, "position:x", start_x + distance, duration)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)

		(
			tween
			. tween_property(self, "position:x", start_x - distance, duration)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)
	if dir == "y":
		tween = create_tween()
		tween.set_loops()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

		(
			tween
			. tween_property(self, "position:y", start_y + distance, duration)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)

		(
			tween
			. tween_property(self, "position:y", start_y - distance, duration)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)


func ghost_mode_on(value) -> void:
	position.x = start_x
	position.y = start_y
	if tween:
		tween.kill()
		tween = null
	if not value:
		if not tween:
			_create_tween()
	if line_2d:
		line_2d.visible = value


func handle_platform_moving(delta) -> void:
	var mouse_pos = get_global_mouse_position()
	if is_moving:
		if dir == "x":
			var target_x = clamp(mouse_pos.x, start_x - distance, start_x + distance)
			position.x = move_toward(position.x, target_x, distance * delta)
		if dir == "y":
			var target_y = clamp(mouse_pos.y, start_y - distance, start_y + distance)
			position.y = move_toward(position.y, target_y, distance * delta)


func handle_platform_release_and_hovering() -> void:
	if Input.is_action_pressed("click") and is_hovering:
		is_moving = true
	else:
		is_moving = false

	if Input.is_action_just_released("click"):
		var mouse_pos = get_global_mouse_position()
		is_hovering = collision_shape_2d.shape.get_rect().has_point(
			collision_shape_2d.to_local(mouse_pos)
		)
		is_moving = false


func _on_area_2d_mouse_entered() -> void:
	if !Input.is_action_pressed("click"):
		is_hovering = true


func _on_area_2d_mouse_exited() -> void:
	if !is_moving:
		is_hovering = false


func _setup_line_2d() -> void:
	line_2d = Line2D.new()
	add_child(line_2d)
	line_2d.width = 20.0
	line_2d.default_color = Color.DEEP_PINK
	#line_2d.texture = platform_lines


func update_line_2d() -> void:
	if not line_2d or not GameEvents.ghost_mode:
		line_2d.visible = false
		return
	
	line_2d.visible = true
	line_2d.clear_points()
	
	var shape_rect = collision_shape_2d.shape.get_rect()
	var platform_width = shape_rect.size.x
	var platform_height = shape_rect.size.y
	
	var local_start_x = start_x - position.x
	var local_start_y = start_y - position.y
	
	if dir == "x":
		var left = local_start_x - distance - platform_width / 2.0
		var right = local_start_x + distance + platform_width / 2.0
		var top = -platform_height / 2.0
		var bottom = platform_height / 2.0

		line_2d.add_point(Vector2(left, top))
		line_2d.add_point(Vector2(right, top))
		line_2d.add_point(Vector2(right, bottom))
		line_2d.add_point(Vector2(left, bottom))
		line_2d.add_point(Vector2(left, top))
	
	elif dir == "y":
		var top = local_start_y - distance - platform_height / 2.0
		var bottom = local_start_y + distance + platform_height / 2.0
		var left = -platform_width / 2.0
		var right = platform_width / 2.0
		
		line_2d.add_point(Vector2(left, top))
		line_2d.add_point(Vector2(right, top))
		line_2d.add_point(Vector2(right, bottom))
		line_2d.add_point(Vector2(left, bottom))
		line_2d.add_point(Vector2(left, top))
