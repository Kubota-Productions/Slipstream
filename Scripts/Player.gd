extends CharacterBody3D

signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)

@export var movement_states : Dictionary

var movement_direction : Vector3

# Timer to track sprint duration
var sprint_timer: float = 0.0
# Threshold for transitioning to sprint
const SPRINT_THRESHOLD: float = 1.0

func _input(event):
	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		movement_direction.z = Input.get_action_strength("backwards") - Input.get_action_strength("forward")
		
		if is_movement_ongoing():
			if Input.is_action_pressed("sprint"):
				# Increment the sprint timer
				sprint_timer += get_physics_process_delta_time()
				if sprint_timer > SPRINT_THRESHOLD:
					set_movement_state.emit(movement_states["run"])
				else:
					set_movement_state.emit(movement_states["sprint"])
			else:
				# Reset the sprint timer if sprint button is not pressed
				sprint_timer = 0.0
				set_movement_state.emit(movement_states["walk"])
		else:
			set_movement_state.emit(movement_states["idle"])
		
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_pressed("Interact"):
		var car = get_node("../car")
		print(car)
		# Calculate the distance between the current node and the car node
		var distance = self.global_transform.origin.distance_to(car.global_transform.origin)

		print("Distance to car:", distance)
		
		var boardedCar = false
		
		if distance < 5.0:
			if car.active == "player":
				boardedCar = true
				visible = false
				car.active = "car"
				var player_camera = $CameraRoot/CamYaw/CamPitch/SpringArm3D/Camera3D
				player_camera.current = false
				car.camera_3d.current = true
		if car.active == "car" and boardedCar == false:
			visible = true
			car.active = "player"
			position = car.position + Vector3(5,0,0)
			var player_camera = $CameraRoot/CamYaw/CamPitch/SpringArm3D/Camera3D
			player_camera.current = true
			car.camera_3d.current = false

func _ready():
	set_movement_state.emit(movement_states["idle"])
	
func _physics_process(delta):
	var car = get_node("../car")
	var active = car.active
	#if active == "car":
		#position = car.position + Vector3(0,20,0)
	
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)
		
		velocity.y -= 10 * delta
		
		move_and_slide()
		
func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
