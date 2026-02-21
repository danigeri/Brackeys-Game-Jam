extends Sprite2D

@onready var label: Label = $Label


func set_act_number(number: int) -> void:
	label.text = "Act " + str(number)
