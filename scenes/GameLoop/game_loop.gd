extends Node2D

@onready var ghost_camera: Camera2D = $GhostCamera


func _ready() -> void:
	print("ready")
	#MusicPlayer.start_music()
	GameEvents.ghost_mode_on.connect(use_ghost_camera)
	#GameEvents.ghost_mode_on.emit(false)


func use_ghost_camera(value) -> void:
	if value:
		ghost_camera.make_current()
