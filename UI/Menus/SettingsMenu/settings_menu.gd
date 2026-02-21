extends Control

@onready var master_bus_id = AudioServer.get_bus_index("Master")
@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")

@onready var sfx_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/SFXSlider
@onready var music_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/MusicSlider
@onready var master_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/MasterSlider


func _ready() -> void:
	sfx_slider.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_id)))
	music_slider.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(music_bus_id)))
	master_slider.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(master_bus_id)))


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(master_bus_id, value < 0.01)


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_id, value < 0.01)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_id, value < 0.01)


func _on_back_button_pressed() -> void:
	SoundManager.play_sound_by_id(SoundManager.Sound.CLICK)
	GameEvents.menu_back_pressed.emit()


func _on_easy_mode_checkbox_toggled(toggled_on: bool) -> void:
	GameEvents.set_easy_mode_on(toggled_on)
