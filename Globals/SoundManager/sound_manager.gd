extends Node

@export var click_sound: AudioStream
@export var platform_move_sound: AudioStream
@export var crowd_sounds: Array[AudioStream]

@onready var sfx_player: AudioStreamPlayer = $SfxPlayer


func _ready() -> void:
	sfx_player.max_polyphony = 4

# Dictionary to track which streams are currently playing
var active_sounds = {}


func play_sfx(stream: AudioStream) -> AudioStreamPlayer:
	if active_sounds.has(stream) and active_sounds[stream].is_playing():
		return active_sounds[stream]

	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	
	new_player.stream = stream
	new_player.play()
	
	active_sounds[stream] = new_player
	
	new_player.finished.connect(func():
		active_sounds.erase(stream)
		new_player.queue_free()
	)
	
	return new_player


func play_click_sound() -> AudioStreamPlayer:
	return play_sfx(click_sound)


func play_platform_move() -> AudioStreamPlayer:
	return play_sfx(platform_move_sound)


func play_random_crowd_sound() -> AudioStreamPlayer:
	printerr("Playing crowd sound")
	return play_sfx(crowd_sounds.pick_random())
