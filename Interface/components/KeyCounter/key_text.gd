extends Label

func _ready():
	text = String(GlobalScenes.current_scene.get_node("Player").playerStats.keys)

func _physics_process(delta):
	text = String(GlobalScenes.current_scene.get_node("Player").playerStats.keys)
	
	
