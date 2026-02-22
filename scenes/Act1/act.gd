extends Node2D

const MAIN_MENU: PackedScene = preload("uid://c64idl1pun738")

@onready var environment = $Environment
@onready var ghost_background: Node2D = $GhostBackground
@onready var curtain_ghost: Sprite2D = $CanvasLayer/CurtainGhost
@onready var tutorial_cursor: Node2D = $TutorialCursor
@onready var curtain: Sprite2D = $CanvasLayer/Curtain
@onready var endgame: Sprite2D = $CanvasLayer/Endgame


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
		if tutorial_cursor != null:
			tutorial_cursor.show()
			
func end_game():
	endgame.show()
	await SoundManager.play_sound_by_id(SoundManager.Sound.CHEER_GAME_FINISH).finished
	endgame.hide()
	get_tree().change_scene_to_packed(MAIN_MENU)
