extends Node2D

@onready var environment = $Environment
@onready var ghost_background: Node2D = $GhostBackground
@onready var curtain_ghost: Sprite2D = $CurtainGhost
@onready var tutorial_cursor: Node2D = $TutorialCursor
@onready var curtain: Sprite2D = $CanvasLayer/Curtain


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.play_act(GameEvents.current_act)
	GameEvents.ghost_mode_on.connect(_handle_ghost_mode_on)


func _handle_ghost_mode_on(is_on: bool):
	handle_tutorial()
	environment.visible = not is_on
	ghost_background.visible = is_on
	curtain.visible = !is_on
	curtain_ghost.visible = is_on


func _on_area_2d_mouse_entered() -> void:
	if GameEvents.current_act == 1 && !GameEvents.tutorial_completed:
		tutorial_cursor.hide()
		GameEvents.tutorial_completed = true


func handle_tutorial() -> void:
	if GameEvents.current_act == 1 && GameEvents.ghost_mode && !GameEvents.tutorial_completed:
		tutorial_cursor.show()
