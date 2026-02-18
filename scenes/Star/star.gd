extends Area2D

signal collected(star)

enum StarType { OPTIONAL, REQUIRED }

var collected_once : bool = false

@export var star_type : StarType = StarType.OPTIONAL

func _ready():
	add_to_group("stars")

func _on_body_entered(body):
	print("COLLISION: ", body.is_in_group("Player"))
	if body.is_in_group("Player"):
		if collected_once:
			return
		
		print("STAR reached by : ", body, ", star: " , self)
		if body is CharacterBody2D:
			collected_once = true
			collected.emit(self)
			hide()
			$CollisionShape2D.disabled = true
			#queue_free()
		
func reset_star():
	print("STAR RESET :" , self)
	collected_once = false
	show()
	$CollisionShape2D.disabled = false
