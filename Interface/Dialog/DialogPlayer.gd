extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var animationPlayer = get_node("DialogBox/Body/AnimationPlayer")
onready var label = get_node("DialogBox/Body/Label")

func _ready():
	visible = false

func Close():
	visible = false
	
func LoadDialog(text):
	visible = true
	label.text = text
	animationPlayer.play('loadText')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
