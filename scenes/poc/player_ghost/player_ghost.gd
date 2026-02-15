extends CharacterBody2D

var load_data : Dictionary = Dictionary()
var count = 0

func _ready():
	load_data = load_file()

func load_file() -> Dictionary:
	print(Globals.ghost_json_path % get_tree().current_scene.name)
	var path = Globals.ghost_json_path % get_tree().current_scene.name
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if not f:
		return {}
	var text := f.get_as_text()
	f.close()
	var data: Dictionary = JSON.parse_string(text)
	if typeof(data) != TYPE_DICTIONARY:
		return {}
	return data

func _physics_process(_delta):
	if !load_data.is_empty(): 
		get_recording()
	pass
	
func get_recording():
	count += 1
	var test = load_data.get(str(count))
	if(test != null):
		print(test)
		global_position = Vector2(test["x"], test["y"])
		#ani.flip_h = test[2]
	
