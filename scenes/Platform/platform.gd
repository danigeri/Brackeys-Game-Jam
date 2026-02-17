extends Node2D

@export var dir: String
@export var distance: int
@export var duration: int

var move = false
var enter = false
var tween: Tween
var start_x: float
var start_y: float


func _ready() -> void:
	GameEvents.ghost_mode_on.connect(ghost_mode_on)
	start_x = position.x
	start_y = position.y
	_create_tween()


func _physics_process(delta: float):
	handle_platform_moving(delta)
	release_platform_on_releasing_click()


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
	if value:
		position.x = start_x
		position.y = start_y
		if tween:
			tween.kill()
			tween = null
	else:
		if not tween:
			_create_tween()


func handle_platform_moving(delta) -> void:
	var mouse_pos = get_global_mouse_position()
	if move:
		if dir == "x":
			var target_x = clamp(mouse_pos.x, start_x - distance, start_x + distance)
			position.x = move_toward(position.x, target_x, distance * delta)
		if dir == "y":
			var target_y = clamp(mouse_pos.y, start_y - distance, start_y + distance)
			position.y = move_toward(position.y, target_y, distance * delta)

	if Input.is_action_pressed("click") and enter:
		move = true
	else:
		move = false


func release_platform_on_releasing_click() -> void:
	if Input.is_action_just_released("click"):
		enter = false
		move = false


func _on_area_2d_mouse_entered() -> void:
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		enter = true


func _on_area_2d_mouse_exited() -> void:
	if !move:
		enter = false
