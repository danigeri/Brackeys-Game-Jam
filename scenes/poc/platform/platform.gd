extends Node2D

var move = false
var enter = false
@export var dir: String;
@export var distance: int
@export var duration: int

func _ready() -> void:
	if !Globals.is_ghost_mode:
		var start_x = position.x
		var start_y = position.y

		if dir == "x":
			var tween = create_tween()
			tween.set_loops()
			tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

			tween.tween_property(self, "position:x", start_x + distance, duration)\
				.set_trans(Tween.TRANS_SINE)\
				.set_ease(Tween.EASE_IN_OUT)

			tween.tween_property(self, "position:x", start_x - distance, duration)\
				.set_trans(Tween.TRANS_SINE)\
				.set_ease(Tween.EASE_IN_OUT)
		if dir == "y":
			var tween = create_tween()
			tween.set_loops()
			tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

			tween.tween_property(self, "position:y", start_y + distance, duration)\
				.set_trans(Tween.TRANS_SINE)\
				.set_ease(Tween.EASE_IN_OUT)

			tween.tween_property(self, "position:y", start_y - distance, duration)\
				.set_trans(Tween.TRANS_SINE)\
				.set_ease(Tween.EASE_IN_OUT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float):
	var mouse_pos = get_global_mouse_position()
	if move:
		if dir == "x":
			position.x = mouse_pos.x
		if dir == "y":
			position.y = mouse_pos.y
		
	if Input.is_action_pressed("click") and enter:
		move = true
	else: 
		move = false 
		

func _on_area_2d_mouse_entered() -> void:
	enter = true

func _on_area_2d_mouse_exited() -> void:
	if !move: 
		enter = false
