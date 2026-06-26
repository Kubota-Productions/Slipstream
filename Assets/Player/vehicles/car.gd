extends VehicleBody3D

const  MAX_STEER = 0.4
const  ENGINE_POWER = 300
const  DRIFT = 0.0

var speed = linear_velocity.length()
var steer_multiplier = lerp(1.0, 0.1, clamp(speed / 90.0, 0.0, 0.01))
var max_steer = MAX_STEER * steer_multiplier

@onready var camera_pivot = $CameraPivot
@onready var camera_3d = $CameraPivot/Camera3D
@onready var reverse_camera = $CameraPivot/ReverseCamera
@onready 	var active = "player"

var looking_at

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	looking_at = global_position
	
	camera_3d.current = false
	reverse_camera.current = false

func _input(_event):
		if Input.is_action_pressed("quit"):
			get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if active == "car":
		steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 2.5)
		engine_force = Input.get_axis("backwards", "forward") * ENGINE_POWER
		
		camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
		camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
		looking_at = looking_at.lerp(global_position + linear_velocity, delta * 5.0)
		camera_3d.look_at(looking_at)
		reverse_camera.look_at(looking_at)
		_check_camera_switch()
		
func _check_camera_switch():
	if linear_velocity.dot(transform.basis.z) > -2:
		camera_3d.current = true
	else:
		reverse_camera.current = true
 
