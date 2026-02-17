extends Node2D

var pressed_cursor: Texture2D
var default_custom_cursor: Texture2D
@onready var ghost_camera: Camera2D = $GhostCamera


func _ready() -> void:
	pressed_cursor = preload("uid://cbdwnan67004a")
	default_custom_cursor =preload("uid://cgxm8101sybcp")
	#MusicPlayer.start_music()
	GameEvents.ghost_mode_on.connect(use_ghost_camera)
	#GameEvents.ghost_mode_on.emit(false)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_custom_mouse_cursor(pressed_cursor)
		else:
			Input.set_custom_mouse_cursor(default_custom_cursor)

func use_ghost_camera(value) -> void:
	if value:
		ghost_camera.make_current()
