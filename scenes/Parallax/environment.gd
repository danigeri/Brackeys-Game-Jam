extends Node2D

const CURTAIN_GHOST_RUN_BG = preload("uid://cmmtqnqiedirl")
const CURTAIN_RECORD_RUN = preload("uid://bgdi2w3ntqvwv")

@onready var curtain: Sprite2D = $Curtain


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.ghost_mode_on.connect(handle_ghost_mode)


func handle_ghost_mode(is_on) -> void:
	if is_on:
		curtain.texture = CURTAIN_GHOST_RUN_BG
	else:
		curtain.texture = CURTAIN_RECORD_RUN
