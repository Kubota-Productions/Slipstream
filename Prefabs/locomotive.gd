extends Node3D

var train_scene = preload("res://Prefabs/train_locomotive.tscn")
var number_of_trains = 3
var train_tops = ["1", "2", "3"]
# Called when the node enters the scene tree for the first time.
func _ready():
	#var train_instance = train_scene.instance()
	#add_child(train_instance) #train
	#add_child(train_instance) #train2
	#add_child(train_instance) #train3
	#add_child(train_instance) #train4
	
	#var wheel_front_1 = get_node("train").get_node("train_wheel_front")
	#print("wheel_front_1 = ", wheel_front_1)
	
	get_node("train").get_node("train_wheel_front").set_meta("path_offset", get_meta("path_offset_wheel_front_1"))
	get_node("train").get_node("train_wheel_back").set_meta("path_offset", get_meta("path_offset_wheel_back_1"))
	get_node("train2").get_node("train_wheel_front").set_meta("path_offset", get_meta("path_offset_wheel_front_2"))
	get_node("train2").get_node("train_wheel_back").set_meta("path_offset", get_meta("path_offset_wheel_back_2"))
	get_node("train3").get_node("train_wheel_front").set_meta("path_offset", get_meta("path_offset_wheel_front_3"))
	get_node("train3").get_node("train_wheel_back").set_meta("path_offset", get_meta("path_offset_wheel_back_3"))
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
