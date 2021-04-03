extends TextureProgress

export var NAME =""

var max_val =  100
func _ready():
	UpdateProgress()

func _physics_process(delta):
	UpdateProgress()
	
func UpdateProgress():
	value = GlobalScenes.current_scene.get_node("Player").playerStats.GetProgressValue(NAME)
	
	
