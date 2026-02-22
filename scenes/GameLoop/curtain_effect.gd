extends Sprite2D

@onready var label: Label = $Label


func set_act_number(number: int) -> void:
	var act_text = "" 
	for i in range(number):
		act_text += "I"
	label.text = "Act " + str(act_text)
