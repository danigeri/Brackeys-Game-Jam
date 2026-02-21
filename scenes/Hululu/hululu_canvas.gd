extends CanvasLayer  # <-- changed from ColorRect

var shader_mat: ShaderMaterial
var tween: Tween
var is_playing: bool = false

@export var transition_duration: float = 1.3
@export var hold_duration: float = 0.0
@export var wave_intensity: float = 0.05
@export var noise_strength: float = 0.015
var ease_mode = Tween.EASE_IN_OUT

signal hululu_middle
signal dream_finished

func _ready() -> void:
	layer = 100  # renders above everything, including your game UI
	
	# Grab the shader from the child ColorRect
	var rect = $ColorRect
	rect.anchor_right = 1.0
	rect.anchor_bottom = 1.0
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shader_mat = rect.material as ShaderMaterial
	#shader_mat.set_shader_parameter("wave_intensity", 0)

func play_dream():
	if is_playing:
		return
	is_playing = true

	tween = create_tween()
	tween.parallel().tween_property(shader_mat, "shader_parameter/wave_intensity", wave_intensity, transition_duration).set_ease(ease_mode).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(shader_mat, "shader_parameter/noise_strength", noise_strength, transition_duration).set_ease(ease_mode).set_trans(Tween.TRANS_SINE)

	tween.tween_callback(func(): hululu_middle.emit())
	#tween.tween_interval(hold_duration)

	tween.parallel().tween_property(shader_mat, "shader_parameter/wave_intensity", 0.0, transition_duration).set_ease(ease_mode).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(shader_mat, "shader_parameter/noise_strength", 0.0, transition_duration).set_ease(ease_mode).set_trans(Tween.TRANS_SINE)

	tween.tween_callback(func():
		is_playing = false
		dream_finished.emit()
	)
