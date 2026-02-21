extends Control

const MAIN_MENU: PackedScene = preload("uid://c64idl1pun738")

@onready var audio_player = $AspectRatioContainer/VideoStreamPlayer/AudioStreamPlayer2D
@onready var video_player = $AspectRatioContainer/VideoStreamPlayer


func _ready() -> void:
	var is_debug: bool = OS.is_debug_build()
	if is_debug:
		call_deferred("go_to_main_menu")
	else:
		video_player.play()
		video_player.paused = true
		await get_tree().create_timer(2.0).timeout
		video_player.paused = false
		audio_player.play()
		
		await video_player.finished
		go_to_main_menu()


func go_to_main_menu() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)
