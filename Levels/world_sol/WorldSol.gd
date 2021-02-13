extends Node2D

export var timer = 0
export var MAX_TIME = 5

func _ready():
	GlobalScenes.LoadScene("sol") 
	GlobalScenes.current_scene.get_node("Player").playerStats.NewLife()
	GlobalScenes.current_scene.get_node("Player").SetInterfaceData()
func _physics_process(delta):
	timer+=delta
	
	if(GlobalScenes.current_scene.get_node("Player").playerStats.is_dead):
		print("changed worlds")
		GlobalScenes.goto_scene("sol")
		

