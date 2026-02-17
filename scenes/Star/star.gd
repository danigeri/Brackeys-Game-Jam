extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("COIN reached by : ", body)
	GameEvents.ghost_mode_on.emit(true)
