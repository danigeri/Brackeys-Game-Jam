extends Node

const SILENCE_DB = -80.0
const NORMAL_DB = 0.0

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func fade_in_music() -> void:
	audio_stream_player.volume_db = SILENCE_DB
	audio_stream_player.play()
	
	var tween = create_tween()
	tween.tween_property(audio_stream_player, "volume_db", NORMAL_DB, 2.0)


func fade_out_music(duration: float = 2.0) -> AudioStreamPlayer:
	var tween = create_tween()
	tween.tween_property(audio_stream_player, "volume_db", SILENCE_DB, duration)
	tween.finished.connect(audio_stream_player.stop)
	
	return audio_stream_player
