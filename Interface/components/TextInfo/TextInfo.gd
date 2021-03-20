extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(GlobalScenes.current_scene.get_node("Player").CheckDoorCollision()):
		if(Global.playerStats.keys>0):
			text = "Press E to open the door"
		else:
			text = "This door seems to be locked..."
	else:
		text = ""
	
	
