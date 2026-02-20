extends Control

signal settings_menu_requested
signal credits_menu_requested


func _on_settings_button_pressed() -> void:
	SoundManager.play_sound_by_id(SoundManager.Sound.CLICK)
	settings_menu_requested.emit()


func _on_quit_button_pressed() -> void:
	SoundManager.play_sound_by_id(SoundManager.Sound.CLICK)
	get_tree().quit()


func _on_credits_pressed() -> void:
	SoundManager.play_sound_by_id(SoundManager.Sound.CLICK)
	credits_menu_requested.emit()


func _on_back_button_pressed() -> void:
	SoundManager.play_sound_by_id(SoundManager.Sound.CLICK)
	GameEvents.menu_back_pressed.emit()
