extends Control

signal settings_menu_requested
signal credits_menu_requested


func _on_settings_button_pressed() -> void:
	await SoundManager.play_sound_by_id(SoundManager.Sound.CLICK).finished
	settings_menu_requested.emit()


func _on_quit_button_pressed() -> void:
	await SoundManager.play_sound_by_id(SoundManager.Sound.CLICK).finished
	get_tree().quit()


func _on_credits_pressed() -> void:
	await SoundManager.play_sound_by_id(SoundManager.Sound.CLICK).finished
	credits_menu_requested.emit()


func _on_back_button_pressed() -> void:
	await SoundManager.play_sound_by_id(SoundManager.Sound.CLICK).finished
	GameEvents.menu_back_pressed.emit()
