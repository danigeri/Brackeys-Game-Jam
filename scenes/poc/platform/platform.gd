extends Node2D

var move = false
var enter = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if !Globals.is_ghost_mode:
		start_moving()

func start_moving():
	animation_player.play("move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float):
	var mouse_pos = get_global_mouse_position()
	if move:
		position.x = mouse_pos.x
	if Input.is_action_pressed("click") and enter:
		move = true
	else: 
		move = false 

func _on_area_2d_mouse_entered() -> void:
	enter = true


func _on_area_2d_mouse_exited() -> void:
	if !move: 
		enter = false
