extends Node2D

@onready var background: Sprite2D = $Background
@onready var ghost_background: Sprite2D = $GhostBackground
@onready var ghost_background_layer_2: Sprite2D = $GhostBackgroundLayer2
@onready var curtain: Sprite2D = $Curtain
@onready var curtain_ghost: Sprite2D = $CurtainGhost


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.play_act(GameEvents.current_act)
	GameEvents.ghost_mode_on.connect(_handle_ghost_mode_on)


func _handle_ghost_mode_on(is_on: bool):
	background.visible = not is_on
	ghost_background.visible = is_on
	ghost_background_layer_2.visible = is_on
	curtain.visible = !is_on
	curtain_ghost.visible = is_on
