extends Control

const GAME_LOOP = "uid://cp03gm3dbew5m"

func _ready() -> void:
	MusicPlayer.fade_in_music()


func _on_exit_button_pressed() -> void:
	await SoundManager.play_sound_by_id(SoundManager.Sound.CLICK).finished
	get_tree().quit()


func _on_start_button_pressed() -> void:
	await SoundManager.play_sound_by_id(SoundManager.Sound.CLICK).finished
	
	#TODO: Add curtain transition
	MusicPlayer.fade_out_music(1.5)
	await get_tree().create_timer(1.5).timeout
	
	
	get_tree().change_scene_to_file(GAME_LOOP)
