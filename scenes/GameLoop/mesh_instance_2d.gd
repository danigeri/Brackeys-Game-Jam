extends MeshInstance2D


@onready var shader_mat: ShaderMaterial = material as ShaderMaterial

var tween: Tween
var is_playing: bool = false
var base_intensity: float = 0.0

func play_dream(duration: float = 5.0, peak_intensity: float = 1.0):
	if is_playing: return
	is_playing = true
	
	tween = create_tween().set_loops()
	tween.parallel().tween_property(shader_mat, "shader_parameter/wave_intensity", peak_intensity * 0.02, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(shader_mat, "shader_parameter/noise_strength", peak_intensity * 0.015, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(2.0)
	tween.parallel().tween_property(shader_mat, "shader_parameter/wave_intensity", base_intensity, 1.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(shader_mat, "shader_parameter/noise_strength", base_intensity, 1.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(func(): is_playing = false)

# Example usage: Input singleton or signal
func _input(event):
	if Input.is_action_just_pressed("up"):
		play_dream()
