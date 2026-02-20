extends Node2D

@onready var environment: Node2D = $Environment
@onready var ghost_background: Sprite2D = $GhostBackground

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.ghost_mode_on.connect(_handle_ghost_mode_on)
	
	
func _handle_ghost_mode_on(is_on: bool):
	environment.visible = not is_on
	ghost_background.visible = is_on
