extends Node2D

var pressed_cursor: Texture2D
var default_custom_cursor: Texture2D
@onready var ghost_camera: Camera2D = $GhostCamera


func _ready() -> void:
	pressed_cursor = preload("uid://cbdwnan67004a")
	default_custom_cursor = preload("uid://cgxm8101sybcp")
	#MusicPlayer.start_music()
	GameEvents.ghost_mode_on.connect(handle_ghost_mode)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_custom_mouse_cursor(pressed_cursor)
		else:
			Input.set_custom_mouse_cursor(default_custom_cursor)
			
func handle_ghost_mode(is_ghost_mode)-> void:
	use_ghost_camera(is_ghost_mode)
	show_hide_cursor(is_ghost_mode)

func use_ghost_camera(is_ghost_mode) -> void:
	if is_ghost_mode:
		ghost_camera.make_current()
		
func show_hide_cursor(is_ghost_mode):
	if is_ghost_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.warp_mouse(get_viewport().get_visible_rect().size / 2)
	else: Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
