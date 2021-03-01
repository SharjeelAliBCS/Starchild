extends Node2D

export var timer = 0
export var MAX_TIME = 5

var next_meteor_time

func _ready():
	GlobalScenes.LoadScene("reality") 
	GlobalScenes.current_scene.get_node("Player").SetInterfaceData()
	
	SetMeteorSpawnTimer()
		
func SetMeteorSpawnTimer():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	var next_time = rand.randf_range(2, 5)

	next_meteor_time = timer+next_time
	
func SpawnMeteor():
	
	var rand = RandomNumberGenerator.new()
	var meteor_scene = load("res://Entities/Meteor/Meteor.tscn")
	var screen_size = get_viewport().get_visible_rect().size
	
	var camera_pos = GlobalScenes.current_scene.get_node("Player").get_node("Camera2D").get_camera_position()
	
	var meteor = meteor_scene.instance()
	rand.randomize()
	var x  = rand.randf_range(camera_pos.x-screen_size.x/2,camera_pos.x+screen_size.x/2)
	rand.randomize()
	var y  = camera_pos.y-screen_size.y*0.6
	meteor.position.y = y
	meteor.position.x = x
	add_child(meteor)
		
	SetMeteorSpawnTimer()
		

func _physics_process(delta):
	timer+=delta
	
	if(timer>=next_meteor_time):
		SpawnMeteor()
		
	if(GlobalScenes.current_scene.get_node("Player").playerStats.is_dead):
		print("changed worlds")
		GlobalScenes.goto_scene("sol")
	
	if Input.is_action_just_pressed("open_portal") and GlobalScenes.current_scene.get_node("Player").playerStats.OpenPortal():
		GlobalScenes.goto_scene("void")
	
	
