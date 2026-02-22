extends Sprite2D

@onready var label: Label = $Label
@onready var subtitle: Label = $Subitle


func set_act_number(number: int) -> void:
	var act_text = "" 
	for i in range(number):
		act_text += "I"
	label.text = "Act " + str(act_text)
	var new_subtitle = "Firenze"
	match number:
		1: new_subtitle = "Firenze"
		2: new_subtitle = "Inferno"
		3: new_subtitle = "Paradiso"
	subtitle.text = new_subtitle
	
	
