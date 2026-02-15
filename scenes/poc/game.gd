extends Node2D
@onready var ghost_camera: Camera2D = $GhostCamera


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.is_ghost_mode:
		ghost_camera.make_current()
