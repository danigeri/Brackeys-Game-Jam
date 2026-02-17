extends Node2D

var pressed_cursor: Texture2D
var default_custom_cursor: Texture2D
@onready var ghost_camera: Camera2D = $GhostCamera


func _ready() -> void:
	pressed_cursor = preload("uid://cbdwnan67004a")
	default_custom_cursor = preload("uid://cgxm8101sybcp")
	MusicPlayer.start_music()
	GameEvents.ghost_mode_on.connect(handle_ghost_mode)
	GameEvents.update_cursor()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_custom_mouse_cursor(pressed_cursor)
		else:
			Input.set_custom_mouse_cursor(default_custom_cursor)


func handle_ghost_mode(is_ghost_mode) -> void:
	use_ghost_camera(is_ghost_mode)
	GameEvents.update_cursor()


func use_ghost_camera(is_ghost_mode) -> void:
	if is_ghost_mode:
		ghost_camera.make_current()
