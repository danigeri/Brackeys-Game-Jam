extends Node2D

@export var dir: String
@export var distance: int
@export var duration: int

var is_moving = false
var is_hovering = false
var tween: Tween
var start_x: float
var start_y: float

var szaros_start_x: float
var szaros_start_y: float

# A PINA = azzal amin így tényleg mozog
@onready var PINA: CollisionShape2D = $Node2D/CharacterBody2D/CollisionShape2D

# ez nem tudom mi
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

@onready var node_2d: Node2D = $Node2D

@onready var line_2d: Line2D = $Line2D


func _ready() -> void:
	GameEvents.ghost_mode_on.connect(ghost_mode_on)
	start_x = node_2d.position.x
	start_y = node_2d.position.y
	
	szaros_start_x = position.x
	szaros_start_y = position.y
	
	_create_tween()
	
	if (dir == "x"):
		# jobb alsó
		line_2d.add_point(Vector2(start_x + distance + PINA.shape.get_rect().size.x / 2, start_y + PINA.shape.get_rect().size.y / 2))
		
		# jobb felső
		line_2d.add_point(Vector2(start_x + distance + PINA.shape.get_rect().size.x / 2, start_y - PINA.shape.get_rect().size.y / 2))
		
		# bal felső
		line_2d.add_point(Vector2(start_x - distance - PINA.shape.get_rect().size.x / 2, start_y - PINA.shape.get_rect().size.y / 2))
		
		# bal alsó
		line_2d.add_point(Vector2(start_x - distance - PINA.shape.get_rect().size.x / 2, start_y + PINA.shape.get_rect().size.y / 2))
	elif (dir == "y"):
		# jobb alsó
		line_2d.add_point(Vector2(start_x + PINA.shape.get_rect().size.x / 2, start_y + distance + PINA.shape.get_rect().size.y / 2))
		
		# jobb felső
		line_2d.add_point(Vector2(start_x + PINA.shape.get_rect().size.x / 2, start_y - distance - PINA.shape.get_rect().size.y / 2))
		
		# bal felső
		line_2d.add_point(Vector2(start_x - PINA.shape.get_rect().size.x / 2, start_y - distance - PINA.shape.get_rect().size.y / 2))
		
		# bal alsó
		line_2d.add_point(Vector2(start_x - PINA.shape.get_rect().size.x / 2, start_y + distance+ PINA.shape.get_rect().size.y / 2))
		
		
		

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
			. tween_property(node_2d, "position:x", start_x + distance, duration)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)

		(
			tween
			. tween_property(node_2d, "position:x", start_x - distance, duration)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)
	if dir == "y":
		tween = create_tween()
		tween.set_loops()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

		(
			tween
			. tween_property(node_2d, "position:y", start_y + distance, duration)
			. set_trans(Tween.TRANS_SINE)
			. set_ease(Tween.EASE_IN_OUT)
		)

		(
			tween
			. tween_property(node_2d, "position:y", start_y - distance, duration)
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
		if not tween:
			_create_tween()


func handle_platform_moving(delta) -> void:
	var mouse_pos = to_local(get_global_mouse_position())
	if is_moving:
		if dir == "x":
			var target_x = clamp(mouse_pos.x, start_x - distance, start_x + distance)
			node_2d.position.x = move_toward(node_2d.position.x, target_x, distance * delta)
		if dir == "y":
			var target_y = clamp(mouse_pos.y, start_y - distance, start_y + distance)
			node_2d.position.y = move_toward(node_2d.position.y, target_y, distance * delta)


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
