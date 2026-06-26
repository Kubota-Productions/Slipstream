extends VehicleBody3D

const MAX_STEER = 1.0
const ENGINE_POWER = 300

@onready var camera_pivot = $CameraPivot
@onready var camera_3d = $CameraPivot/Camera3D
@onready var reverse_camera = $CameraPivot/ReverseCamera

@onready var active = "player"

var looking_at
var steer_input := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	looking_at = global_position

	camera_3d.current = false
	reverse_camera.current = false

func _input(_event):
	if Input.is_action_pressed("quit"):
		get_tree().quit()

func _physics_process(delta):

	if active == "car":

		# Current speed
		var speed = linear_velocity.length()

		# Steering gets smaller as speed increases
		var max_steer = lerp(MAX_STEER, MAX_STEER * 0.35, clamp(speed / 60.0, 0.0, 1.0))

		# Steering responds slower as speed increases
		var steer_speed = lerp(8.0, 1.5, clamp(speed / 60.0, 0.0, 0.01))

		# Smooth steering input
		var target_input = Input.get_axis("right", "left")
		steer_input = move_toward(steer_input, target_input, steer_speed * delta)

		# Apply steering
		steering = steer_input * max_steer

		# Engine
		engine_force = Input.get_axis("backwards", "forward") * ENGINE_POWER

		# Camera
		camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
		camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)

		looking_at = looking_at.lerp(global_position + linear_velocity, delta * 5.0)
		camera_3d.look_at(looking_at)
		reverse_camera.look_at(looking_at)

		_check_camera_switch()

func _check_camera_switch():
	if linear_velocity.dot(transform.basis.z) > -2:
		camera_3d.current = true
		reverse_camera.current = false
	else:
		camera_3d.current = false
		reverse_camera.current = true
