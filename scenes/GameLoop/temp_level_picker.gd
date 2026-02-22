extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


func _on_button_pressed() -> void:
	GameEvents.change_act_to(1)
	GameEvents._set_ghost_mode(false)


func _on_button_2_pressed() -> void:
	GameEvents.change_act_to(2)
	GameEvents._set_ghost_mode(false)


func _on_button_3_pressed() -> void:
	GameEvents.change_act_to(3)
	GameEvents._set_ghost_mode(false)
