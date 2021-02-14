extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_UnknownSecretion_body_entered(body):
	if "Player" in body.name:
		print("and collected!")
		GlobalScenes.current_scene.get_node("Player").playerStats.unknown_secretions+=1
		self.queue_free()
		
