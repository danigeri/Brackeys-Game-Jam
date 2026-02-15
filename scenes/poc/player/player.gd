extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -450.0
var doubleJumpAvailable = true 
var path : String

var count = 0
#Our dictionary we store values too
#var save_data = {"0": ["nothing",Vector2(0,0),false]}
var save_data = {"0": {"x":0.0,"y":0.0}}
#@onready var ani = $AnimatedSprite
func _ready():
	path = Globals.ghost_json_path % get_tree().current_scene.name
	if FileAccess.file_exists(path):
		Globals.is_ghost_mode = true
		var ghost_scene := preload("uid://gnjaasv8ldx4")
		var load_ghost := ghost_scene.instantiate()
		load_ghost.global_position = global_position
		get_parent().call_deferred("add_child", load_ghost)

func do_record():
	count += 1
	save_data[str(count)] = {"x": global_position.x, "y": global_position.y}
	if Input.is_action_just_pressed("ui_down"):
		path = Globals.ghost_json_path % get_tree().current_scene.name
		# make sure the folder exists
		DirAccess.make_dir_recursive_absolute("user://ghosts")
		var f := FileAccess.open(path, FileAccess.WRITE)
		if f:
			prints("Saving to", path)
			f.store_string(JSON.stringify(save_data))
			f.close()
func _physics_process(delta: float) -> void:
	do_record()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or doubleJumpAvailable):
		doubleJumpAvailable = false
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_floor() and !doubleJumpAvailable:
		doubleJumpAvailable = true
		
	move_and_slide()
