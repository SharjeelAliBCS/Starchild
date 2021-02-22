extends Node2D

export var timer = 0
export var MAX_TIME = 5

func _ready():
	GlobalScenes.LoadScene("void")
	GlobalScenes.current_scene.get_node("Player").SetInterfaceData()
	
func _physics_process(delta):
	timer+=delta
	
	if(GlobalScenes.current_scene.get_node("Player").playerStats.is_dead):
		print("changed worlds")
		GlobalScenes.goto_scene("sol")
		
	if Input.is_action_just_pressed("open_portal") and GlobalScenes.current_scene.get_node("Player").playerStats.OpenPortal():
		GlobalScenes.goto_scene("reality")
		
	
		
	
