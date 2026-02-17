extends Node2D

@onready var ghost_camera: Camera2D = $GhostCamera
var previous_camera: Camera2D

func _ready() -> void:
	#MusicPlayer.start_music()
	GameEvents.ghost_mode_on.connect(use_ghost_camera)
	GameEvents.ghost_mode_on.emit(false)
	
func use_ghost_camera(value) -> void:
	var current_cam = get_viewport().get_camera_2d()
	
	if value:
		if current_cam == ghost_camera:
			return
	
		previous_camera = current_cam
		ghost_camera.make_current()
	
	else:
		if current_cam != ghost_camera:
			return
	
		if previous_camera:
			previous_camera.make_current()
			previous_camera = null
