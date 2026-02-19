extends Area2D

var is_ghost_mode: bool = false


func _ready() -> void:
	GameEvents.ghost_mode_on.connect(ghost_mode_on)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		death_counter_add()
		#print("colliding element: ", body)
		if is_ghost_mode:
			GameEvents.set_ghost_mode(true)
		else:
			GameEvents.set_ghost_mode(false)

func death_counter_add() -> void:
	if GameEvents.ghost_mode:
		GameEvents.death_counter += 1
		print(GameEvents.death_counter)

func ghost_mode_on(is_on):
	is_ghost_mode = is_on
