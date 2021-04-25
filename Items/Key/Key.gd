extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Key_body_entered(body):
	if "Player" in body.name:
		if (not Global.HasEncountered('key')):
			GlobalDialog.ShowDialog("first_key")
			Global.Encountered('key')
			
		GlobalScenes.RemoveSpawnable('keys', id)
		print("and collected!")
		GlobalScenes.current_scene.get_node("Player").playerStats.keys+=1
		self.queue_free()
