extends CharacterBody2D

var load_data : Dictionary = Dictionary()
var count = 0
var speed := 200.0
const SPEED = 200.0
const GRAVITY = 1200.0
const JUMP_FORCE = -400.0

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

func _physics_process(delta):
	if !load_data.is_empty(): 
		get_recording(delta)
	pass
func get_recording(delta):
	count += 1
	
	var frame = load_data.get(str(count))
	if frame == null:
		return
	
	var direction := 0.0
	
	if frame.get("left", false):
		direction -= 1
	if frame.get("right", false):
		direction += 1
	
	# Horizontal movement
	velocity.x = direction * SPEED
	
	# Gravity ALWAYS
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# Jump
	if frame.get("jump", false) and is_on_floor():
		velocity.y = JUMP_FORCE
	
	move_and_slide()
