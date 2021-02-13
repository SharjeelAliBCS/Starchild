extends Label

func _ready():
	text = String(GlobalScenes.current_scene.get_node("Player").playerStats.hydrogen_orbs)

func _physics_process(delta):
	text = String(GlobalScenes.current_scene.get_node("Player").playerStats.hydrogen_orbs)
	
	
