extends Area2D

signal collected(star)

enum StarType { OPTIONAL, REQUIRED }

@export var star_type: StarType = StarType.OPTIONAL

var collected_once: bool = false
var noise := FastNoiseLite.new()
var time_passed := 0.0

@onready var point_light_2d: PointLight2D = $PointLight2D


func _ready() -> void:
	noise.frequency = 5.0


func _process(delta):
	time_passed += delta
	var n = noise.get_noise_1d(time_passed)
	point_light_2d.energy = 0.3 + n * 0.05


func _on_body_entered(body):
	if body.is_in_group("Player"):
		if collected_once:
			return
		if body is CharacterBody2D:
			collected_once = true
			collected.emit(self)
			_play_collect_animation()

func _play_collect_animation():
	var tween = create_tween()
	#tween.set_parallel(true)  # run scale + fade at the same time
	tween.tween_property(self, "scale", Vector2.ZERO, 0.1)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	#tween.tween_property(self, "modulate:a", 0.0, 0.2)
	await tween.finished
	hide()

func reset_star():
	collected_once = false
	scale = Vector2.ONE # restore scale
	#modulate.a = 1.0 # restore alpha
	show()
