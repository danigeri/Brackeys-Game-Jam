extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.records_completed.connect(func():
		print("receive")
		fade_in_overlay()
	)
	GameEvents.ghost_mode_on.connect(func(_on: bool):
		fade_out_overlay()
	)

func fade_in_overlay() -> void:
	modulate.a = 0.0
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)


func fade_out_overlay() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(hide)

func _input(event) -> void:
	if visible and event.is_action_pressed("retry"):
		GameEvents.set_ghost_mode(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
