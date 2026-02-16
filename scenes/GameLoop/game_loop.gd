extends Node2D

@onready var ghost_camera: Camera2D = $GhostCamera

func _ready() -> void:
	#MusicPlayer.start_music()
	GameEvents.ghost_mode_on.connect(use_ghost_camera)
	
func use_ghost_camera(value) -> void:
	if(value):
		ghost_camera.make_current()
