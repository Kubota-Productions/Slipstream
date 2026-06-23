extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var pos_front = get_node("../train_wheel_front").position
	var pos_back = get_node("../train_wheel_back").position
	var dir_front = get_node("../train_wheel_back").direction
	var dir_back = get_node("../train_wheel_back").direction
	
	
	position = ( pos_front + pos_back ) / 2
	var direction = ( dir_front + dir_back ) / 2
	set_train_rotation(direction)
	
func set_train_rotation(normalized_vector: Vector3):
	# Make sure the vector is normalized
	normalized_vector = normalized_vector.normalized()
	
	# Get the rotation needed for the train to look at the vector
	var basis = Basis().looking_at(normalized_vector)  # Corrected method name
	
	basis.y = Vector3(0, 1, 0)
	basis.x = normalized_vector
	basis.z = basis.x.cross(basis.y).normalized()
	
	var transform = Transform3D(basis, position)
	
	# Convert the rotation to Euler angles
	set_transform(transform)
